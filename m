Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:51854 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753626Ab1ATLZG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jan 2011 06:25:06 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1PfsdU-000537-To
	for linux-wireless@vger.kernel.org; Thu, 20 Jan 2011 12:25:05 +0100
Received: from 145.90.70.115.static.exetel.com.au ([115.70.90.145])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 20 Jan 2011 12:25:04 +0100
Received: from conflatulence by 145.90.70.115.static.exetel.com.au with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 20 Jan 2011 12:25:04 +0100
To: linux-wireless@vger.kernel.org
From: zach <conflatulence@gmail.com>
Subject: Re: [PATCH] Kernel Panic on Associate with brcm80211.
Date: Thu, 20 Jan 2011 11:21:26 +0000 (UTC)
Message-ID: <loom.20110120T120235-29@post.gmane.org>
References: <4D334D00.4030604@mythicnet.org> <4D3521FD.9020001@mythicnet.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ilya Kogan <ikogan@...> writes:

> 
> I'm going to admit I'm fairly new to this but after some reading, I 
> couldn't quite understand why there is an assertion ensuring that the 
> sk_buff being sent is not cloned. I was going to see what exploded if I 
> removed it and to my surprise...nothing did. In fact, except for a few
> 
> [12014.013409] wl0: wlc_d11hdrs_mac80211: AC_BE txop exceeded phylen 
> 382/256 dur 3562/1504
> 
> things seem to work fine. I'll be doing some more testing with this over 
> the next couple of days. What obvious thing does this break horribly?
> 

Hi, I think I had the same panic on emachines em350 with BCM4313 using Fedora 14
and kernel 2.6.38-rc1. Network manager applet shows little blue dots going round
and then panic. Applying your change solved it. Thanks!
Photo of panic
http://picasaweb.google.com/lh/photo/hWEO_uFGNO-jAKjqhyJvkLevz6n8KX8fvZ44UIlA3yw?feat=directlink

config http://pastebin.com/9z8AmJ3E

zach

