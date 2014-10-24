Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0019.hostedemail.com ([216.40.44.19]:41143 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751391AbaJXJng (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Oct 2014 05:43:36 -0400
Message-ID: <1414143811.15751.14.camel@perches.com> (sfid-20141024_114341_726197_6A081C44)
Subject: Re: [patch] ipw2x00: shift wrap bugs setting ->rt_tsf
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Stanislav Yakovlev <stas.yakovlev@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Date: Fri, 24 Oct 2014 02:43:31 -0700
In-Reply-To: <20141024081534.GA11140@mwanda>
References: <20141024081534.GA11140@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-10-24 at 11:15 +0300, Dan Carpenter wrote:
> The ->parent_tsf[] array holds u8 values.  It type promoted to int for
> the shift operation so the "<< 24" shift operation can wrap.  The cast
> needs to be done before the shift instead of after.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> Static checker work.  Untested.
> 
> diff --git a/drivers/net/wireless/ipw2x00/ipw2200.c b/drivers/net/wireless/ipw2x00/ipw2200.c
[]
> @@ -7819,10 +7819,10 @@ static void ipw_handle_data_packet_monitor(struct ipw_priv *priv,
>  
>  	/* Zero the flags, we'll add to them as we go */
>  	ipw_rt->rt_flags = 0;
> -	ipw_rt->rt_tsf = (u64)(frame->parent_tsf[3] << 24 |
> -			       frame->parent_tsf[2] << 16 |
> -			       frame->parent_tsf[1] << 8  |
> -			       frame->parent_tsf[0]);
> +	ipw_rt->rt_tsf = (u64)frame->parent_tsf[3] << 24 |
> +			      frame->parent_tsf[2] << 16 |
> +			      frame->parent_tsf[1] << 8  |
> +			      frame->parent_tsf[0];
>  
>  	/* Convert signal to DBM */
>  	ipw_rt->rt_dbmsignal = antsignal;
> @@ -8028,10 +8028,10 @@ static void ipw_handle_promiscuous_rx(struct ipw_priv *priv,
>  
>  	/* Zero the flags, we'll add to them as we go */
>  	ipw_rt->rt_flags = 0;
> -	ipw_rt->rt_tsf = (u64)(frame->parent_tsf[3] << 24 |
> -			       frame->parent_tsf[2] << 16 |
> -			       frame->parent_tsf[1] << 8  |
> -			       frame->parent_tsf[0]);
> +	ipw_rt->rt_tsf = (u64)frame->parent_tsf[3] << 24 |
> +			      frame->parent_tsf[2] << 16 |
> +			      frame->parent_tsf[1] << 8  |
> +			      frame->parent_tsf[0];
>  
>  	/* Convert to DBM */
>  	ipw_rt->rt_dbmsignal = signal;

struct ipw_rt_hdr {
	struct ieee80211_radiotap_header rt_hdr;
	u64 rt_tsf;      /* TSF */	/* XXX */
	u8 rt_flags;	/* radiotap packet flags *
	u8 rt_rate;	/* rate in 500kb/s */
	__le16 rt_channel;	/* channel in mhz */
	__le16 rt_chbitmask;	/* channel bitfield */
	s8 rt_dbmsignal;	/* signal in dbM, kluged to signed */
	s8 rt_dbmnoise;
	u8 rt_antenna;	/* antenna number */
	u8 payload[0];  /* payload... */
} __packed;

Maybe rt_tsf (which is otherwise unused in this code),
should be __le64 so maybe use (u32) ?

	ipw_rt->rt_txf = cpu_to_le64((u32)(frame->parent_tsf[3] << 24 |
					   frame->parent_tsf[2] << 16 |
					   frame->parent_tsf[1] << 8  |
					   frame->parent_tsf[0]));

Al Viro touched this with commit 83f7d57c and added the XXX
when he did a bunch of type conversions from u<foo> to __le<foo>

Dunno what's right.

