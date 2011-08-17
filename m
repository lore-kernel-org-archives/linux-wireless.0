Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:48886 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798Ab1HQS1Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Aug 2011 14:27:24 -0400
Received: by pzk37 with SMTP id 37so1500744pzk.1
        for <linux-wireless@vger.kernel.org>; Wed, 17 Aug 2011 11:27:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E3420E9.6080603@lwfinger.net>
References: <4E3420E9.6080603@lwfinger.net>
Date: Wed, 17 Aug 2011 20:27:23 +0200
Message-ID: <CACna6ryErHY+OyAnvc9+MYArb5mXpSdadOPADsQOBz796UqSUw@mail.gmail.com> (sfid-20110817_202727_916753_5149B98C)
Subject: Re: Report on bcma with 14e4:4353 (BCM43224)
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: b43-dev <b43-dev@lists.infradead.org>,
	wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 30 lipca 2011 17:19 użytkownik Larry Finger
<Larry.Finger@lwfinger.net> napisał:
> I'm using a recent pull from wireless-testing - 'git describe' results in
> master-2011-07-26-150-g4ea94a9.
>
> The driver is working well with reasonable performance. Using tcpperf, I get
> 8-10 Mb/s upload on an 802.11g connection. The connection has been up for 17
> hours with no disconnects.

Thanks for your testing, I appreciate it! I was busy recently with
other stuff, so didn't have much time to reply and test everything
myself.


> A minor annoyance is that the driver does not autoload on boot and had to be
> manually modprobed. AFAIK, I don't have any blacklisting or other
> configuration parameters that would cause this. Furthermore, I don't see
> anything in the driver code that would cause this. Does autoload work on
> your system?

I've everything blacklisted (ssb, bcma, b43, wl, brcmsmac), so I
didn't even notice that. However I got some reports (2 of them) that
b43 doesn't auto load. I've to take a look at it, however I've no idea
yet on what may be causing it.


> A more serious problem is that the driver does not work on my 802.11n AP
> that is set for "up to 270 Mbps at 2.4 GHz". It will authenticate and
> associate, but the throughput is minimal. It also gets the "PHY transmission
> error" messages. None occur with 802.11g. I would guess some kind of error
> in the HT40 settings.

My network (AP) is set up to work in 802.11g mode and I've performed
first tests today. Not good:
[ ID] Interval       Transfer     Bandwidth
[  4]  0.0-124.5 sec  10.8 MBytes    724 Kbits/sec
I've noticed that connection dies when I force network rate to 54M.
Same for 48M and 9M. Connection works fine for 1M, 2M, 11M.
So this is again OFDM vs. CCK problem.

I didn't see any "PHY transmission error" messages however (maybe it's
matter of firmware? 666.2 here).


Could you take a look if anything has changed in phy_ctl1 in recent
drivers? Do you have any other suspicions?

-- 
Rafał
