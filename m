Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:45001 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714AbaDXXDs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Apr 2014 19:03:48 -0400
Received: by mail-wi0-f172.google.com with SMTP id hi2so1864322wib.11
        for <linux-wireless@vger.kernel.org>; Thu, 24 Apr 2014 16:03:47 -0700 (PDT)
MIME-Version: 1.0
From: Pierre Bourdon <delroth@gmail.com>
Date: Fri, 25 Apr 2014 01:03:26 +0200
Message-ID: <CA+V6dmjwfsrDSDQWHHCFbW9L14GnzifoSjH5UOS4zTSusRtYow@mail.gmail.com> (sfid-20140425_010418_489005_A49FE239)
Subject: Odd network behaviors with an Intel Wireless 7260
To: linux-wireless@vger.kernel.org
Cc: Ryan Houdek <sonicadvance1@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi linux-wireless folks,

I have been getting some weird network behaviors with my Intel
Wireless 7260 adapter that I cannot explain by anything else than a
driver/firmware bug. I'm out of ideas on how to debug this issue.

My network configuration is fairly basic: IPv4 over 802.11n,
AP/default gateway is 192.168.0.1, my Intel 7260 STA is 192.168.0.2.
Several AP/gateway hardware and software have been tested and have
shown the same problem.

On 192.168.0.2 I am constantly running some ICMP pings to 192.168.0.1
and 8.8.8.8. Randomly, the pings from 192.168.0.2 to 8.8.8.8 start
failing (responses never received) while the pings to 192.168.0.1
continue to succeed without any trouble. When tcpdumping on the
gateway, I see the pings to 8.8.8.8 being successfully forwarded and
responses being sent back to the STA (so this is not a routing issue
on the gateway - and again, I've tested several combinations of hw/sw
on the gateway).

Another example: my TCP sessions on the Intel 7260 STA to the internet
will start randomly freezing, but my TCP sessions going through
tunnels on another LAN host (let's say, 192.168.0.3) to the internet
will work fine.

After 30s-1min30 the problem fixes itself and packets start being
received by the STA again.

I only see this from the Intel 7260 host and not from any other WLAN
device connected to the AP, which is another strong evidence that the
issue is on the STA side.

I've shared this with some other people using an Intel 7260 adapter on
Linux and found someone having a similar issue. I'm not sure how
widespread it is and could not find an existing bug report.

What are the next steps to get useful debugging information out of
this issue? I unfortunately do not have the required hardware to do
monitor-mode sniffing of what's happening at the L2 level.

Thanks,

-- 
Pierre "delroth" Bourdon <delroth@gmail.com>
Software Engineer @ Zürich, Switzerland
http://code.delroth.net/
