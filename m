Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from buzzloop.caiaq.de ([212.112.241.133]:50549 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934064AbZHHMfP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Aug 2009 08:35:15 -0400
Date: Sat, 8 Aug 2009 14:35:12 +0200
From: Daniel Mack <daniel@caiaq.de>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, Roel Kluin <roel.kluin@gmail.com>
Subject: Re: Libertas: Association request to the driver failed
Message-ID: <20090808123512.GZ19257@buzzloop.caiaq.de>
References: <20090807191156.GS19257@buzzloop.caiaq.de> <20090807193610.GK7545@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090807193610.GK7545@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 07, 2009 at 03:36:10PM -0400, John W. Linville wrote:
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
> Normally a bisect is exactly what you would do.

Hmm, I know. However, in my case, this is not possible as I keep a
number of patches I'm actively working on on top of the history by
rebasing my git tree constantly. And without these patches, the platform
won't boot, so bisect will almost certainly come up with an unbootable
image. But that's just a sidenote :)

> In this case, there
> is only this on libertas patch in the range you mention:

I was wrong with the range I provided. The change came in after -rc5,
and I found 57921c31 ("libertas: Read buffer overflow") to be the
culprit. Reverting it brings my libertas device back to life. I copied
the author.

Thanks,
Daniel


