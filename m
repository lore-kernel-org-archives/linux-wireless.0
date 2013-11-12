Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f49.google.com ([209.85.215.49]:63822 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753801Ab3KLHCx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Nov 2013 02:02:53 -0500
MIME-Version: 1.0
In-Reply-To: <CALkVjQb-AJRSGARCQaDFkd+mHBk2qFkAVyVBTW7RHSaxzbZsbw@mail.gmail.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB301DEA052@HASMSX103.ger.corp.intel.com>
	<CALkVjQZRJw7ghjBa1aPKNKe3Zj2B1Mhk5bWVaRdcCYzfoLRovg@mail.gmail.com>
	<CALkVjQY7r=YKhsgDKR0mnYVtZy5BAdj83nY2jL0VFaiew6ha7A@mail.gmail.com>
	<0BA3FCBA62E2DC44AF3030971E174FB301DEA097@HASMSX103.ger.corp.intel.com>
	<CALkVjQY7uRFQ3Qs9T_bgqnYRNcWgsk5gfd=R8RfGFxOdDpFYTQ@mail.gmail.com>
	<527A8166.6000701@gmail.com>
	<CAErSpo5H9Mf-xmdzThudNO2WHAOt-1T7CQZvgGUmK4jm7_zf+g@mail.gmail.com>
	<CALkVjQaHYpR4Tifbt7nh4VeQSrOz5J-xxSrUBKX2kXCZcvkivA@mail.gmail.com>
	<CAErSpo5dX=cPdThxi-ok=B4beo_jPv2n2n0C1u4UyZMbQDMxqg@mail.gmail.com>
	<CALkVjQYkAWrwRabQfBSvC1pm47ZyRT5jQ0mYBwbiGh-Bt29gbg@mail.gmail.com>
	<20131111224439.GA30638@google.com>
	<CALkVjQb-AJRSGARCQaDFkd+mHBk2qFkAVyVBTW7RHSaxzbZsbw@mail.gmail.com>
Date: Tue, 12 Nov 2013 09:02:51 +0200
Message-ID: <CANUX_P2O26WcBfPC41-m4NWMhzFD90h_qT8C-ntQ79y1a6Q4Qw@mail.gmail.com> (sfid-20131112_080308_274878_AF8BECED)
Subject: Re: [Ilw] Intel Wireless 7260 hardware timed out randomly
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: wzyboy <wzyboy@wzyboy.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
	"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 12, 2013 at 7:42 AM, wzyboy <wzyboy@wzyboy.org> wrote:
> Hi, I've got some good news. Here is what I did today:
>
> boot up laptop -> do the sysfs trick -> start downloading a big file
> to benchmark it -> several minutes later the bug occurs -> reboot my
> laptop to recover -> do the setpci trick -> start downloading a big
> file to benchmark it -> more than 5 GiB downloaded (at ~ 2.3 MiB/s)
> and everything works fine!

encouraging. Thanks.
I just wonder... the patch I sent was supposed to tell the HW not to
use L1. So I would have hoped it would have helped in the same way?
After all, L1 is a handshake between the device and the bridge, so
that if the device doesn't initiate / refuses to go into L1, I'd
expect it to have the same effect as disabling L1 in the ASPM register
PCIe config space?
Obviously I am wrong though.

>
> Here are the output of lspci -vv after running two "setpci" commands.
>
> There is also a screenshot of ThinkPad X240s HMM, showing how the
> wireless card is connected to the motherboard. In this figure #10 is
> the Wireless LAN card. It is connected to the motherboard with Intel's
> NGFF connector.
>
> I will continue downloading big files to benchmark it.
>

Thanks

> --
> wzyboy
