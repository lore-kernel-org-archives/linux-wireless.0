Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:54729 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753015AbbCQIQp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2015 04:16:45 -0400
Message-ID: <5507E2EB.2050604@openwrt.org> (sfid-20150317_091651_707100_32D792F9)
Date: Tue, 17 Mar 2015 09:16:43 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>,
	linux-wireless@vger.kernel.org
CC: johannes@sipsolutions.net
Subject: Re: [PATCH v2 03/10] mac80211: add new Minstrel statistic output
 via csv
References: <1423839472-15625-1-git-send-email-thomas@net.t-labs.tu-berlin.de> <1423839472-15625-4-git-send-email-thomas@net.t-labs.tu-berlin.de>
In-Reply-To: <1423839472-15625-4-git-send-email-thomas@net.t-labs.tu-berlin.de>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2015-02-13 15:57, Thomas Huehn wrote:
> This patch adds a new debugfs file "rc_stats_csv" to output Minstrels
> statistics in a common csv format that is easy to parse.
> 
> Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
> Signed-off-by: Stefan Venz <ikstream86@gmail.com>
> ---
>  net/mac80211/rc80211_minstrel.h            |  6 +-
>  net/mac80211/rc80211_minstrel_debugfs.c    | 95 ++++++++++++++++++++++++++----
>  net/mac80211/rc80211_minstrel_ht_debugfs.c |  2 +-
>  3 files changed, 88 insertions(+), 15 deletions(-)
> 

> diff --git a/net/mac80211/rc80211_minstrel_ht_debugfs.c b/net/mac80211/rc80211_minstrel_ht_debugfs.c
> index 7fc690f..b300513 100644
> --- a/net/mac80211/rc80211_minstrel_ht_debugfs.c
> +++ b/net/mac80211/rc80211_minstrel_ht_debugfs.c
> @@ -112,7 +112,7 @@ minstrel_ht_stats_open(struct inode *inode, struct file *file)
>  
>  	if (!msp->is_ht) {
>  		inode->i_private = &msp->legacy;
> -		ret = minstrel_stats_open(inode, file);
> +		ret = minstrel_stats_csv_open(inode, file);
That does not look right to me.

- Felix
