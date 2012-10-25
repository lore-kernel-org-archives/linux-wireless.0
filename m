Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60174 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992606Ab2JYSsm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2012 14:48:42 -0400
Received: by mail-bk0-f46.google.com with SMTP id jk13so969168bkc.19
        for <linux-wireless@vger.kernel.org>; Thu, 25 Oct 2012 11:48:40 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Javier Cardona <javier@cozybit.com>
Subject: Re: [PATCH] mac80211: Don't inspect Sequence Control field on control frames
Date: Thu, 25 Oct 2012 20:48:33 +0200
Cc: linville@tuxdriver.com, Javier Lopez <jlopex@cozybit.com>,
	linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	johannes@sipsolutions.net
References: <1351188618-11155-1-git-send-email-javier@cozybit.com>
In-Reply-To: <1351188618-11155-1-git-send-email-javier@cozybit.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201210252048.34083.chunkeey@googlemail.com> (sfid-20121025_204900_960782_5B7AE27D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday, October 25, 2012 08:10:18 PM Javier Cardona wrote:
> Per IEEE Std. 802.11-2012, Sec 8.2.4.4.1, the sequence Control field is
> not present in control frames.  We noticed this problem when processing
> Block Ack Requests.
> 
> Signed-off-by: Javier Cardona <javier@cozybit.com>
> Signed-off-by: Javier Lopez <jlopex@cozybit.com>
> ---
>  net/mac80211/rx.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> index f975f64..bf54336 100644
> --- a/net/mac80211/rx.c
> +++ b/net/mac80211/rx.c
> @@ -1467,6 +1467,10 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
>  
>  	hdr = (struct ieee80211_hdr *)rx->skb->data;
>  	fc = hdr->frame_control;
> +
> +	if (ieee80211_is_ctl(fc))
> +		return RX_CONTINUE;
> +
>  	sc = le16_to_cpu(hdr->seq_ctrl);
>  	frag = sc & IEEE80211_SCTL_FRAG;
>  
hmm, I see this function also calls skb_linearize() on said
skb... Does anybody know of any possible side effects? Not
that control frames (In fact, just BlockACK Requests come
to my mind) usually so large...

Regards,
	Chr 
