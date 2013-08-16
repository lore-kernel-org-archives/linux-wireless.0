Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51195 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753571Ab3HPRLq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Aug 2013 13:11:46 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1VANYv-0000Gs-8s
	for linux-wireless@vger.kernel.org; Fri, 16 Aug 2013 19:11:45 +0200
Received: from host138.53.237.84.nsu.ru ([host138.53.237.84.nsu.ru])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 16 Aug 2013 19:11:45 +0200
Received: from mezin.alexander by host138.53.237.84.nsu.ru with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 16 Aug 2013 19:11:45 +0200
To: linux-wireless@vger.kernel.org
From: Alexander Mezin <mezin.alexander@gmail.com>
Subject: Re: Kernel Panic with Linux 3.10-6
Date: Fri, 16 Aug 2013 17:11:25 +0000 (UTC)
Message-ID: <loom.20130816T190153-319@post.gmane.org> (sfid-20130816_191150_859055_547CB150)
References: <CAHgnS=pnv0AV7JoDq5MCFMsDO60g1a_av0b6F-UM6V0m-7e=eQ@mail.gmail.com> <520C9FE5.6000203@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend@...> writes:

> 
> On 08/15/2013 03:28 AM, Pedram Navid wrote:
> > With the latest 3.10-6 kernel I am receiving frequent and consistent
> > kernel panics. Downgrading to 3.9.5 resolves the issue.
> 
> Thanks, Pedram
> 
> I have had a couple of other report about this particular panic and did 
> some investigation. It is a divide-by-zero causing the panic. I do have 
> a patch to avoid that, but the root cause is something else. Is 3.10.6 
> you see this on the unmodified stable release?
> 
> The attached patch avoids the panic, but you will probably have crappy 
> connectivity.
> 
> Regards,
> Arend
> 

I've temporarily solved the problem by reverting patch "mac80211/minstrel_ht: 
fix cck rate sampling" [1]. After that - no error messages, no panic, 
connection works at normal speed.

[1] https://git.kernel.org/cgit/linux/kernel/git/stable/linux-
stable.git/commit/?id=ef47a5e4f1aaf1d0e2e6875e34b2c9595897bef6

