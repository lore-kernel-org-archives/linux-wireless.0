Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:34395 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755270AbcEEPVk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 May 2016 11:21:40 -0400
Received: by mail-oi0-f47.google.com with SMTP id k142so106230804oib.1
        for <linux-wireless@vger.kernel.org>; Thu, 05 May 2016 08:21:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1462446039-1070-6-git-send-email-michal.kazior@tieto.com>
References: <1460636302-31161-1-git-send-email-michal.kazior@tieto.com>
	<1462446039-1070-1-git-send-email-michal.kazior@tieto.com>
	<1462446039-1070-6-git-send-email-michal.kazior@tieto.com>
Date: Thu, 5 May 2016 08:21:39 -0700
Message-ID: <CAA93jw6+WvTttjgBsU08epcXwSCHxv3Eh=m32xi72AiKYnGOCQ@mail.gmail.com> (sfid-20160505_172144_817190_3D7C29DA)
Subject: Re: [PATCHv4 5/5] mac80211: add debug knobs for codel
From: Dave Taht <dave.taht@gmail.com>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	make-wifi-fast@lists.bufferbloat.net,
	"codel@lists.bufferbloat.net" <codel@lists.bufferbloat.net>,
	Avery Pennarun <apenwarr@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 5, 2016 at 4:00 AM, Michal Kazior <michal.kazior@tieto.com> wrote:
> This adds a few debugfs entries to make it easier
> to test, debug and experiment.

I might argue in favor of moving all these (inc the fq ones) into
their own dir, maybe "aqm" or "sqm".

The mixture of read only stats and configuration vars is a bit confusing.

Also in my testing of the previous patch, actually seeing the stats
get updated seemed to be highly async or inaccurate. For example, it
was obvious from the captures themselves that codel_ce_mark-ing was
happening, but the actual numbers out of wack with the mark seen or
fq_backlog seen.  (I can go back to revisit this)

>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> ---
>
> Notes:
>     v4:
>      * stats adjustments (in-kernel codel has more of them)
>
>  net/mac80211/debugfs.c | 40 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 40 insertions(+)
>
> diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
> index 43592b6f79f0..c7cfedc61fc4 100644
> --- a/net/mac80211/debugfs.c
> +++ b/net/mac80211/debugfs.c
> @@ -124,6 +124,15 @@ static const struct file_operations name## _ops = {        \
>         res;                                                            \
>  })
>
> +#define DEBUGFS_RW_BOOL(arg)                                           \
> +({                                                                     \
> +       int res;                                                        \
> +       int val;                                                        \
> +       res = mac80211_parse_buffer(userbuf, count, ppos, "%d", &val);  \
> +       arg = !!(val);                                                  \
> +       res;                                                            \
> +})
> +
>  DEBUGFS_READONLY_FILE(fq_flows_cnt, "%u",
>                       local->fq.flows_cnt);
>  DEBUGFS_READONLY_FILE(fq_backlog, "%u",
> @@ -132,6 +141,16 @@ DEBUGFS_READONLY_FILE(fq_overlimit, "%u",
>                       local->fq.overlimit);
>  DEBUGFS_READONLY_FILE(fq_collisions, "%u",
>                       local->fq.collisions);
> +DEBUGFS_READONLY_FILE(codel_maxpacket, "%u",
> +                     local->cstats.maxpacket);
> +DEBUGFS_READONLY_FILE(codel_drop_count, "%u",
> +                     local->cstats.drop_count);
> +DEBUGFS_READONLY_FILE(codel_drop_len, "%u",
> +                     local->cstats.drop_len);
> +DEBUGFS_READONLY_FILE(codel_ecn_mark, "%u",
> +                     local->cstats.ecn_mark);
> +DEBUGFS_READONLY_FILE(codel_ce_mark, "%u",
> +                     local->cstats.ce_mark);
>
>  DEBUGFS_RW_FILE(fq_limit,
>                 DEBUGFS_RW_EXPR_FQ("%u", &local->fq.limit),
> @@ -139,6 +158,18 @@ DEBUGFS_RW_FILE(fq_limit,
>  DEBUGFS_RW_FILE(fq_quantum,
>                 DEBUGFS_RW_EXPR_FQ("%u", &local->fq.quantum),
>                 "%u", local->fq.quantum);
> +DEBUGFS_RW_FILE(codel_interval,
> +               DEBUGFS_RW_EXPR_FQ("%u", &local->cparams.interval),
> +               "%u", local->cparams.interval);
> +DEBUGFS_RW_FILE(codel_target,
> +               DEBUGFS_RW_EXPR_FQ("%u", &local->cparams.target),
> +               "%u", local->cparams.target);
> +DEBUGFS_RW_FILE(codel_mtu,
> +               DEBUGFS_RW_EXPR_FQ("%u", &local->cparams.mtu),
> +               "%u", local->cparams.mtu);
> +DEBUGFS_RW_FILE(codel_ecn,
> +               DEBUGFS_RW_BOOL(local->cparams.ecn),
> +               "%d", local->cparams.ecn ? 1 : 0);
>
>  #ifdef CONFIG_PM
>  static ssize_t reset_write(struct file *file, const char __user *user_buf,
> @@ -333,6 +364,15 @@ void debugfs_hw_add(struct ieee80211_local *local)
>         DEBUGFS_ADD(fq_collisions);
>         DEBUGFS_ADD(fq_limit);
>         DEBUGFS_ADD(fq_quantum);
> +       DEBUGFS_ADD(codel_maxpacket);
> +       DEBUGFS_ADD(codel_drop_count);
> +       DEBUGFS_ADD(codel_drop_len);
> +       DEBUGFS_ADD(codel_ecn_mark);
> +       DEBUGFS_ADD(codel_ce_mark);
> +       DEBUGFS_ADD(codel_interval);
> +       DEBUGFS_ADD(codel_target);
> +       DEBUGFS_ADD(codel_mtu);
> +       DEBUGFS_ADD(codel_ecn);
>
>         statsd = debugfs_create_dir("statistics", phyd);
>
> --
> 2.1.4
>



-- 
Dave Täht
Let's go make home routers and wifi faster! With better software!
http://blog.cerowrt.org
