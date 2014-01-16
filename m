Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from zimbra.real-time.com ([63.170.91.9]:53302 "EHLO
	zimbra.real-time.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbaAPFz7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jan 2014 00:55:59 -0500
Date: Thu, 16 Jan 2014 16:55:47 +1100
From: James Cameron <quozl@laptop.org>
To: Olivier Langlois <olivier@trillion01.com>
Cc: linux-wireless@vger.kernel.org, daniel@zonque.org
Subject: Re: [ISSUE] rtl8192ce appears to interfere with ALSA playback
Message-ID: <20140116055547.GU19393@us.netrek.org> (sfid-20140116_065604_316719_4DA6D4A8)
References: <1389767820.2436.45.camel@Wailaba2>
 <52D6BEEF.5050705@lwfinger.net>
 <52D76D56.6060906@trillion01.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <52D76D56.6060906@trillion01.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 16, 2014 at 12:25:42AM -0500, Olivier Langlois wrote:
> On 01/15/2014 12:01 PM, Larry Finger wrote:
> >On 01/15/2014 12:37 AM, Olivier Langlois wrote:
> >>How to reproduce:
> >>
> >>1. Enable Wifi while not connecting to any AP.
> >>2. lano1106@hpmini ~/Music $ aplay -c1 sine.wav
> >>underrun!!! (at least 1856093977.967 ms long)

Indeed, that timing is fishy.

I've looked at the alsa-devel thread [1] and your problem description
there.

At OLPC during development we found similar symptoms showing up in
ALSA playback that were contributed to other drivers, but the
underlying causes were in the ALSA driver for our codec chip, and the
other drivers were changing the appearance of the fault only because
of timing changes.

But there's no need to conclude that interrupts were disabled or
delayed.  There can be many other causes.

The timing miscalculation by ALSA might be important.  I can't figure
out how a wireless driver can easily cause that.

1.
http://mailman.alsa-project.org/pipermail/alsa-devel/2014-January/071142.html

-- 
James Cameron
http://quozl.linux.org.au/
