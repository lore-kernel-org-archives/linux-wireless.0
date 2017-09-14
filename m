Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:46668 "EHLO
        mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751173AbdINAjh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Sep 2017 20:39:37 -0400
Received: by mail-io0-f177.google.com with SMTP id d16so10928620ioj.3
        for <linux-wireless@vger.kernel.org>; Wed, 13 Sep 2017 17:39:36 -0700 (PDT)
Subject: Re: rtl8821ae keep alive not set, connection lost
To: James Cameron <quozl@laptop.org>
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <20170912220916.GB32211@us.netrek.org>
 <59e28611-9840-8873-2f15-1263e4e93d1c@lwfinger.net>
 <20170913214649.GC20283@us.netrek.org>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <5f16881e-471b-4ffc-5e5e-93785bb999b6@lwfinger.net> (sfid-20170914_023940_354920_589BA614)
Date: Wed, 13 Sep 2017 19:39:35 -0500
MIME-Version: 1.0
In-Reply-To: <20170913214649.GC20283@us.netrek.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/13/2017 04:46 PM, James Cameron wrote:
> 
> I'll give it some more testing and let you know, but it seems as
> capable of keeping a connection as 4.13 plus my earlier revert.
> 

The change I sent earlier should be as good as reverting the change to 
write_byte in your reversion.

There has been a report (in Russian unfortunately) at 
https://www.linux.org.ru/forum/desktop/12620193 of delays in ARP handling. 
According to Google translate is as follows:

============================================================
Periodically, Wi-Fi networker rtl8821ae ceases to respond to ARP, which causes 
the Internet to end. Wireshark looks quite interesting: ARP replays can be sent 
by one large packet a few seconds after receiving the requests, ie. they seem to 
be buffered somewhere.

arping, launched under strace, also hints at certain problems:
sendto(3, 
"\0\1\10\0\6\4\0\1\334\205\336\3572\343\300\250\0h\377\377\377\377\377\377\300\250\0\1", 
28, 0, {sa_family=AF_PACKET, proto=0x806, if3, pkttype=PACKET_HOST, addr(6)={1, 
ffffffffffff}, 20) = -1 ENOBUFS (No buffer space available)
alarm(1)                                = 0
rt_sigreturn()                          = 45
recvfrom(3, 0x7fffc1646030, 4096, 0, 0x7fffc1645fb0, 0x7fffc1645eac) = ? 
ERESTARTSYS (To be restarted if SA_RESTART is set)
--- SIGALRM {si_signo=SIGALRM, si_code=SI_KERNEL} ---
sendto(3, 
"\0\1\10\0\6\4\0\1\334\205\336\3572\343\300\250\0h\377\377\377\377\377\377\300\250\0\1", 
28, 0, {sa_family=AF_PACKET, proto=0x806, if3, pkttype=PACKET_HOST, addr(6)={1, 
ffffffffffff}, 20) = -1 ENOBUFS (No buffer space available)
alarm(1)                                = 0
rt_sigreturn()                          = 45
recvfrom(3, 0x7fffc1646030, 4096, 0, 0x7fffc1645fb0, 0x7fffc1645eac) = ? 
ERESTARTSYS (To be restarted if SA_RESTART is set)
--- SIGALRM {si_signo=SIGALRM, si_code=SI_KERNEL} ---
recvfrom(3, 0x7fffc1646030, 4096, 0, 0x7fffc1645fb0, 0x7fffc1645eac) = ? 
ERESTARTSYS (To be restarted if SA_RESTART is set)
--- SIGALRM {si_signo=SIGALRM, si_code=SI_KERNEL} ---
sendto(3, 
"\0\1\10\0\6\4\0\1\334\205\336\3572\343\300\250\0h\377\377\377\377\377\377\300\250\0\1", 
28, 0, {sa_family=AF_PACKET, proto=0x806, if3, pkttype=PACKET_HOST, addr(6)={1, 
ffffffffffff}, 20) = -1 ENOBUFS (No buffer space available)
============================================================

I need to explore that ENOBUFS return code.

Your case where the device is unresponsive to pings from another NIC until the 
device transmits may also be an ARP problem.

For completeness, are you using the 2.4 of 5 GHz band? What is the make/model 
your AP? If possible for you to determine, what firmware is it running?

Thanks,

Larry
