Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35616 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754620AbcGTPsa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jul 2016 11:48:30 -0400
From: Christian Lamparter <chunkeey@googlemail.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	"driverdev-devel@linuxdriverproject.org"
	<driverdev-devel@linuxdriverproject.org>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Christian Lamparter <chunkeey@googlemail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 2/3] staging/rtl8192e: use s8 instead of char
Date: Wed, 20 Jul 2016 17:48:23 +0200
Message-ID: <3717687.FpcDfXaOEr@debian64> (sfid-20160720_174835_805353_27E594BB)
In-Reply-To: <74d0fd1d-8197-1e4a-1ab1-a879d6dcea4e@gmail.com>
References: <74d0fd1d-8197-1e4a-1ab1-a879d6dcea4e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday, July 20, 2016 5:06:27 PM CEST Xose Vazquez Perez wrote:
> Arnd Bergmann <arnd@arndb.de> wrote:
> 
> > rtlwifi, but I found the older r8712u device to work fine with
> > the staging/rtl8712 driver.
> 
> A replacement for "staging/rtl8712", with MAC80211 support, is
> available at: https://github.com/chunkeey/rtl8192su
> 
> Also a fullmac/cfg80211 driver(r92su) is available at the
> same repository.
> 
Yes, it has its problems. The rtl8712/r92su isn't really
a fullmac device. While the MLME (scan, probe, auth, assoc) is
done by the firmware. The 802.11 frame creation (from 802.3)
frames needs to be done by the driver. The rtl8712 firmware
however has its fair share of issues. Like: no support for
(tx) fragmentation and ERP is a mystery too. monitor 
mode is barely working and limited to 20Mhz wide channels.
There's also limited tx injection support.... and of course
stability issues (just like with the staging/rtl8712 driver
or FreeBSD's rsu driver).

The rtl8192su driver (based on rtlwifi) in the same repository
has proper fragmentation support. But it uses the firmware from
the windows/mac os x driver, which is similar to rtl8192se softmac
firmware in design. Getting it to work properly in station mode
however either needs "some magic" or help from Realtek's USB group...


