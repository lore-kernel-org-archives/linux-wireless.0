Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:42602 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758758Ab2CTIE7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Mar 2012 04:04:59 -0400
Message-ID: <4F683A26.7090404@qca.qualcomm.com> (sfid-20120320_090527_047875_A89EE7C3)
Date: Tue, 20 Mar 2012 10:04:54 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: shonmou li <shonmou@gmail.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: avoiding 80211 scan does not complete before
 start scheduled scan.
References: <CADhJdvDbAORKoWUxLdcz7Jq2dt9DKEPzBwgmiNvZsj6iU2K9Kw@mail.gmail.com>
In-Reply-To: <CADhJdvDbAORKoWUxLdcz7Jq2dt9DKEPzBwgmiNvZsj6iU2K9Kw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Shonmou,

Thanks for the patch.

On 02/23/2012 06:15 PM, shonmou li wrote:
> In this patch, i stop 80211 scan before scheduled scan. 
> It could avoid the following situation it will cause wpa_supplicant
> trigger scan fail:
> 
> "The device connected with access point then system goes into suspend mode.
>   At this moment AP might be turned off or signal lost and then
> disconnect with the device."

Please add a description to the commit log as well. Also can you
describe in a bit more detail how this happens, I didn't fully
understand the scenario. Also how often do you see this bug?

I'll copy the patch for reference:

--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -2661,6 +2661,8 @@ static int ath6kl_cfg80211_sscan_start(struct
wiphy *wiphy,
 	if (vif->sme_state != SME_DISCONNECTED)
 		return -EBUSY;

+	ath6kl_cfg80211_scan_complete_event(vif, true);
+
 	for (i = 0; i < ar->wiphy->max_sched_scan_ssids; i++) {
 		ath6kl_wmi_probedssid_cmd(ar->wmi, vif->fw_vif_idx,
 					  i, DISABLE_SSID_FLAG,

I wonder if this is enough. At least in theory we should abort the scan
from firmware. Other option would be to check if a normal scan is
running (from vif->scan_req) and abort scheduled scan in that case. But
I'm not sure which one is better. Opinions?

Kalle
