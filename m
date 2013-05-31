Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:45903 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813Ab3EaFMm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 May 2013 01:12:42 -0400
Received: by mail-pd0-f181.google.com with SMTP id bv13so1562852pdb.40
        for <linux-wireless@vger.kernel.org>; Thu, 30 May 2013 22:12:42 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 30 May 2013 22:12:41 -0700
Message-ID: <CAFVsH1JXZ-UmUPPRZ17DC+Fu9qomSVLPZd6byedq1EzrySsT4g@mail.gmail.com> (sfid-20130531_071245_840771_17E681AC)
Subject: incoming packets seemed to be delayed with rtl8723ae
From: Chris David <chris@chrisdavid.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I have an rtl8723ae card.  I'm noticing a "minature" version of the
bug reported with this subject line:
rtl8723ae losing IP connectivity (3.8.2 + 3.9-rc2)
http://thread.gmane.org/gmane.linux.kernel.wireless.general/105646

My description would be:  When I ping the machine this card is
installed in from another machine, some packets seemed to be delayed.
Here is a sample ping output:

64 bytes from 192.168.1.15: icmp_req=194 ttl=64 time=2002 ms
64 bytes from 192.168.1.15: icmp_req=195 ttl=64 time=996 ms
64 bytes from 192.168.1.15: icmp_req=196 ttl=64 time=1.15 ms
64 bytes from 192.168.1.15: icmp_req=197 ttl=64 time=1.25 ms
64 bytes from 192.168.1.15: icmp_req=198 ttl=64 time=2002 ms
64 bytes from 192.168.1.15: icmp_req=199 ttl=64 time=1002 ms
64 bytes from 192.168.1.15: icmp_req=200 ttl=64 time=3.66 ms
64 bytes from 192.168.1.15: icmp_req=201 ttl=64 time=5.46 ms
64 bytes from 192.168.1.15: icmp_req=202 ttl=64 time=2.21 ms
64 bytes from 192.168.1.15: icmp_req=203 ttl=64 time=1005 ms
64 bytes from 192.168.1.15: icmp_req=204 ttl=64 time=5.73 ms
64 bytes from 192.168.1.15: icmp_req=205 ttl=64 time=1.25 ms
64 bytes from 192.168.1.15: icmp_req=206 ttl=64 time=1.72 ms
64 bytes from 192.168.1.15: icmp_req=207 ttl=64 time=1011 ms

As you can see, sometimes there is a second or two delay, other times
its very quick.  And the delayed packets seem to happen every second
or two, very consistently.

This happens to be on kernel 3.9.4, with the backports-3.10-rc1
drivers installed.  But I've seen this behavior on a 3.8.13 kernel
also with the same backports, and also on 3.10-rc3.  On 3.9.4 and
3.8.13 without backports, I observe the same issue except its 50
seconds, instead of 2.

I've seen this behaviour with wpa_supplicant using both the wext
driver on 3.8.18, and the nl80211 driver on 3.9.4.

If the pings are sourced from the box with the 8723ae installed, I
don't observe this behavior.  Its only when the pings come from some
external box.  Also, when I ssh into the box with the 8723ae from an
external machine, I notice the same sort of delays with the commands
that I type.  (its making me a better typist!)

It's "as-if" the buffer for incoming packets (at least TCP and UDP),
likes to hang on to the data for roughly mod(gettime(), 2) amount of
time.

I'm definitely willing to try patches, and even might have the skill
to fix it.  But if anybody has hints or advice, or perhaps a reference
to the patch that reeled this bug in from 50 seconds to 2 seconds,
that would be good information for me to know.  Also, I really don't
know its a 8723ae problem.  But, I can say I don't observe this
behavior on the wired ethernet ports on the same box.  So it seems at
least wireless related.

There's not much in dmesg that looks out of place.  And iw event -t
doesn't print anything while this issue happens.
[    4.724126] rtl8723ae: Using firmware rtlwifi/rtl8723fw_B.bin

BTW, I'm subscribed to this email list.

Thank you,

-Chris
