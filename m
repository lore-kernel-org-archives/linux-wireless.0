Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qb-out-0506.google.com ([72.14.204.228]:44693 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589AbYKTLpP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Nov 2008 06:45:15 -0500
Received: by qb-out-0506.google.com with SMTP id f11so452010qba.17
        for <linux-wireless@vger.kernel.org>; Thu, 20 Nov 2008 03:45:14 -0800 (PST)
Message-ID: <7fe9ff8d0811200345o5c2a219dk256483a55c3b9e6a@mail.gmail.com> (sfid-20081120_124521_052361_A208EBE5)
Date: Thu, 20 Nov 2008 12:45:13 +0100
From: "Kamil Dzida" <kamil.dzida@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Symbol orinoco firmware under BSD, no extracting tools needed
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello, for some time I have been interested in situation of firmware
for Linux drivers. I found something interesting.

Some time ago I found that Agree firmware for orinoco driver was
submitted to linux-firmware tree. From driver documentation
(http://www.linuxwireless.org/en/users/Drivers/orinoco) I found that
orinoco driver also works with Symbol "Spectrum24" chipset. The
documentation states that firmware for that chipset is only available
by cutting it from Windows or Apple drivers (like Broadcom microcode).
Fortunately I found that it is not true. The firmware binary blobs for
Spectrum24 can be found on NetBSD and OpenBSD servers under BSD
license. Both have build in this firmware in their operating systems.


This statement can be found in OpenBSD CVS:

from netbsd:
Generated from the firmware binaries for T3 series CF adapter.
Obtained from Tim Gardner <timg@tpi.com> who developed the Linux driver.
And approved by Brad Lefore <blefore@sj.symbol.com> to redistribute it
with BSD license.

(http://www.openbsd.org/cgi-bin/cvsweb/src/sys/dev/microcode/symbol/esecsym?sortby=rev)

This means that the only difference between firmware that Linux uses
and the *BSD firmware is that BSD people successfully negotiated
license change to BSD. Theoretically by simple drag and dropping the
files from OpenBSD/NetBSD to linux-firmware tree and renaming the
files will allow Linux users out of the box support of Symbol cards
without any firmware extraction tools. Just in case, contacting Mr.
Lefore of Symbol first would be also recommended.

I hope this information will be helpful for orinoco driver development.


OpenBSD resources:
http://www.openbsd.org/cgi-bin/cvsweb/src/sys/dev/microcode/symbol/?sortby=rev#dirlist

and licence:

http://www.openbsd.org/cgi-bin/cvsweb/src/sys/dev/microcode/symbol/symbol-license?rev=1.4;content-type=text%2Fplain;sortby=rev

NetBSD resources:
http://cvsweb.netbsd.org/bsdweb.cgi/src/sys/dev/microcode/wi/?only_with_tag=MAIN
