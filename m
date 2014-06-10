Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19016 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751273AbaFJGjw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jun 2014 02:39:52 -0400
Date: Tue, 10 Jun 2014 08:38:24 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Powerful Notageek <powerfulnotageek@yahoo.in>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	users@rt2x00.serialmonkey.com
Subject: Re: MT7630e availability in kernel by default
Message-ID: <20140610063824.GD1720@redhat.com> (sfid-20140610_083956_134700_9C9BCF9B)
References: <1402159087.63238.YahooMailNeo@web193001.mail.sg3.yahoo.com>
 <53935133.5020303@lwfinger.net>
 <1402163980.67578.YahooMailNeo@web193003.mail.sg3.yahoo.com>
 <539356EA.1070004@lwfinger.net>
 <1402165531.45127.YahooMailNeo@web193003.mail.sg3.yahoo.com>
 <53935FFE.10708@lwfinger.net>
 <1402168424.40608.YahooMailNeo@web193005.mail.sg3.yahoo.com>
 <53936C6E.8070800@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53936C6E.8070800@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jun 07, 2014 at 02:47:58PM -0500, Larry Finger wrote:
> On 06/07/2014 02:13 PM, Powerful Notageek wrote:
> >dmesg says nothing and there's probably no firmware for the device (although linux-firmware is installed)
> >
> >These are the firmwares available to me:
> >
> >[root@localhost ~]# ll /usr/lib/firmware/rt2*
> >-rw-r--r--. 1 root root 8192 Mar 18 00:08 /usr/lib/firmware/rt2561.bin
> >-rw-r--r--. 1 root root 8192 Mar 18 00:08 /usr/lib/firmware/rt2561s.bin
> >-rw-r--r--. 1 root root 8192 Mar 18 00:08 /usr/lib/firmware/rt2661.bin
> >-rw-r--r--. 1 root root 8192 Mar 18 00:08 /usr/lib/firmware/rt2860.bin
> >-rw-r--r--. 1 root root 8192 Mar 18 00:08 /usr/lib/firmware/rt2870.bin
> 
> I looked more closely at the code in
> https://github.com/anthonywong/mt7630. There are a number of places
> where there are branches specific to the MT7630.
This driver is quite nice mix of rt2800pci and Mediatek/Ralink driver,
where MT7xx code was copied into rt2x00 from venodr driver. It can be
good start for adding support for mt7xx devices to rt2x00.

> It also needs a
> firmware file named mt7630.bin. Unfortunately, that file is not
> found in the repo, and a quick Google search failed to find it. The
> linux-firmware git repo has a file named mt7650.bin, but I think
> that is Bluetooth firmware.

Indeed, it is hard to find it.

> Unfortunately, there does not seem to be an easy fix, and only
> someone with the hardware could modify rt2800pci to support this
> device.

Yep, some substantial amount of work is needed to add support to new
MT7xxx chips properly to rt2x00.

Stanislaw
