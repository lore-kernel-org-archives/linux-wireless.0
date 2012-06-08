Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42875 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760032Ab2FHH51 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2012 03:57:27 -0400
Received: by dady13 with SMTP id y13so2006517dad.19
        for <linux-wireless@vger.kernel.org>; Fri, 08 Jun 2012 00:57:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFR4AqZvhnB3kD_t+817zvEiw16QvNsvMgTwbFxAiogYcSCXEg@mail.gmail.com>
References: <CAFR4AqbeMC23w5j5vdN+hx2pH7M0Aw2epJiBmi29ARPAFeDDQg@mail.gmail.com>
	<201206071518.21171.chunkeey@googlemail.com>
	<CAFR4AqZvhnB3kD_t+817zvEiw16QvNsvMgTwbFxAiogYcSCXEg@mail.gmail.com>
Date: Fri, 8 Jun 2012 01:57:26 -0600
Message-ID: <CAFR4AqahHPR9s4vn+1HFMFk+-oi2ROxLGrqa79ufLJ=Gmzb5rQ@mail.gmail.com> (sfid-20120608_095732_983508_D3C11D2E)
Subject: Re: carl9170 issue
From: Sean Patrick Santos <quantheory@gmail.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I believe that I have found the commit that introduced this problem,
which was a change in mac80211. However, I'm out of my depth in
figuring out what a really "correct" solution is; all I've done is a
trial-and-error bisection. The commit in question:

commit f0425beda4d404a6e751439b562100b902ba9c98
Author: Felix Fietkau <nbd@openwrt.org>
Date:   Sun Aug 28 21:11:01 2011 +0200

    mac80211: retry sending failed BAR frames later instead of tearing down aggr

    Unfortunately failed BAR tx attempts happen more frequently than I
    expected, and the resulting aggregation teardowns cause performance
    issues, as the aggregation session does not always get re-established
    properly.
    Instead of tearing down the entire aggr session, we can simply store the
    SSN of the last failed BAR tx attempt, wait for the first successful
    tx status event, and then send another BAR with the same SSN.

    Signed-off-by: Felix Fietkau <nbd@openwrt.org>
    Cc: Helmut Schaa <helmut.schaa@googlemail.com>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

This looks relevant. As a matter of personal convenience, I might try
backing out the change tomorrow if it seems that it'll help.

On Thu, Jun 7, 2012 at 1:31 PM, Sean Patrick Santos
<quantheory@gmail.com> wrote:
> Thanks for the quick response, Christian,
>
>>> Plus, I'm somewhat stuck with the situation,
>>> since I don't have much control over how things are arranged in this
>>> space, and because the other adapter I have on hand is even worse off,
>>> both in terms of hardware and drivers.
>> Fair enough. But what's the other adapter?
>
> It's a Belkin N150 (http://www.wikidevi.com/wiki/Belkin_F9L1001),
> which didn't seem to work for more that 30 seconds at a time, and had
> low throughput even then. The driver may have improved, or be easier
> to fix, since the last time I tried it, but the actual antenna on the
> device is not suitable for this environment and so I haven't been
> motivated to make it work. The "official" driver on Windows gave
> halfway serviceable performance, emphasis firmly on the "halfway". I
> may get around to re-testing/troubleshooting it if I want to use it
> elsewhere or if I'm bored some time, but that's really a different
> question.
>
>> Your problems sound somewhat familiar to
>> "Re: carl9170 driver - network connection breaks"
>> <http://permalink.gmane.org/gmane.linux.kernel.wireless.general/88223>
>>
>> So far no-one has been able to bisect the bug (last good was 3.1, so
>> to breakage must have occurred between 3.1 and 3.2). I would have
>> looked into it long ago, but I can't reproduce.
>
> I may see if I can bisect it, since evidently I can reproduce the bug
> quite easily. At the least I can find out if this really is the same
> problem and not present in kernel 3.1. I'll let you know if I find
> anything interesting.
>
>> PS: If your kernel was compiled with CONFIG_MAC80211_DEBUGFS you can
>> "restart" BA/aggregation sessions by
>> echo "tx stop 0" > /sys/kernel/debug/ieee80211/phyX/netdev:wlanXY/stations/AP-MAC/agg_status
>> echo "rx stop 0" > /sys/kernel/debug/ieee80211/phyX/netdev:wlanXY/stations/AP-MAC/agg_status
>> alternatively: you can disable ht by loading the module with 'noht=1' parameter
>
> Thanks for the suggestion; I'll try this. I should note that, although
> I can't change the physical locations of anything here (at least for
> another month or two), I do manage both the machine and the wireless
> router.
