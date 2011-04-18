Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:63804 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067Ab1DRERQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2011 00:17:16 -0400
Received: from mail.atheros.com ([10.234.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sun, 17 Apr 2011 21:16:50 -0700
Message-ID: <4DABBB45.7090006@atheros.com>
Date: Mon, 18 Apr 2011 09:47:09 +0530
From: Mohammed Shafi <mshajakhan@atheros.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Mohammed Shajakhan <Mohammed.Shajakhan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"nbd@openwrt.org" <nbd@openwrt.org>,
	"helmut.schaa@googlemail.com" <helmut.schaa@googlemail.com>,
	Senthilkumar Balasubramanian
	<Senthilkumar.Balasubramanian@Atheros.com>
Subject: Re: [PATCH] {mac|nl}80211: Add station connected time
References: <1302278064-18403-1-git-send-email-mshajakhan@atheros.com> <1302852596.3572.4.camel@jlt3.sipsolutions.net>
In-Reply-To: <1302852596.3572.4.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 15 April 2011 12:59 PM, Johannes Berg wrote:
> On Fri, 2011-04-08 at 21:24 +0530, Mohammed Shafi Shajakhan wrote:
>
>    
>> +static ssize_t sta_connected_time_read(struct file *file, char __user *userbuf,
>> +					size_t count, loff_t *ppos)
>> +{
>> +	struct sta_info *sta = file->private_data;
>> +	struct timespec uptime;
>> +	struct tm result;
>> +	long connected_time_secs;
>> +	char buf[100];
>> +	int res;
>> +	do_posix_clock_monotonic_gettime(&uptime);
>> +	connected_time_secs = uptime.tv_sec - sta->last_connected;
>> +	time_to_tm(connected_time_secs, 0,&result);
>> +	result.tm_year -= 70;
>> +	result.tm_mday -= 1;
>> +	res = scnprintf(buf, sizeof(buf),
>> +		"years  - %d\nmonths - %d\ndays   - %d\nclock  - %d:%d:%d\n\n",
>> +			result.tm_year, result.tm_mon, result.tm_mday,
>> +			result.tm_hour, result.tm_min, result.tm_sec);
>>      
> net/mac80211/debugfs_sta.c: In function 'sta_connected_time_read':
> net/mac80211/debugfs_sta.c:113:4: warning: format '%d' expects type
> 'int', but argument 4 has type 'long int'
>
> Please fix.
>    
Sure, thanks a lot.
> johannes
>
>    
