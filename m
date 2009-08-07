Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f228.google.com ([209.85.220.228]:52845 "EHLO
	mail-fx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754927AbZHGUvI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 16:51:08 -0400
From: Marek Vasut <marek.vasut@gmail.com>
To: libertas-dev@lists.infradead.org
Subject: Re: Libertas: Association request to the driver failed
Date: Fri, 7 Aug 2009 22:50:48 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Daniel Mack <daniel@caiaq.de>, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20090807191156.GS19257@buzzloop.caiaq.de> <20090807193610.GK7545@tuxdriver.com>
In-Reply-To: <20090807193610.GK7545@tuxdriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200908072250.48445.marek.vasut@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dne Pá 7. srpna 2009 21:36:10 John W. Linville napsal(a):
> On Fri, Aug 07, 2009 at 09:11:56PM +0200, Daniel Mack wrote:
> > Since a recent merge of the wireless tree to Linus' master, my SDIO
> > connected libertas module fails to connect to our WLAN.
> >
> > 'iwlist scanning' works fine, but wpa_supplicant keeps on spitting out
> > the following message:
> >
> >   CTRL-EVENT-SCAN-RESULTS
> >   Trying to associate with 00:04:0e:4b:c7:b3 (SSID='caiaq' freq=2437 MHz)
> >   Association request to the driver failed
> >
> > Haven't done any bisect or deeper inspection of recent changes yet. Can
> > anyone point me in some direction maybe? The change must have been
> > introduced between -rc3 and -rc5. My userspace did not change since
> > then.
>
> Normally a bisect is exactly what you would do.  In this case, there
> is only this on libertas patch in the range you mention:
>
> commit 154839962a582b8eb661cde94ef3af0e03b374d7
> Author: Marek Vasut <marek.vasut@gmail.com>
> Date:   Thu Jul 16 19:19:53 2009 +0200
>
>     libertas: Fix problem with broken V4 firmware on CF8381
>
>     Firmware V4 on CF8381 reports region code shifted by 1 byte to left.
>     The following patch checks for this and handles it properly.
>
>     Signed-off-by: Marek Vasut <marek.vasut@gmail.com>
>     Signed-off-by: John W. Linville <linville@tuxdriver.com>
>
> If you revert that, does your problem disappear?
>
> John
Hi!

Those SDIO cards should use FWv9 or something so this patch should have no 
effect.
