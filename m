Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f48.google.com ([209.85.219.48]:63187 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498AbaCUGvX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Mar 2014 02:51:23 -0400
Received: by mail-oa0-f48.google.com with SMTP id m1so2094210oag.7
        for <linux-wireless@vger.kernel.org>; Thu, 20 Mar 2014 23:51:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1395380076-4306-1-git-send-email-yeohchunyeow@gmail.com>
References: <1395380076-4306-1-git-send-email-yeohchunyeow@gmail.com>
Date: Fri, 21 Mar 2014 07:51:22 +0100
Message-ID: <CA+BoTQmLfdkyN8yC8m-i_yXbhQ3UYVj1kPrdFmYSyLONCC=Kig@mail.gmail.com> (sfid-20140321_075126_424890_EFEA7125)
Subject: Re: [PATCH] ath10k: fix the peer mac address in getting stats
From: Michal Kazior <michal.kazior@tieto.com>
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 21 March 2014 06:34, Chun-Yeow Yeoh <yeohchunyeow@gmail.com> wrote:
> Using the macro to convert the MAC address from WMI word
> format to char array has lead to the wrong peer mac
> address printed out while retrieving the peer stats from
> FW. Fix this.
>
> Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
> ---
>  drivers/net/wireless/ath/ath10k/debug.c |    4 ++--
>  drivers/net/wireless/ath/ath10k/wmi.h   |   10 ----------
>  2 files changed, 2 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
> index 6debd28..f95defa 100644
> --- a/drivers/net/wireless/ath/ath10k/debug.c
> +++ b/drivers/net/wireless/ath/ath10k/debug.c
> @@ -252,8 +252,8 @@ void ath10k_debug_read_target_stats(struct ath10k *ar,
>                         peer_stats = (struct wmi_peer_stats *)tmp;
>                         s = &stats->peer_stat[i];
>
> -                       WMI_MAC_ADDR_TO_CHAR_ARRAY(&peer_stats->peer_macaddr,
> -                                                  s->peer_macaddr);
> +                       memcpy(s->peer_macaddr, &peer_stats->peer_macaddr.addr,
> +                              ETH_ALEN);

I noticed checkpatch started suggesting to prefer ether_addr_copy()
over memcpy(). Not a big deal though.

Other than that the patch looks good.

Reviewed-By: Micha³ Kazior <michal.kazior@tieto.com>


Micha³
