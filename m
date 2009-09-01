Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f205.google.com ([209.85.217.205]:36168 "EHLO
	mail-gx0-f205.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432AbZIAAyy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Aug 2009 20:54:54 -0400
Received: by gxk1 with SMTP id 1so5921701gxk.17
        for <linux-wireless@vger.kernel.org>; Mon, 31 Aug 2009 17:54:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1251139906-31813-1-git-send-email-hannemann@nets.rwth-aachen.de>
References: <1251138015.13464.2.camel@mj> <1251139906-31813-1-git-send-email-hannemann@nets.rwth-aachen.de>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 1 Sep 2009 10:54:36 +1000
Message-ID: <646765f40908311754l7bd16185pe21182cdba6e6ac8@mail.gmail.com>
Subject: Re: [PATCH v2] mac80211: Fix output of minstrels rc_stats
To: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
Cc: linux-wireless@vger.kernel.org, joe@perches.com, proski@gnu.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 25, 2009 at 04:51, Arnd
Hannemann<hannemann@nets.rwth-aachen.de> wrote:
> An integer overflow in the minstrel debug code prevented the
> throughput to be displayed correctly. This patch fixes that,
> by permutating operations like proposed by Pavel Roskin.
>
> Signed-off-by: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
> ---
>  net/mac80211/rc80211_minstrel_debugfs.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/net/mac80211/rc80211_minstrel_debugfs.c b/net/mac80211/rc80211_minstrel_debugfs.c
> index 98f4807..3d72ec5 100644
> --- a/net/mac80211/rc80211_minstrel_debugfs.c
> +++ b/net/mac80211/rc80211_minstrel_debugfs.c
> @@ -83,7 +83,7 @@ minstrel_stats_open(struct inode *inode, struct file *file)
>                p += sprintf(p, "%3u%s", mr->bitrate / 2,
>                                (mr->bitrate & 1 ? ".5" : "  "));
>
> -               tp = ((mr->cur_tp * 96) / 18000) >> 10;
> +               tp = mr->cur_tp / ((18000 << 10) / 96);

Sorry about being so late, but wouldn't:

tp = ((mr->cur_tp * 2) / 375) >> 10;

also work? (Assuming that the numbers in the constant aren't important)

or even:

tp = (mr->cur_tp / 375) >> 9;

Thanks,

-- 

Julian Calaby

Email: julian.calaby@gmail.com
.Plan: http://sites.google.com/site/juliancalaby/
