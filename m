Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:11325 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753507Ab1DRKTF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2011 06:19:05 -0400
Received: from mail.atheros.com ([10.234.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 18 Apr 2011 03:18:39 -0700
Message-ID: <4DAC1014.7020303@atheros.com>
Date: Mon, 18 Apr 2011 15:49:00 +0530
From: Mohammed Shafi <mshajakhan@atheros.com>
MIME-Version: 1.0
To: "linville@tuxdriver.com" <linville@tuxdriver.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] mac80211: Fix a compilation warning
References: <1303104058-18958-1-git-send-email-mshajakhan@atheros.com>
In-Reply-To: <1303104058-18958-1-git-send-email-mshajakhan@atheros.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 18 April 2011 10:50 AM, Mohammed Shajakhan wrote:
> From: Mohammed Shafi Shajakhan<mshajakhan@atheros.com>
>
> mac80211/debugfs_sta.c:113: warning:
> format ‘%d’ expects type ‘int’, but argument 4 has type ‘long int’
> introduced by the commit  ebe27c91af8b7f4810ae906fbd3eeb2d87850026
>
> Signed-off-by: Mohammed Shafi Shajakhan<mshajakhan@atheros.com>
> ---
>   net/mac80211/debugfs_sta.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
> index c008232..a01d213 100644
> --- a/net/mac80211/debugfs_sta.c
> +++ b/net/mac80211/debugfs_sta.c
> @@ -108,7 +108,7 @@ static ssize_t sta_connected_time_read(struct file *file, char __user *userbuf,
>   	result.tm_year -= 70;
>   	result.tm_mday -= 1;
>   	res = scnprintf(buf, sizeof(buf),
> -		"years  - %d\nmonths - %d\ndays   - %d\nclock  - %d:%d:%d\n\n",
> +		"years  - %ld\nmonths - %d\ndays   - %d\nclock  - %d:%d:%d\n\n",
>   			result.tm_year, result.tm_mon, result.tm_mday,
>   			result.tm_hour, result.tm_min, result.tm_sec);
>   	return simple_read_from_buffer(userbuf, count, ppos, buf, res);
>    
John, this seems to be already fixed by this patch
[PATCH -next] mac80211: fix debugfs printk format warning
http://www.spinics.net/lists/linux-wireless/msg67977.html
