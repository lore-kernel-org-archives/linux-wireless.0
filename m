Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2054 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755034Ab1JZSgJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Oct 2011 14:36:09 -0400
Message-ID: <4EA8530E.1050204@broadcom.com> (sfid-20111026_203614_373268_9C267A2F)
Date: Wed, 26 Oct 2011 20:35:58 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Piotr Karbowski" <piotr.karbowski@gmail.com>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: Re: brcm80211 in linux-next git.
References: <4EA82F9A.6000709@gmail.com>
In-Reply-To: <4EA82F9A.6000709@gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/26/2011 06:04 PM, Piotr Karbowski wrote:
> Hi there,
> 
> The question is, when the brcm80211 changes from linux-next will hit 
> normal kernel? Using compat-wireless is not quite cool, I don't like 
> idea of building modules instead of using regular kernel one, I also 
> tried copy drivers/net/wireless/brcm80211 to my kernel's 
> drivers/staging/brcm80211 but after compilation and loading modules I 
> tried to connect to my network but then my system was frozen, music 
> stopped, everything stopped.

linux-next is a normal kernel, but with the next best/bad stuff.
However, your 'normal' kernel will probably mean a kernel coming from
linus (posted on kernel.org).

I think compat-wireless is pretty cool. It provides the 'regular' kernel
modules of a new kernel in an older kernel. Especially manufacturers who
are not so eager to use the latest kernels
Bottom line is that until kernel 3.1 the brcm80211 drivers exist in
drivers/staging and we made a move to drivers/net/brcm80211 couple of
weeks ago. This means that it will pop-up in 3.2 kernels. Merge window
is now active so in about 2 weeks 3.2-rc1 will be there with
drivers/net/wireless/brcm80211.

> I wonder how I could port the brcm80211 code from linux-next to normal 
> kernel, is there any tutorial on how should looks like the workflow when 
> you want pull *some* code from linux-next git? I didn't find any.

Not sure how familiar you are with git, but it all starts with a 'git
clone' command. On git.kernel.org you can find the linux-next url.

$ git clone
git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git

et voila. You will have a linux-next folder pretty much like you would
have when untar-ring a .tar.gz file and you can build your kernel from
there.

> Anyway, thanks for working on this driver! ;-)
> 
> -- Piotr.
> 

Gr. AvS

