Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51663 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760582Ab2CPMkp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Mar 2012 08:40:45 -0400
Subject: Re: [PATCH] mac80211: fix the endianness problem of HWMP sequence
 number in RANN propagation
From: Johannes Berg <johannes@sipsolutions.net>
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Cc: linux-wireless@vger.kernel.org, javier@cozybit.com,
	linville@tuxdriver.com, devel@lists.open80211s.org
In-Reply-To: <1331923430-23861-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20120316_110631_993892_BC6C19C7)
References: <1331923430-23861-1-git-send-email-yeohchunyeow@gmail.com>
	 (sfid-20120316_110631_993892_BC6C19C7)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Mar 2012 13:40:42 +0100
Message-ID: <1331901642.6753.1.camel@jlt3.sipsolutions.net> (sfid-20120316_134048_968595_12A4A6A6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2012-03-17 at 02:43 +0800, Chun-Yeow Yeoh wrote:
> The HWMP sequence number of received RANN element is compared to decide whether to be
> propagated. The sequence number is required to covert from 32bit little endian data into
> CPUs endianness for comparison.
> 
> Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
> ---
>  net/mac80211/mesh_hwmp.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
> index 1c6f3d0..2ccb3c9 100644
> --- a/net/mac80211/mesh_hwmp.c
> +++ b/net/mac80211/mesh_hwmp.c
> @@ -748,7 +748,7 @@ static void hwmp_rann_frame_process(struct ieee80211_sub_if_data *sdata,
>  	flags = rann->rann_flags;
>  	root_is_gate = !!(flags & RANN_FLAG_IS_GATE);
>  	orig_addr = rann->rann_addr;
> -	orig_sn = rann->rann_seq;
> +	orig_sn = le32_to_cpu(rann->rann_seq);

You should mark struct ieee80211_rann_ie to contain __le32, so that
sparse will warn about things like this.

johannes

