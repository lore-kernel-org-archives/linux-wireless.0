Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54119 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841Ab1DOHaH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Apr 2011 03:30:07 -0400
Subject: Re: [PATCH] {mac|nl}80211: Add station connected time
From: Johannes Berg <johannes@sipsolutions.net>
To: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	nbd@openwrt.org, helmut.schaa@googlemail.com,
	Senthilkumar Balasubramanian
	<Senthilkumar.Balasubramanian@Atheros.com>
In-Reply-To: <1302278064-18403-1-git-send-email-mshajakhan@atheros.com>
References: <1302278064-18403-1-git-send-email-mshajakhan@atheros.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Apr 2011 09:29:56 +0200
Message-ID: <1302852596.3572.4.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-04-08 at 21:24 +0530, Mohammed Shafi Shajakhan wrote:

> +static ssize_t sta_connected_time_read(struct file *file, char __user *userbuf,
> +					size_t count, loff_t *ppos)
> +{
> +	struct sta_info *sta = file->private_data;
> +	struct timespec uptime;
> +	struct tm result;
> +	long connected_time_secs;
> +	char buf[100];
> +	int res;
> +	do_posix_clock_monotonic_gettime(&uptime);
> +	connected_time_secs = uptime.tv_sec - sta->last_connected;
> +	time_to_tm(connected_time_secs, 0, &result);
> +	result.tm_year -= 70;
> +	result.tm_mday -= 1;
> +	res = scnprintf(buf, sizeof(buf),
> +		"years  - %d\nmonths - %d\ndays   - %d\nclock  - %d:%d:%d\n\n",
> +			result.tm_year, result.tm_mon, result.tm_mday,
> +			result.tm_hour, result.tm_min, result.tm_sec);

net/mac80211/debugfs_sta.c: In function 'sta_connected_time_read':
net/mac80211/debugfs_sta.c:113:4: warning: format '%d' expects type
'int', but argument 4 has type 'long int'

Please fix.

johannes

