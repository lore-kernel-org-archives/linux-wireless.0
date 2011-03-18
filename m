Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qult.net ([82.238.217.46]:50475 "EHLO qult.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755674Ab1CRTnz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2011 15:43:55 -0400
Date: Fri, 18 Mar 2011 20:16:15 +0100
From: Ignacy Gawedzki <i@lri.fr>
To: Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Dividing by a non-static value in carl9170-fw?
Message-ID: <20110318191615.GA10032@zenon.in.qult.net>
References: <20110116031600.GA21973@zenon.in.qult.net>
 <201101161245.54221.chunkeey@googlemail.com>
 <20110116124833.GA4711@zenon.in.qult.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110116124833.GA4711@zenon.in.qult.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Sun, Jan 16, 2011 at 01:48:33PM +0100, thus spake Ignacy Gawedzki:
> On Sun, Jan 16, 2011 at 12:45:53PM +0100, thus spake Christian Lamparter:
> > No need for a hack, just get a udivsi3_i4i.S (a good place is the linux kernel
> > library sources in arch/sh/lib, you could also import one from the original
> > ar9170fw.git) and place it into carlfw/src. Next, you need to modify the
> > carlfw/CMakeLists.txt: add src/udivsi3_i4i.S to carl9170_lib_src and put
> > "set_source_files_properties(src/udivsi3_i4i.S PROPERTIES LANGUAGE C)"
> > a few lines further down.
> > 
> > compile...
> > 
> > [Note: you probably have to change the name of the __udivsi3_i4i symbol 
> > to ___udivsi3_i4i too]
> 
> Great, thanks for the hint, I'll try that as soon as I can.

So I finally got the time to test that solution.  Compilation worked like a
charm indeed, thanks.  All seemed fine until I ran that code.  Indeed the
result of the division is completely off. :(

For instance, if I have A = 17719, B = 44, then A / B gives C = 12886, instead
of the expected 402.  It is as though the result was multiplied by 32.

At this point, it is much simpler for me to simply return both A and B, and to
perform the division on the host's CPU instead of in the FW.  Unless I commit
some gross error and there is a more elegant solution around, I'll stick with
that one, since I don't feel like debugging udivsi3_i4i. :/

Ignacy

-- 
Information wants to be beer, or something like that.
