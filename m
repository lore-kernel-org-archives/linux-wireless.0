Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:57435 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756388Ab0JIQdH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Oct 2010 12:33:07 -0400
Message-ID: <4CB09937.7040001@openwrt.org>
Date: Sat, 09 Oct 2010 18:32:55 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Helmut Schaa <helmut.schaa@googlemail.com>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	lrodriguez@atheros.com, br1@einfach.org
Subject: Re: [PATCH 1/3] cfg80211: add channel utilization stats to the survey
 command
References: <1286584771-76663-1-git-send-email-nbd@openwrt.org> <201010091417.25727.helmut.schaa@googlemail.com> <4CB06966.9070905@openwrt.org> <201010091737.17000.helmut.schaa@googlemail.com>
In-Reply-To: <201010091737.17000.helmut.schaa@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-10-09 5:37 PM, Helmut Schaa wrote:
> Am Samstag 09 Oktober 2010 schrieb Felix Fietkau:
>> On 2010-10-09 2:17 PM, Helmut Schaa wrote:
>> > Am Samstag 09 Oktober 2010 schrieb Felix Fietkau:
>> >> Using these, user space can calculate a relative channel utilization
>> >> with arbitrary intervals by regularly taking snapshots of the survey
>> >> results.
>> > 
>> > What if you've got multiple consumers, wouldn't that mess up the
>> > survey results?
>> > 
>> > I mean, for example mac80211 and/or hostapd might want to use the busy time
>> > statistics for the BSS load IE while a different userspace process might
>> > want to monitor the channel utilization in order to detect a worsening
>> > channel condition.
>> > 
>> > If the consumers happen to use the same interval and request the survey
>> > very soon after each other one consumer will get the values on a nice (close
>> > to the query interval) time base while the other one will get the values
>> > based on a very small interval (which might lower the value's
>> > representativeness).
>> Multiple consumers work just fine, since the survey results are relative
>> to the time the hardware started using the channel, not relative to the
>> last request. Maybe my description was a bit unclear on that part.
> 
> Ah, thanks Felix, I only read the comment, not the code :)
> 
> So, the busy time statistics for channel i are gathered starting with the
> switch to i. Hence, if a user space process would like to measure multiple
> channels it will just switch through all of them and call get survey right
> before switching to the next one, right?
In the current ath9k implementation that I posted, the stats are reset
immediately when switching to a channel, with one exception: switching
back to the operating channel after off-channel activity. That way, you
get sane, readable stats for all channels when dumping the survey list
after a scan.

> However, if we think about the BSS load IE we might want to measure the busy
> times without switching the channel? But we'd like have a somewhat actual
> value and not an average throughout the last minute/hour or so. Any ideas how
> to integrate that into your approach?
Just grab a survey dump when starting up, then another after a
minute/hour, and subtract the values of the last one.
Right now there's still an overflow issue in the internal counters in
the current ath9k implementation, so the stats are off unless you poll
survey stats regularly. I'll send a fix for that later.

- Felix
