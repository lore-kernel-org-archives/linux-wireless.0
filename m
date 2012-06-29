Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:45795 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753788Ab2F2BFU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2012 21:05:20 -0400
Received: by lbbgm6 with SMTP id gm6so3891136lbb.19
        for <linux-wireless@vger.kernel.org>; Thu, 28 Jun 2012 18:05:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1340926085-54416-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
References: <1340926085-54416-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Fri, 29 Jun 2012 11:04:59 +1000
Message-ID: <CAGRGNgXCoQNYbs7MVtEsDdoPUgvV+JDP28tCbKWG2cBHcJ60kQ@mail.gmail.com> (sfid-20120629_030524_096117_BFA2E1E4)
Subject: Re: [PATCH] mac80211: correct size the argument to kzalloc in minstrel_ht
To: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	nbd@openwrt.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Thomas,

On Fri, Jun 29, 2012 at 9:28 AM, Thomas Huehn
<thomas@net.t-labs.tu-berlin.de> wrote:
> msp has type struct minstrel_ht_sta_priv not struct minstrel_ht_sta.
>
> Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
> ---
>  net/mac80211/rc80211_minstrel_ht.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
> index 2d1acc6..dc2b801 100644
> --- a/net/mac80211/rc80211_minstrel_ht.c
> +++ b/net/mac80211/rc80211_minstrel_ht.c
> @@ -809,7 +809,7 @@ minstrel_ht_alloc_sta(void *priv, struct ieee80211_sta *sta, gfp_t gfp)
>                        max_rates = sband->n_bitrates;
>        }
>
> -       msp = kzalloc(sizeof(struct minstrel_ht_sta), gfp);
> +       msp = kzalloc(sizeof(struct minstrel_ht_sta_priv), gfp);

Why not use sizeof(*msp)?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
