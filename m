Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mta-2.ms.rz.RWTH-Aachen.DE ([134.130.7.73]:59977 "EHLO
	mta-2.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753146AbZHXShH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Aug 2009 14:37:07 -0400
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Received: from ironport-out-1.rz.rwth-aachen.de ([134.130.5.40])
 by mta-2.ms.rz.RWTH-Aachen.de
 (Sun Java(tm) System Messaging Server 6.3-7.04 (built Sep 26 2008))
 with ESMTP id <0KOW004C591WMA00@mta-2.ms.rz.RWTH-Aachen.de> for
 linux-wireless@vger.kernel.org; Mon, 24 Aug 2009 20:37:08 +0200 (CEST)
Message-id: <4A92DDAB.6040503@nets.rwth-aachen.de>
Date: Mon, 24 Aug 2009 20:36:27 +0200
From: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
To: Pavel Roskin <proski@gnu.org>
Cc: Joe Perches <joe@perches.com>,
	Arnd Hannemann <Arnd.Hannemann@nets.rwth-aachen.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: Fix output of minstrels rc_stats
References: <1251135778-27288-1-git-send-email-hannemann@nets.rwth-aachen.de>
 <1251136676.3873.28.camel@Joe-Laptop.home> <1251138015.13464.2.camel@mj>
In-reply-to: <1251138015.13464.2.camel@mj>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pavel Roskin schrieb:
> On Mon, 2009-08-24 at 10:57 -0700, Joe Perches wrote:
>> On Mon, 2009-08-24 at 19:42 +0200, Arnd Hannemann wrote:
>>> An integer overflow in the minstrel debug code prevented the
>>> throughput to be displayed correctly. This patch fixes that,
>>> by swaping the division and multiplication.
>>>
>>> Signed-off-by: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
>>> ---
>>>  net/mac80211/rc80211_minstrel_debugfs.c |    2 +-
>>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/net/mac80211/rc80211_minstrel_debugfs.c b/net/mac80211/rc80211_minstrel_debugfs.c
>>> index 98f4807..caf9453 100644
>>> --- a/net/mac80211/rc80211_minstrel_debugfs.c
>>> +++ b/net/mac80211/rc80211_minstrel_debugfs.c
>>> @@ -83,7 +83,7 @@ minstrel_stats_open(struct inode *inode, struct file *file)
>>>  		p += sprintf(p, "%3u%s", mr->bitrate / 2,
>>>  				(mr->bitrate & 1 ? ".5" : "  "));
>>>  
>>> -		tp = ((mr->cur_tp * 96) / 18000) >> 10;
>>> +		tp = ((mr->cur_tp / 18000) * 96) >> 10;
>> Maybe do_div instead?
> 
> How about this?
> 
> tp = mr->cur_tp / ((18000 << 10) / 96);
> 
> ((18000 << 10) / 96) is exactly 192000.
> 

Hmm don't seems to be equivalent with the original statement:

  a = 61027734;
  b = ((a * 96) / 18000) >> 10;
  c = a / ((18000 << 10) / 96);
  printf("%u %u\n", b, c);

Outputs:
 84 317


Best regards,
Arnd


