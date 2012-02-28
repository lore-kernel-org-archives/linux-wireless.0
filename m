Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:8148 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932573Ab2B1JKb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Feb 2012 04:10:31 -0500
Message-ID: <4F4C9A03.2080906@qca.qualcomm.com> (sfid-20120228_101038_042313_F592649A)
Date: Tue, 28 Feb 2012 11:10:27 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH V2 3/5] ath6kl: Refactor ath6kl_wmi_control_rx()
References: <1330161068-8413-1-git-send-email-vthiagar@qca.qualcomm.com> <1330161068-8413-3-git-send-email-vthiagar@qca.qualcomm.com>
In-Reply-To: <1330161068-8413-3-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/25/2012 11:11 AM, Vasanthakumar Thiagarajan wrote:
> Split the wmi event processing into the one which needs to be
> vif specific and the reset. This is a step towards avoiding
> the need for wiphy and a netdev registration before getting
> any message from firmware.
> 
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath6kl/wmi.c |  200 ++++++++++++++++-----------------
>  1 files changed, 99 insertions(+), 101 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
> index bbbe0a7..0527933 100644
> --- a/drivers/net/wireless/ath/ath6kl/wmi.c
> +++ b/drivers/net/wireless/ath/ath6kl/wmi.c
> @@ -3369,32 +3369,101 @@ static int ath6kl_wmi_roam_tbl_event_rx(struct wmi *wmi, u8 *datap, int len)
>  	return ath6kl_debug_roam_tbl_event(wmi->parent_dev, datap, len);
>  }
>  
> -/* Control Path */
> -int ath6kl_wmi_control_rx(struct wmi *wmi, struct sk_buff *skb)
> +/* Process interface specific wmi events, caller would free the datap */
> +static int ath6kl_wmi_proc_events_iface(struct wmi *wmi, u16 if_idx, u16 cmd_id,
> +					u8 *datap, u32 len)
>  {

Please rename this to ath6kl_wmi_proc_events_vif() or something similar.
Better to use term vif everywhere, it's not clear that iface here means vif.

Otherwise the patchset looks good to me.

Kalle
