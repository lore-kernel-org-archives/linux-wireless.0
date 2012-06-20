Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:54791 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754452Ab2FTT7Q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 15:59:16 -0400
Message-ID: <4FE22B8B.4060405@openwrt.org> (sfid-20120620_215923_667187_0165E376)
Date: Wed, 20 Jun 2012 21:59:07 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: WEP-LEAP regression
References: <20120620143330.GA8505@redhat.com>
In-Reply-To: <20120620143330.GA8505@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-06-20 4:33 PM, Stanislaw Gruszka wrote:
> Our QA reported regression on ath9k connecting to legacy WEP-LEAP AP,
> with the following supplicant parameters:
> 
> fast_reauth=1
> ap_scan=1
> 
> eapol_version=1
> 
> network={
>         ssid="qe-wep-enterprise-cisco"
>         key_mgmt=IEEE8021X
>         auth_alg=LEAP
>         eap=LEAP
>         identity="AAA"
>         password="BBB"
> }
> 
> Device associate but DHCP fails (we do no recive any frame).
> 
> Reverting both related commits:
> 
> commit f88373fa47f3ce6590fdfaa742d0ddacc2ae017f
> Author: Felix Fietkau <nbd@openwrt.org>
> Date:   Sun Feb 5 21:15:17 2012 +0100
> 
>     ath9k: fix a WEP crypto related regression
> 
> and
>  
> commit 7a532fe7131216a02c81a6c1b1f8632da1195a58
> Author: Felix Fietkau <nbd@openwrt.org>
> Date:   Sat Jan 14 15:08:34 2012 +0100
> 
>     ath9k_hw: fix interpretation of the rx KeyMiss flag
> 
> fixes the problem.
> 
> Felix could you look at this?
Please try this patch:

--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -143,6 +143,7 @@ struct ath_common {
 	u32 keymax;
 	DECLARE_BITMAP(keymap, ATH_KEYMAX);
 	DECLARE_BITMAP(tkip_keymap, ATH_KEYMAX);
+	DECLARE_BITMAP(ccmp_keymap, ATH_KEYMAX);
 	enum ath_crypt_caps crypt_caps;
 
 	unsigned int clockrate;
--- a/drivers/net/wireless/ath/key.c
+++ b/drivers/net/wireless/ath/key.c
@@ -556,6 +556,9 @@ int ath_key_config(struct ath_common *co
 		return -EIO;
 
 	set_bit(idx, common->keymap);
+	if (key->cipher == WLAN_CIPHER_SUITE_CCMP)
+		set_bit(idx, common->ccmp_keymap);
+
 	if (key->cipher == WLAN_CIPHER_SUITE_TKIP) {
 		set_bit(idx + 64, common->keymap);
 		set_bit(idx, common->tkip_keymap);
@@ -582,6 +585,7 @@ void ath_key_delete(struct ath_common *c
 		return;
 
 	clear_bit(key->hw_key_idx, common->keymap);
+	clear_bit(key->hw_key_idx, common->ccmp_keymap);
 	if (key->cipher != WLAN_CIPHER_SUITE_TKIP)
 		return;
 
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -785,7 +785,8 @@ static bool ath9k_rx_accept(struct ath_c
 	 * descriptor does contain a valid key index. This has been observed
 	 * mostly with CCMP encryption.
 	 */
-	if (rx_stats->rs_keyix == ATH9K_RXKEYIX_INVALID)
+	if (rx_stats->rs_keyix == ATH9K_RXKEYIX_INVALID ||
+	    !test_bit(rx_stats->rs_keyix, common->ccmp_keymap))
 		rx_stats->rs_status &= ~ATH9K_RXERR_KEYMISS;
 
 	if (!rx_stats->rs_datalen) {

