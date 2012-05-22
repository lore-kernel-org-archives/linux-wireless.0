Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:50659 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755502Ab2EVHiB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 May 2012 03:38:01 -0400
From: Amit Shakya <amit.shakya@stericsson.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amit Shakya <amit.shakya@stericsson.com>
Subject: [PATCH v1] mac80211: Handle race condition in replay handling
Date: Tue, 22 May 2012 13:07:19 +0530
Message-ID: <1337672239-27902-1-git-send-email-amit.shakya@stericsson.com> (sfid-20120522_093809_042355_68F18523)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Added fix for the issue where the Rx throughput use to get stuck,
with unicast key rotation feature enabled in the Cisco AP. In
this architecture, packet decryption is done at FW and reordering
and replay detection is done by MAC.

The issue is that due to race condition during EAPOL key
handshake and packet reception, the PN gets reset at MAC, while
it still receives previous PN range packets for a while.

The race condition is due to delay, when the EAPOL is received by
supplicant till new key applied (PN reset at MAC) at FW. During
this period, due to ongoing high throughput, some packets are
received, which are decrypted by FW with old key and had been
handed over to host driver but not yet delivered to MAC or are
in transit from FW to the host driver to be finally delivered to
MAC. They have been decrypted successfully by the FW using the
old key during this phase but not yet received by MAC.

In this race condition scenario, MAC's __ieee80211_key_replace
function is invoked to apply the new keys. It replaces the key
entry in sta->ptk to the new key entry (PN reset to 0). Note,
the sta is connected all this while and just the PTK is renewed.
However due to race condition mentioned earlier, it is still
receiving old PN packets from driver. At this point of time on
receiving old PN packets, ieee80211_rx_h_decrypt will just
dereference the new key entry from rx->sta->ptk and store it
in rx->key.

Refer code
	if (rx->sta)
		sta_ptk = rcu_dereference(rx->sta->ptk);

...
	if (!is_multicast_ether_addr(hdr->addr1) && sta_ptk) {
		rx->key = sta_ptk;


Now within ieee80211_crypto_ccmp_decrypt function, this key is
dereferenced and used for key replay detection as well as the
received PN is also updated in it.

Refer code
 	memcpy(key->u.ccmp.rx_pn[queue], pn, CCMP_PN_LEN);

This triggers the issue wherein the PN gets updated with the
old PN.

As a result, when this change in sequence number happens, the
replay detection handling in MAC gets triggered, causing the
traffic to stops for some while till PN re-match, with the
one last updated at MAC.

The fix takes care of selectively updating the Rx PN during
this transition phase.

Signed-off-by: Amit Shakya <amit.shakya@stericsson.com>
---
 net/mac80211/key.c |    9 +++++++++
 net/mac80211/key.h |    1 +
 net/mac80211/wpa.c |   35 ++++++++++++++++++++++++++++++++++-
 3 files changed, 44 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index 5bb600d..461bb7c 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -278,6 +278,15 @@ static void __ieee80211_key_replace(struct ieee80211_sub_if_data *sdata,
 		list_add_tail(&new->list, &sdata->key_list);
 
 	if (sta && pairwise) {
+		if (old && new &&
+			(new->conf.cipher == WLAN_CIPHER_SUITE_CCMP)) {
+			int i;
+			for (i = 0; i < NUM_RX_DATA_QUEUES + 1; i++) {
+				memcpy(new->u.ccmp.prev_rx_pn[i],
+				old->u.ccmp.prev_rx_pn[i], CCMP_PN_LEN);
+			}
+		}
+
 		rcu_assign_pointer(sta->ptk, new);
 	} else if (sta) {
 		if (old)
diff --git a/net/mac80211/key.h b/net/mac80211/key.h
index 7d4e31f..e0d9728 100644
--- a/net/mac80211/key.h
+++ b/net/mac80211/key.h
@@ -93,6 +93,7 @@ struct ieee80211_key {
 			 * Management frames.
 			 */
 			u8 rx_pn[NUM_RX_DATA_QUEUES + 1][CCMP_PN_LEN];
+			u8 prev_rx_pn[NUM_RX_DATA_QUEUES + 1][CCMP_PN_LEN];
 			struct crypto_cipher *tfm;
 			u32 replays; /* dot11RSNAStatsCCMPReplays */
 		} ccmp;
diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index 0ae23c6..e1c3612 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -482,6 +482,7 @@ ieee80211_crypto_ccmp_decrypt(struct ieee80211_rx_data *rx)
 	u8 pn[CCMP_PN_LEN];
 	int data_len;
 	int queue;
+	static const u8 zero_pn[6] = {0};
 
 	hdrlen = ieee80211_hdrlen(hdr->frame_control);
 
@@ -523,7 +524,39 @@ ieee80211_crypto_ccmp_decrypt(struct ieee80211_rx_data *rx)
 			return RX_DROP_UNUSABLE;
 	}
 
-	memcpy(key->u.ccmp.rx_pn[queue], pn, CCMP_PN_LEN);
+	/* As long as u.ccmp.rx_pn and u.ccmp.prev_rx_pn are equal, no
+	race condition induced.
+	It is seen that with Cisco AP and with PTK re-negotiation feature
+	enabled on Cisco to do key-negotiaton periodically, even after the
+	RX PN is reset by the supplicant, at MAC, we still keep getting
+	previous RX PN packets.
+	This is due to race condition when this feature is enabled with
+	throughput test and is introduced because of the combination of
+	different TIDs used for data and EAPOL packets and aggregation.
+	The RX PN gets reset to lower value after a while and at that time
+	the RX PN value becomes lower then the maintained current PN at MAC.
+	As a result, the replay detection code chips in and starts dropping all
+	packets till the PN re-match. This causes throughput to stall
+	intermittently for the duration till RX PN match with current PN.
+	So to take care of this we maintain u.ccmp.prev_rx_pn, which doesn't get
+	reset when new PTK is plumbed by supplicant and use it for detecting
+	this transition i.e. from higher PN to lower PN and once this situation
+	happens start updating u.ccmp.rx_pn and thereafter u.ccmp.rx_pn and
+	u.ccmp.prev_rx_pn should be same. In normal scenario, i.e. no new key
+	plumbed both counters should be same. */
+	if ((memcmp(key->u.ccmp.prev_rx_pn[queue],
+		key->u.ccmp.rx_pn[queue], CCMP_PN_LEN) == 0) ||
+		(memcmp(key->u.ccmp.prev_rx_pn[queue], pn, CCMP_PN_LEN) > 0)) {
+		memcpy(key->u.ccmp.rx_pn[queue], pn, CCMP_PN_LEN);
+		memcpy(key->u.ccmp.prev_rx_pn[queue], pn, CCMP_PN_LEN);
+	}
+
+	/* If u.ccmp.rx_pn gets reset to zero due to PTK re-negotiaton then
+	don't update it and just keep updating the u.ccmp.prev_rx_pn.
+	This is to detect the transition that will happen later i.e. from higher
+	RX PN to lower RX PN in case of race condition scenario. */
+	if (memcmp(key->u.ccmp.rx_pn[queue], zero_pn, CCMP_PN_LEN) == 0)
+		memcpy(key->u.ccmp.prev_rx_pn[queue], pn, CCMP_PN_LEN);
 
 	/* Remove CCMP header and MIC */
 	if (pskb_trim(skb, skb->len - CCMP_MIC_LEN))
-- 
1.7.0.4

