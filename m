Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:19958 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754999Ab0E1Qfk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 May 2010 12:35:40 -0400
Subject: Re: Realtek rtl8188 support?
From: Pavel Roskin <proski@gnu.org>
To: =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
Cc: Paul Thomas <pthomas8589@gmail.com>,
	linux-wireless@vger.kernel.org,
	Andrea Merello <andreamrl@tiscali.it>
In-Reply-To: <AANLkTin6cAHj2p266yMLQkrpkhCdX98leNl5F8f3DAJR@mail.gmail.com>
References: <c785bba31003060945j22be2e78pfeaa1bcd39fcba2c@mail.gmail.com>
	 <69e28c911003061007y258ec349laa802810e0517de4@mail.gmail.com>
	 <1267949782.15192.13.camel@mj>
	 <69e28c911003070736t678cf6ccld0fe6dc332f4380d@mail.gmail.com>
	 <1268190973.10669.12.camel@mj>
	 <c785bba31003291519tfd7d26fy466a4ee4310ac590@mail.gmail.com>
	 <1274911569.2593.8.camel@mj>
	 <AANLkTin6cAHj2p266yMLQkrpkhCdX98leNl5F8f3DAJR@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 May 2010 12:35:38 -0400
Message-Id: <1275064538.15168.21.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-05-27 at 00:21 +0200, Gábor Stefanik wrote:
> > But I cannot find the "r8192s_usb" symbol in any staging drivers, so I
> > have no idea which driver you are talking about.
> 
> r8192s_usb is not a symbol, it is the name of the module being loaded.

Oh, I see.  That means the driver is rtl8192su.  But its Kconfig file
already selects WIRELESS_EXT.  git log should that it was fixed by the
last commit to drivers/staging/rtl8192su/Kconfig:

commit 784d3119475652d34a8d8ec3911e39c5e3d3036f
Author: Simon Horman <horms@verge.net.au>
Date:   Mon Dec 21 15:07:10 2009 +1100

    Staging: rtl8192su: Build should select WIRELESS_EXT

As for the PCI dependency, it's probably wrong.  USB used to depend on
PCI, but I understand it's no longer true.

-- 
Regards,
Pavel Roskin
