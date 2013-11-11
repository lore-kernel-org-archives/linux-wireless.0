Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f173.google.com ([209.85.223.173]:65511 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286Ab3KKVz5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Nov 2013 16:55:57 -0500
Received: by mail-ie0-f173.google.com with SMTP id x13so5960363ief.18
        for <linux-wireless@vger.kernel.org>; Mon, 11 Nov 2013 13:55:57 -0800 (PST)
Date: Mon, 11 Nov 2013 14:55:53 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: wzyboy <wzyboy@wzyboy.org>
Cc: Emmanuel Grumbach <egrumbach@gmail.com>,
	"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [Ilw] Intel Wireless 7260 hardware timed out randomly
Message-ID: <20131111215553.GA30509@google.com> (sfid-20131111_225610_821324_DD578655)
References: <CALkVjQZRJw7ghjBa1aPKNKe3Zj2B1Mhk5bWVaRdcCYzfoLRovg@mail.gmail.com>
 <CALkVjQY7r=YKhsgDKR0mnYVtZy5BAdj83nY2jL0VFaiew6ha7A@mail.gmail.com>
 <0BA3FCBA62E2DC44AF3030971E174FB301DEA097@HASMSX103.ger.corp.intel.com>
 <CALkVjQY7uRFQ3Qs9T_bgqnYRNcWgsk5gfd=R8RfGFxOdDpFYTQ@mail.gmail.com>
 <527A8166.6000701@gmail.com>
 <CAErSpo5H9Mf-xmdzThudNO2WHAOt-1T7CQZvgGUmK4jm7_zf+g@mail.gmail.com>
 <CALkVjQaHYpR4Tifbt7nh4VeQSrOz5J-xxSrUBKX2kXCZcvkivA@mail.gmail.com>
 <CAErSpo5dX=cPdThxi-ok=B4beo_jPv2n2n0C1u4UyZMbQDMxqg@mail.gmail.com>
 <CAErSpo6ry6cUaVngozS8-P44=LPJN6cbsZ_mfWkJv9Rn85YXUQ@mail.gmail.com>
 <CALkVjQZEs1CqMEVApDDGZ6FDugPZ+-F5wzvE45+jB5Xrhv_N2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CALkVjQZEs1CqMEVApDDGZ6FDugPZ+-F5wzvE45+jB5Xrhv_N2A@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 10, 2013 at 06:19:58PM +0800, wzyboy wrote:
> 2013/11/9 Bjorn Helgaas <bhelgaas@google.com>:
> > it might
> > be interesting to do "echo on >
> > /sys/bus/pci/devices/0000:03:00.0/power/control" and see whether it
> > makes a difference.
> 
> Hi, should I run this command after the bug? I just ran this after the
> bug occurs, but there is no output in dmesg, and "ip link set wlan0
> up" still returns same error ("RTNETLINK answers: Connection timed
> out").

Run the command before the bug occurs.  The idea is to disable run-time
power management.  If the problem is that we're turning off power to
the device, disabling power management might make a difference.

Bjorn
