Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:30190 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613AbYBRSLu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2008 13:11:50 -0500
Received: by nf-out-0910.google.com with SMTP id g13so566622nfb.21
        for <linux-wireless@vger.kernel.org>; Mon, 18 Feb 2008 10:11:49 -0800 (PST)
To: "Chris Clayton" <chris2553@googlemail.com>
Subject: Re: 2.6.25-rc2 regression in rt61pci wireless driver
Date: Mon, 18 Feb 2008 19:11:31 +0100
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
References: <c6b1100b0802160406l24fed9dcje1dbfc8907fd7a16@mail.gmail.com>
In-Reply-To: <c6b1100b0802160406l24fed9dcje1dbfc8907fd7a16@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_UpcuH/Ipas2KhNp"
Message-Id: <200802181911.32128.IvDoorn@gmail.com> (sfid-20080218_181200_967345_582647C3)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Boundary-00=_UpcuH/Ipas2KhNp
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

> In 2.6.25 kernels, my wireless LAN dies after even the smallest amount
> of network activity. The following screen cut shows what I typically
> see:

How complete is this failure? Just TX or also RX?

Could you use the tools found here:
http://www-user.rhrk.uni-kl.de/~nissler/rt2x00/index.html

and capture all TX/RX frames going through the hardware?
Note that after the failure, this dumping facitilty should still report
any ping request you might send to the interface.

> [chris:~]$ uname -a
> Linux laptop 2.6.25-rc2 #10 PREEMPT Sat Feb 16 09:53:04 UTC 2008 i686
> GNU/Linux
> [chris:~]$ ping 192.168.1.1
> PING 192.168.1.1 (192.168.1.1) from 192.168.1.30 : 56(84) bytes of data.
> 64 bytes from 192.168.1.1: icmp_seq=0 ttl=255 time=9.837 msec
> 64 bytes from 192.168.1.1: icmp_seq=1 ttl=255 time=3.148 msec
> 64 bytes from 192.168.1.1: icmp_seq=2 ttl=255 time=2.205 msec

I have a series of tests I would like to request from you,
you mentioned you already enabled debugfs, and that is just what we need. ;)
Please use attached script to create dumps of the hardware register contents.

There are specific moments that should be dumped:
- kernel 2.6.24 (last known working version for you).
- kernel 2.6.25-rc2 (after ifup, before TX dies)
- kernel 2.6.25-rc2 (after ifup, after TX dies)
 
> I will be more than happy to provide additional diagnostics, but
> please bear in mind that I am not a git user, so cannot do bisects. I
> am, however, perfectly capable of applying or reverting patches,
> rebuilding and re-testing, so I am quite happy to do that.

Above traces should be enough, but to determine where rt2x00 broke
down approximatly I need to have a few test result on specific moments.
Could you test the kernel with the following versions:

rt2x00 2.0.11	2d68de3efa62655d551092f5c787505735d561ad
rt2x00 2.0.12	a3c7aa58df7df80aa05f166fe3e42482247164cf
rt2x00 2.0.13	5a6012e105ae1664cd2841c33bf59fbdd8d4dbcc

Checking those out is simply a matter of:
git branch 2.0.11 2d68de3efa62655d551092f5c787505735d561ad
git checkout 2.0.11

No further bisecting is needed, but with above tests I can at least
narrow it down to find the cause of this issue.

Thanks.

Ivo

--Boundary-00=_UpcuH/Ipas2KhNp
Content-Type: application/x-shellscript;
  name="debugfsdump.sh"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="debugfsdump.sh"

#!/bin/sh

echo "BBP:"
for ((i = 0; i < `grep bbp ../chipset | cut -d : -f 2` ; i++));
do
	echo -n "$i "
	echo $i > bbp_offset
	cat bbp_value
done

echo "CSR:"
for ((i = 0; i < `grep csr ../chipset | cut -d : -f 2`; i++));
do
	echo -n "$i "
	echo $i > csr_offset
	cat csr_value
done

echo "EEPROM:"
for ((i = 0; i < `grep eeprom ../chipset | cut -d : -f 2`; i++));
do
	echo -n "$i "
	echo $i > eeprom_offset
	cat eeprom_value
done

--Boundary-00=_UpcuH/Ipas2KhNp--
