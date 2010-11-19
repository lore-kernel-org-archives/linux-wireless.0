Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:36282 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932153Ab0KSVui (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Nov 2010 16:50:38 -0500
Received: by gxk23 with SMTP id 23so3034004gxk.19
        for <linux-wireless@vger.kernel.org>; Fri, 19 Nov 2010 13:50:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTi=6s5bivn=6tySopOSXy8eFnsxCustQML7uZbCz@mail.gmail.com>
References: <AANLkTi=6s5bivn=6tySopOSXy8eFnsxCustQML7uZbCz@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 19 Nov 2010 13:50:16 -0800
Message-ID: <AANLkTinveqmsy06wv4GY5STfeTu7ESVN4rjAVC4pa0Vw@mail.gmail.com>
Subject: Re: computing average signal strength tshark
To: Vinod Kone <vinodkone@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 19, 2010 at 11:22 AM, Vinod Kone <vinodkone@gmail.com> wrote:
> Hi Luis,
> I saw that you posted a message a year ago about tshark's average
> computation of signal strength being off. I am facing the same error, and
> was wondering what your fix was.

I have no fix, but the bug was likely in tshark.

  Luis

> From: "Luis R. Rodriguez" <mcgrof@xxxxxxxxx>
> Date: Fri, 19 Jun 2009 17:49:45 -0700
>
>
> Using tshark from svn (today) with ath5k from wireless-testing (today)
> I'm noticing some reporting of a signal value which is completely off
> when using the statistics feature (io,stat). At first I though it was
> ath5k so I went to verify we don't report huge signal values and we
> don't. Right before we hand of the skb to mac80211 I added checked the
> signal value and in all cases it was negative and with in reasonable
> range -- my awk script says -55.219, for instance.
>
> Now if I apply the same awk scrip to the output of 'tshark -V -i moni0
>> dump' and then grep for "SSI Signal" I get a reasonable average.
> This at least allows me to rule out a driver issue.
>
> Instead of running awk scripts I'd like to just use tshark to compute this.
>
> tshark -i moni0 -q -z
> "io,stat,1,AVG(radiotap.dbm_antsignal)radiotap.dbm_antsignal,AVG(radiotap.datarate)radiotap.datarate"
>
> This prints the average signal and rate every second, if you use it
> you'll see the first column is gross:
>
> Capturing on moni0
> ^C1355 packets captured
>
> ===================================================================
> IO Statistics
> Interval: 1.000 secs
> Column #0: AVG(radiotap.dbm_antsignal)radiotap.dbm_antsignal
> Column #1: AVG(radiotap.datarate)radiotap.datarate
>                 |   Column #0    |   Column #1
> Time            |            AVG |            AVG
> 000.000-001.000          14035780                4
> 001.000-002.000          16085960                4
> 002.000-003.000          16976095                5
> 003.000-004.000          19088682                5
> 004.000-005.000          19792417                5
> 005.000-006.000          49367380                5
>
>
> If I decrease the interval to 0.001 I get more reasonable values:
>
> tshark -i moni0 -q -z
> "io,stat,0.001,AVG(radiotap.dbm_antsignal)radiotap.dbm_antsignal,AVG(radiotap.datarate)radiotap.datarate"
>
> 5 packets captured
>
> ===================================================================
> IO Statistics
> Interval: 0.001 secs
> Column #0: AVG(radiotap.dbm_antsignal)radiotap.dbm_antsignal
> Column #1: AVG(radiotap.datarate)radiotap.datarate
>                 |   Column #0    |   Column #1
> Time            |            AVG |            AVG
> 000.000-000.001               -40                2
> 000.001-000.002               -41                2
> 000.002-000.003                 0                0
> 000.003-000.004          2147483602                3
> 000.004-000.005                 0                0
> 000.005-000.006                 0                0
> 000.006-000.007                 0                0
> 000.007-000.008                 0                0
> 000.008-000.009                 0                0
> 000.009-000.010                 0                0
> 000.010-000.011                 0                0
> 000.011-000.012                 0                0
> 000.012-000.013                 0                0
> 000.013-000.014                 0                0
> 000.014-000.015                 0                0
> 000.015-000.016                 0                0
> 000.016-000.017                 0                0
> 000.017-000.018                 0                0
> 000.018-000.019                 0                0
> 000.019-000.020                 0                0
> 000.020-000.021                 0                0
> 000.021-000.022                 0                0
> 000.022-000.023                 0                0
> 000.023-000.024                 0                0
> 000.024-000.025                 0                0
> 000.025-000.026                 0                0
> 000.026-000.027                 0                0
> 000.027-000.028               -64                2
> ===================================================================
>
> But notice that big fat 2147483602. And this is just 5 packets, if you
> let it sit for a few seconds you'll see a lot of these spread out and
> that ruins the average computation.
>
> I'd send a patch but I'm not yet sure where to poke. If you are aware
> where to look at let me know and I'll check it out. I'd like to fix
> this or see this fixed.
>
>   Luis
>
> Thanks,
> -- Vinod
>
