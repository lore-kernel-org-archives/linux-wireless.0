Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:22292 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755462Ab2DIO7f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Apr 2012 10:59:35 -0400
Message-ID: <4F82F950.3020006@qca.qualcomm.com> (sfid-20120409_170011_355523_19D9B214)
Date: Mon, 9 Apr 2012 20:29:28 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>,
	Subramania Sharma <sharmat@qca.qualcomm.com>
Subject: Re: [PATCH] ath6kl: Fix 4-way handshake failure in AP and P2P GO
 mode
References: <1333644981-3721-1-git-send-email-vthiagar@qca.qualcomm.com> <4F82F66E.8000800@qca.qualcomm.com>
In-Reply-To: <4F82F66E.8000800@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On Monday 09 April 2012 08:17 PM, Kalle Valo wrote:
> On 04/05/2012 07:56 PM, Vasanthakumar Thiagarajan wrote:
>> RSN capability field of RSN IE which is generated (which is what really
>> advertised in beacon/probe response) differs from the one generated in
>> wpa_supplicant. This inconsistency in rsn IE results in 4-way handshake
>> failure. To fix this, configure rsn capability used in wpa_supplicant
>> in firmware using a new wmi command, WMI_SET_IE_CMDID. There is a bit
>> (ATH6KL_FW_CAPABILITY_RSN_CAP_OVERRIDE) in fw_capabilities to advertise
>> this support to driver.
>>
>> Signed-off-by: Subramania Sharma<sharmat@qca.qualcomm.com>
>> Signed-off-by: Vasanthakumar Thiagarajan<vthiagar@qca.qualcomm.com>
>
> Otherwise looks good but there's a sparse warning:
>
> drivers/net/wireless/ath/ath6kl/cfg80211.c:2539:20: warning: incorrect
> type in assignment (different base types)
> drivers/net/wireless/ath/ath6kl/cfg80211.c:2539:20:    expected unsigned
> short [unsigned] [short] [usertype]<noident>
> drivers/net/wireless/ath/ath6kl/cfg80211.c:2539:20:    got restricted
> __le16 [usertype]<noident>

grr, for some reason my sparse does not report this. How about the 
change like the following over this patch so that we need not worry 
about endianness in accessing rsn-cap?. Thanks!.


> --- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -2520,7 +2520,7 @@ static int ath6kl_set_ies(struct ath6kl_vif *vif,
  }

  static int ath6kl_get_rsn_capab(struct cfg80211_beacon_data *beacon,
-                               u16 *rsn_capab)
+                               u8 *rsn_capab)
  {
         const u8 *rsn_ie;
         size_t rsn_ie_len;
@@ -2560,7 +2560,7 @@ static int ath6kl_get_rsn_capab(struct 
cfg80211_beacon_data *beacon,
         if (rsn_ie_len < 2)
                 return -EINVAL;

-       *rsn_capab = cpu_to_le16(*((u16 *) rsn_ie));
+       memcpy(rsn_capab, rsn_ie, 2);

         return 0;
  }
@@ -2749,7 +2749,7 @@ static int ath6kl_start_ap(struct wiphy *wiphy, 
struct net_device *dev,
          * advertise the same in beacon/probe response. Send
          * the complete RSN IE capability field to firmware
          */
-       if (!ath6kl_get_rsn_capab(&info->beacon, &rsn_capab) &&
+       if (!ath6kl_get_rsn_capab(&info->beacon, (u8 *) &rsn_capab) &&
             test_bit(ATH6KL_FW_CAPABILITY_RSN_CAP_OVERRIDE,
                      ar->fw_capabilities)) {
                 res = ath6kl_wmi_set_ie_cmd(ar->wmi, vif->fw_vif_idx,

Vasanth
