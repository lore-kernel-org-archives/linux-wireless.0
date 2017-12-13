Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:37266 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751129AbdLMI6u (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Dec 2017 03:58:50 -0500
Received: by mail-wm0-f67.google.com with SMTP id f140so3490704wmd.2
        for <linux-wireless@vger.kernel.org>; Wed, 13 Dec 2017 00:58:49 -0800 (PST)
Subject: Re: [PATCH 1/9] wil6210: support Scheduled scan
To: Maya Erez <qca_merez@qca.qualcomm.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <1513105442-28041-1-git-send-email-qca_merez@qca.qualcomm.com>
 <1513105442-28041-2-git-send-email-qca_merez@qca.qualcomm.com>
Cc: Dedy Lansky <qca_dlansky@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5A30EBC7.6060401@broadcom.com> (sfid-20171213_095855_110680_D33F5BC4)
Date: Wed, 13 Dec 2017 09:58:47 +0100
MIME-Version: 1.0
In-Reply-To: <1513105442-28041-2-git-send-email-qca_merez@qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/12/2017 8:03 PM, Maya Erez wrote:
> From: Dedy Lansky <qca_dlansky@qca.qualcomm.com>
>
> Add support for sched_scan_start/stop by sending PNO commands to FW.
> Driver reports WIPHY_FLAG_SUPPORTS_SCHED_SCAN and invokes
> cfg80211_sched_scan_results upon receiving
> WMI_SCHED_SCAN_RESULT_EVENTID from FW.

The commit message triggered me as the wiphy flag mentioned no longer 
exists. Looking further into the patch it looks fine to me, but the flag 
needs to be removed from the commit message.

> Signed-off-by: Dedy Lansky <qca_dlansky@qca.qualcomm.com>
> Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
> ---
>   drivers/net/wireless/ath/wil6210/cfg80211.c |  65 ++++++++
>   drivers/net/wireless/ath/wil6210/main.c     |   8 +
>   drivers/net/wireless/ath/wil6210/wil6210.h  |   4 +
>   drivers/net/wireless/ath/wil6210/wmi.c      | 239 +++++++++++++++++++++++++++-
>   drivers/net/wireless/ath/wil6210/wmi.h      |  99 +++++++++---
>   5 files changed, 395 insertions(+), 20 deletions(-)

[...]

> diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
> index 8ace618..ed7cdb7 100644
> --- a/drivers/net/wireless/ath/wil6210/wmi.c
> +++ b/drivers/net/wireless/ath/wil6210/wmi.c

[...]

> @@ -658,8 +669,6 @@ static void wmi_evt_rx_mgmt(struct wil6210_priv *wil, int id, void *d, int len)
>   		wil_hex_dump_wmi("IE ", DUMP_PREFIX_OFFSET, 16, 1, ie_buf,
>   				 ie_len, true);
>
> -		wil_dbg_wmi(wil, "Capability info : 0x%04x\n", cap);
> -

This does not seem related.

>   		bss = cfg80211_inform_bss_frame(wiphy, channel, rx_mgmt_frame,
>   						d_len, signal, GFP_KERNEL);
>   		if (bss) {

[...]

> diff --git a/drivers/net/wireless/ath/wil6210/wmi.h b/drivers/net/wireless/ath/wil6210/wmi.h
> index d9e220a..7c6ac9c 100644
> --- a/drivers/net/wireless/ath/wil6210/wmi.h
> +++ b/drivers/net/wireless/ath/wil6210/wmi.h

[...]

> +/* WMI_START_SCHED_SCAN_EVENTID */
> +enum pno_result {
> +	PNO_SUCCESS		= 0x00,
> +	PNO_REJECT		= 0x01,
> +	PNO_INVALID_PARAMETERS	= 0x02,
> +	PNO_NOT_ENABLED		= 0x03,
> +};

Maybe good to stick with 'wmi_' for types defined in this file, ie. 
wmi_pno_result. Preferably also the enum values, but throughout the file 
I see instances with 'WMI_' prefix and without.

> +
> +struct wmi_start_sched_scan_event {
> +	/* pno_result */
> +	u8 result;
> +	u8 reserved[3];
> +} __packed;
> +
> +struct wmi_stop_sched_scan_event {
> +	/* pno_result */
> +	u8 result;
> +	u8 reserved[3];
> +} __packed;

Regards,
Arend
