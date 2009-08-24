Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mta-1.ms.rz.RWTH-Aachen.DE ([134.130.7.72]:45425 "EHLO
	mta-1.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752660AbZHXSUh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Aug 2009 14:20:37 -0400
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Received: from ironport-out-1.rz.rwth-aachen.de ([134.130.5.40])
 by mta-1.ms.rz.RWTH-Aachen.de
 (Sun Java(tm) System Messaging Server 6.3-7.04 (built Sep 26 2008))
 with ESMTP id <0KOW009ET8AF8HF0@mta-1.ms.rz.RWTH-Aachen.de> for
 linux-wireless@vger.kernel.org; Mon, 24 Aug 2009 20:20:39 +0200 (CEST)
Message-id: <4A92D9CE.7000104@nets.rwth-aachen.de>
Date: Mon, 24 Aug 2009 20:19:58 +0200
From: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
To: Joe Perches <joe@perches.com>
Cc: Arnd Hannemann <Arnd.Hannemann@nets.rwth-aachen.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: Fix output of minstrels rc_stats
References: <1251135778-27288-1-git-send-email-hannemann@nets.rwth-aachen.de>
 <1251136676.3873.28.camel@Joe-Laptop.home>
In-reply-to: <1251136676.3873.28.camel@Joe-Laptop.home>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Joe Perches schrieb:
> On Mon, 2009-08-24 at 19:42 +0200, Arnd Hannemann wrote:
>> An integer overflow in the minstrel debug code prevented the
>> throughput to be displayed correctly. This patch fixes that,
>> by swaping the division and multiplication.
>>
>> Signed-off-by: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
>> ---
>>  net/mac80211/rc80211_minstrel_debugfs.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/net/mac80211/rc80211_minstrel_debugfs.c b/net/mac80211/rc80211_minstrel_debugfs.c
>> index 98f4807..caf9453 100644
>> --- a/net/mac80211/rc80211_minstrel_debugfs.c
>> +++ b/net/mac80211/rc80211_minstrel_debugfs.c
>> @@ -83,7 +83,7 @@ minstrel_stats_open(struct inode *inode, struct file *file)
>>  		p += sprintf(p, "%3u%s", mr->bitrate / 2,
>>  				(mr->bitrate & 1 ? ".5" : "  "));
>>  
>> -		tp = ((mr->cur_tp * 96) / 18000) >> 10;
>> +		tp = ((mr->cur_tp / 18000) * 96) >> 10;
> 
> Maybe do_div instead?

Do you mean the do_div from asm/div64h ?
It seems overly complicated to me. It would result in something like:
tp = mr->cur_tp;
do_div(tp, 18000);
tp = (tp * 96) >> 10;

Or am I missing something?
Probably
tp = mr->cur_tp * 96;
would not work..., as it would already overflow. Not sure if
do_div(tp * 96, 18000);
would work?

Best regards,
Arnd
