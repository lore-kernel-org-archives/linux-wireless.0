Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f170.google.com ([209.85.214.170]:55514 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755017AbaCUGdL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Mar 2014 02:33:11 -0400
Received: by mail-ob0-f170.google.com with SMTP id uz6so2052553obc.15
        for <linux-wireless@vger.kernel.org>; Thu, 20 Mar 2014 23:33:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1395360324-20433-1-git-send-email-greearb@candelatech.com>
References: <1395360324-20433-1-git-send-email-greearb@candelatech.com>
Date: Fri, 21 Mar 2014 07:33:10 +0100
Message-ID: <CA+BoTQn1B6g19Ks41kzcoVyhYbHAcJGTNAyucmPMupbRAy1SNg@mail.gmail.com> (sfid-20140321_073351_439902_8DA9D7FF)
Subject: Re: [PATCH] ath10k: Fix getting stats from firmware.
From: Michal Kazior <michal.kazior@tieto.com>
To: Ben Greear <greearb@candelatech.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 21 March 2014 01:05,  <greearb@candelatech.com> wrote:
> From: Ben Greear <greearb@candelatech.com>
>
> Make the request command object the right size so that
> firmware will not just throw it away.
> Tested customized and upstream firmware.

Did you test 636 as well? 636 doesn't seem to support more than just `stats_id`.


> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
>  drivers/net/wireless/ath/ath10k/wmi.h | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>
> diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
> index fa1b9e0..4946471 100644
> --- a/drivers/net/wireless/ath/ath10k/wmi.h
> +++ b/drivers/net/wireless/ath/ath10k/wmi.h
> @@ -2766,6 +2766,11 @@ enum wmi_stats_id {
>         WMI_REQUEST_AP_STAT     = 0x02
>  };
>
> +struct wlan_inst_rssi_args {
> +       __le16 cfg_retry_count;
> +       __le16 retry_count;
> +};
> +
>  struct wmi_request_stats_cmd {
>         __le32 stats_id;
>
> @@ -2773,6 +2778,12 @@ struct wmi_request_stats_cmd {
>          * Space to add parameters like
>          * peer mac addr
>          */

You can probably remove the comment now :-)


> +       __le32 vdev_id;
> +       /* peer MAC address */
> +       struct wmi_mac_addr peer_macaddr;
> +
> +       /* Instantaneous RSSI arguments */
> +       struct wlan_inst_rssi_args inst_rssi_args;
>  } __packed;


Michał
