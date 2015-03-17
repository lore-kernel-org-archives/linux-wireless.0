Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:54763 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752310AbbCQISp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2015 04:18:45 -0400
Message-ID: <5507E362.6000209@openwrt.org> (sfid-20150317_091849_802158_F647D55D)
Date: Tue, 17 Mar 2015 09:18:42 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>,
	linux-wireless@vger.kernel.org
CC: johannes@sipsolutions.net
Subject: Re: [PATCH v2 04/10] mac80211: add new Minstrel-HT statistic output
 via csv
References: <1423839472-15625-1-git-send-email-thomas@net.t-labs.tu-berlin.de> <1423839472-15625-5-git-send-email-thomas@net.t-labs.tu-berlin.de>
In-Reply-To: <1423839472-15625-5-git-send-email-thomas@net.t-labs.tu-berlin.de>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2015-02-13 15:57, Thomas Huehn wrote:
> This patch adds a new debugfs file "rc_stats_csv" to output
> Minstrel-HTs statistics in a common csv format that is easy
> to parse.
> 
> Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
> Signed-off-by: Stefan Venz <ikstream86@gmail.com>
> ---
> --- a/net/mac80211/rc80211_minstrel_ht_debugfs.c
> +++ b/net/mac80211/rc80211_minstrel_ht_debugfs.c
> +static int
> +minstrel_ht_stats_csv_open(struct inode *inode, struct file *file)
> +{
> +	struct minstrel_ht_sta_priv *msp = inode->i_private;
> +	struct minstrel_ht_sta *mi = &msp->ht;
> +	struct minstrel_debugfs_info *ms;
> +	struct timeval tv;
> +	unsigned int i;
> +	int ret;
> +	char *p;
> +
> +	do_gettimeofday(&tv);
> +
> +	if (!msp->is_ht) {
> +		inode->i_private = &msp->legacy;
> +		ret = minstrel_stats_open(inode, file);
Should be minstrel_stats_csv_open here?

- Felix
