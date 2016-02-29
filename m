Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:36576 "EHLO
	mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749AbcB2Sd7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 13:33:59 -0500
Received: by mail-wm0-f49.google.com with SMTP id n186so2029407wmn.1
        for <linux-wireless@vger.kernel.org>; Mon, 29 Feb 2016 10:33:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5bc6ba3b4d5743dc641b85c2c4233631f5b3319a.1456513260.git.poh@qca.qualcomm.com>
References: <5bc6ba3b4d5743dc641b85c2c4233631f5b3319a.1456513260.git.poh@qca.qualcomm.com>
Date: Mon, 29 Feb 2016 19:33:57 +0100
Message-ID: <CA+BoTQkCwSkARQKWcjkJri9xS6GGiHq4NwjOoewqtHOetjevGw@mail.gmail.com> (sfid-20160229_193402_351650_C4D135FA)
Subject: Re: [PATCH v5] ath10k: set MAC timestamp in management Rx frame
From: Michal Kazior <michal.kazior@tieto.com>
To: Peter Oh <poh@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 26 February 2016 at 20:03, Peter Oh <poh@qca.qualcomm.com> wrote:
> Check and set Rx MAC timestamp when firmware indicates it.
> Firmware adds it in Rx beacon frame only at this moment.
> Driver and mac80211 may utilize it to detect such clockdrift
> or beacon collision and use the result for beacon collision
> avoidance.
>
> Signed-off-by: Peter Oh <poh@qca.qualcomm.com>
> ---
[...]
> +       if (rx_status & WMI_RX_STATUS_EXT_INFO) {
> +               status->mactime =
> +                       __le32_to_cpu(arg.ext_info.rx_mac_timestamp_l32) |
> +                       (u64)__le32_to_cpu(arg.ext_info.rx_mac_timestamp_u32)
> +                       << 32;
> +               status->flag |= RX_FLAG_MACTIME_END;
> +       }
>         /* Hardware can Rx CCK rates on 5GHz. In that case phy_mode is set to
>          * MODE_11B. This means phy_mode is not a reliable source for the band
>          * of mgmt rx.
> diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
> index 4d3cbc4..f209d51 100644
> --- a/drivers/net/wireless/ath/ath10k/wmi.h
> +++ b/drivers/net/wireless/ath/ath10k/wmi.h
> @@ -3037,11 +3037,18 @@ struct wmi_10_4_mgmt_rx_event {
>         u8 buf[0];
>  } __packed;
>
> +struct wmi_mgmt_rx_ext_info {
> +       __le32 rx_mac_timestamp_l32;
> +       __le32 rx_mac_timestamp_u32;

Oh.. I feel bad for noticing this so late. I think this can be
represented with a mere __le64 and then accessed via le64_to_cpu().


Michał
