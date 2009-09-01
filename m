Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mta-2.ms.rz.RWTH-Aachen.DE ([134.130.7.73]:55502 "EHLO
	mta-2.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751781AbZIAIGE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Sep 2009 04:06:04 -0400
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Received: from ironport-out-1.rz.rwth-aachen.de ([134.130.5.40])
 by mta-2.ms.rz.RWTH-Aachen.de
 (Sun Java(tm) System Messaging Server 6.3-7.04 (built Sep 26 2008))
 with ESMTP id <0KPA00J1Q965KO10@mta-2.ms.rz.RWTH-Aachen.de> for
 linux-wireless@vger.kernel.org; Tue, 01 Sep 2009 10:06:05 +0200 (CEST)
Message-id: <4A9CD5C0.9080700@nets.rwth-aachen.de>
Date: Tue, 01 Sep 2009 10:05:20 +0200
From: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: Arnd Hannemann <Arnd.Hannemann@nets.rwth-aachen.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"joe@perches.com" <joe@perches.com>,
	"proski@gnu.org" <proski@gnu.org>
Subject: Re: [PATCH v2] mac80211: Fix output of minstrels rc_stats
References: <1251138015.13464.2.camel@mj>
 <1251139906-31813-1-git-send-email-hannemann@nets.rwth-aachen.de>
 <646765f40908311754l7bd16185pe21182cdba6e6ac8@mail.gmail.com>
In-reply-to: <646765f40908311754l7bd16185pe21182cdba6e6ac8@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Julian Calaby wrote:
> On Tue, Aug 25, 2009 at 04:51, Arnd
> Hannemann<hannemann@nets.rwth-aachen.de> wrote:
>> An integer overflow in the minstrel debug code prevented the
>> throughput to be displayed correctly. This patch fixes that,
>> by permutating operations like proposed by Pavel Roskin.
>>
>> Signed-off-by: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
>> ---
>>  net/mac80211/rc80211_minstrel_debugfs.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/net/mac80211/rc80211_minstrel_debugfs.c b/net/mac80211/rc80211_minstrel_debugfs.c
>> index 98f4807..3d72ec5 100644
>> --- a/net/mac80211/rc80211_minstrel_debugfs.c
>> +++ b/net/mac80211/rc80211_minstrel_debugfs.c
>> @@ -83,7 +83,7 @@ minstrel_stats_open(struct inode *inode, struct file *file)
>>                p += sprintf(p, "%3u%s", mr->bitrate / 2,
>>                                (mr->bitrate & 1 ? ".5" : "  "));
>>
>> -               tp = ((mr->cur_tp * 96) / 18000) >> 10;
>> +               tp = mr->cur_tp / ((18000 << 10) / 96);
> 
> Sorry about being so late, but wouldn't:
> 
> tp = ((mr->cur_tp * 2) / 375) >> 10;
> 
> also work? (Assuming that the numbers in the constant aren't important)

I needed a while to figure out why those constants are used, but finally
they made some sense, so I think its best to preserve them.

mr->cur_tp is the time to send one 1200 byte packet (9600 bits),
the loss probelity is scaled between 0-18000 to reduce rounding error.

> 
> or even:
> 
> tp = (mr->cur_tp / 375) >> 9;

See above.

Best regards,
Arnd
