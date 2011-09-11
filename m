Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:63713 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286Ab1IKDvo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Sep 2011 23:51:44 -0400
Received: by gxk21 with SMTP id 21so2657007gxk.5
        for <linux-wireless@vger.kernel.org>; Sat, 10 Sep 2011 20:51:44 -0700 (PDT)
Message-ID: <4E6C304B.6050306@lwfinger.net> (sfid-20110911_055148_882448_7AF49098)
Date: Sat, 10 Sep 2011 22:51:39 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "Steven A. Falco" <sfalco@coincident.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [Question] Realtek USB 0bda:8176 as AP?
References: <4E6C0AC8.9050805@coincident.com>
In-Reply-To: <4E6C0AC8.9050805@coincident.com>
Content-Type: multipart/mixed;
 boundary="------------050807090300040304090905"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050807090300040304090905
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 09/10/2011 08:11 PM, Steven A. Falco wrote:
> I am attempting to use a Realtek USB dongle as an access point on
> a PC running Fedora 15, with hostapd as the user-layer SW.
>
> The USB ID is 0bda:8176, which makes this an rtlwifi:rtl8192cu
> device.

What kernel are you running? The latest is in wireless-testing, but that will be 
difficult to clone as long as kernel.org is out of commission. In addition, 
there are two patches that were sent on 9/3, but have not yet been incorporated 
due to the k.o problems. They are attached.

I just got a Powermac G4 and I'm fixing the big-endian issues, but that is 
clearly not your problem.

Larry


--------------050807090300040304090905
Content-Type: text/x-patch;
 name="0001-rtlwifi-rtl8192cu-Fix-problem-connecting-to-HT-enabl.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-rtlwifi-rtl8192cu-Fix-problem-connecting-to-HT-enabl.pa";
 filename*1="tch"

>From b29f825b3c7a495ecf415d2810cae9d2f110f05f Mon Sep 17 00:00:00 2001
From: George <george0505@realtek.com>
Date: Sat, 3 Sep 2011 10:44:32 -0500
Subject: [PATCH 1/2] rtlwifi: rtl8192cu: Fix problem connecting to HT-enabled AP
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,chaoming_li@realsil.com.cn


The driver fails to connect to 802.11n-enabled APs. The patch fixes
Bug #42262.

Signed-off-by: George <george0505@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@kernel.org>        [2.6.39+]
---
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c b/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
index a8e87ad..f875fed 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
@@ -546,15 +546,16 @@ void rtl92cu_tx_fill_desc(struct ieee80211_hw *hw,
 			       (tcb_desc->rts_use_shortpreamble ? 1 : 0)
 			       : (tcb_desc->rts_use_shortgi ? 1 : 0)));
 	if (mac->bw_40) {
-		if (tcb_desc->packet_bw) {
+		if (rate_flag & IEEE80211_TX_RC_DUP_DATA) {
 			SET_TX_DESC_DATA_BW(txdesc, 1);
 			SET_TX_DESC_DATA_SC(txdesc, 3);
+		} else if(rate_flag & IEEE80211_TX_RC_40_MHZ_WIDTH){
+			SET_TX_DESC_DATA_BW(txdesc, 1);
+			SET_TX_DESC_DATA_SC(txdesc, mac->cur_40_prime_sc);
 		} else {
 			SET_TX_DESC_DATA_BW(txdesc, 0);
-				if (rate_flag & IEEE80211_TX_RC_DUP_DATA)
-					SET_TX_DESC_DATA_SC(txdesc,
-							  mac->cur_40_prime_sc);
-			}
+			SET_TX_DESC_DATA_SC(txdesc, 0);
+		}
 	} else {
 		SET_TX_DESC_DATA_BW(txdesc, 0);
 		SET_TX_DESC_DATA_SC(txdesc, 0);
-- 
1.7.6.1


--------------050807090300040304090905
Content-Type: text/x-patch;
 name="0002-rtlwifi-Fix-problem-when-switching-connections.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0002-rtlwifi-Fix-problem-when-switching-connections.patch"

>From 811462b15d9e9a23ee6d113ec652c57628230a7b Mon Sep 17 00:00:00 2001
From: George <george0505@realtek.com>
Date: Sat, 3 Sep 2011 10:47:14 -0500
Subject: [PATCH 2/2] rtlwifi: Fix problem when switching connections
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,chaoming_li@realsil.com.cn

The driver fails to clear encryption keys making it impossible
to switch connections.

Signed-off-by: George <george0505@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@kernel.org>        [2.6.39+]
---
 drivers/net/wireless/rtlwifi/core.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/core.c b/drivers/net/wireless/rtlwifi/core.c
index 1bdc1aa..04c4e9e 100644
--- a/drivers/net/wireless/rtlwifi/core.c
+++ b/drivers/net/wireless/rtlwifi/core.c
@@ -610,6 +610,11 @@ static void rtl_op_bss_info_changed(struct ieee80211_hw *hw,
 
 			mac->link_state = MAC80211_NOLINK;
 			memset(mac->bssid, 0, 6);
+
+			/* reset sec info */
+			rtl_cam_reset_sec_info(hw);
+
+			rtl_cam_reset_all_entry(hw);
 			mac->vendor = PEER_UNKNOWN;
 
 			RT_TRACE(rtlpriv, COMP_MAC80211, DBG_DMESG,
@@ -1063,6 +1068,9 @@ static int rtl_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		 *or clear all entry here.
 		 */
 		rtl_cam_delete_one_entry(hw, mac_addr, key_idx);
+
+		rtl_cam_reset_sec_info(hw);
+
 		break;
 	default:
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-- 
1.7.6.1


--------------050807090300040304090905--
