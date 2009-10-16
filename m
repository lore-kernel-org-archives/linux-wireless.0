Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:52034 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbZJPWG3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2009 18:06:29 -0400
Received: by fxm18 with SMTP id 18so2965649fxm.37
        for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2009 15:06:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1255670340-22565-15-git-send-email-yi.zhu@intel.com>
References: <1255670340-22565-1-git-send-email-yi.zhu@intel.com>
	 <1255670340-22565-7-git-send-email-yi.zhu@intel.com>
	 <1255670340-22565-8-git-send-email-yi.zhu@intel.com>
	 <1255670340-22565-9-git-send-email-yi.zhu@intel.com>
	 <1255670340-22565-10-git-send-email-yi.zhu@intel.com>
	 <1255670340-22565-11-git-send-email-yi.zhu@intel.com>
	 <1255670340-22565-12-git-send-email-yi.zhu@intel.com>
	 <1255670340-22565-13-git-send-email-yi.zhu@intel.com>
	 <1255670340-22565-14-git-send-email-yi.zhu@intel.com>
	 <1255670340-22565-15-git-send-email-yi.zhu@intel.com>
Date: Sat, 17 Oct 2009 00:06:32 +0200
Message-ID: <1ba2fa240910161506n6c519398h7795656309bffd93@mail.gmail.com>
Subject: Re: [PATCH 14/16] iwmc3200wifi: Support unexpected reboot barker
From: Tomas Winkler <tomasw@gmail.com>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 16, 2009 at 7:18 AM, Zhu Yi <yi.zhu@intel.com> wrote:
> From: Samuel Ortiz <sameo@linux.intel.com>
>
> We can receive unexpected reboot barker at any time, and we're supposed to
> reset the whole device then.

What do yo mean, by whole device ? And who is we in this context?

Thanks
Tomas

>
> Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
> Signed-off-by: Zhu Yi <yi.zhu@intel.com>
> ---
>  drivers/net/wireless/iwmc3200wifi/rx.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/wireless/iwmc3200wifi/rx.c b/drivers/net/wireless/iwmc3200wifi/rx.c
> index c0fa853..95deb0a 100644
> --- a/drivers/net/wireless/iwmc3200wifi/rx.c
> +++ b/drivers/net/wireless/iwmc3200wifi/rx.c
> @@ -1322,6 +1322,14 @@ int iwm_rx_handle(struct iwm_priv *iwm, u8 *buf, unsigned long buf_size)
>
>        switch (le32_to_cpu(hdr->cmd)) {
>        case UMAC_REBOOT_BARKER:
> +               if (test_bit(IWM_STATUS_READY, &iwm->status)) {
> +                       IWM_ERR(iwm, "Unexpected BARKER\n");
> +
> +                       schedule_work(&iwm->reset_worker);
> +
> +                       return 0;
> +               }
> +
>                return iwm_notif_send(iwm, NULL, IWM_BARKER_REBOOT_NOTIFICATION,
>                                      IWM_SRC_UDMA, buf, buf_size);
>        case UMAC_ACK_BARKER:
> --
> 1.6.0.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
