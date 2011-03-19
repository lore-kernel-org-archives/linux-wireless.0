Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36258 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932764Ab1CSAnf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2011 20:43:35 -0400
Received: by fxm17 with SMTP id 17so4196164fxm.19
        for <linux-wireless@vger.kernel.org>; Fri, 18 Mar 2011 17:43:34 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Ignacy Gawedzki <i@lri.fr>
Subject: Re: Dividing by a non-static value in carl9170-fw?
Date: Sat, 19 Mar 2011 01:43:26 +0100
Cc: linux-wireless@vger.kernel.org
References: <20110116031600.GA21973@zenon.in.qult.net> <20110116124833.GA4711@zenon.in.qult.net> <20110318191615.GA10032@zenon.in.qult.net>
In-Reply-To: <20110318191615.GA10032@zenon.in.qult.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201103190143.27042.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 18 March 2011 20:16:15 Ignacy Gawedzki wrote:
> On Sun, Jan 16, 2011 at 01:48:33PM +0100, thus spake Ignacy Gawedzki:
> > On Sun, Jan 16, 2011 at 12:45:53PM +0100, thus spake Christian Lamparter:
> > > No need for a hack, just get a udivsi3_i4i.S (a good place is the linux kernel
> > > library sources in arch/sh/lib, you could also import one from the original
> > > ar9170fw.git) and place it into carlfw/src. Next, you need to modify the
> > > carlfw/CMakeLists.txt: add src/udivsi3_i4i.S to carl9170_lib_src and put
> > > "set_source_files_properties(src/udivsi3_i4i.S PROPERTIES LANGUAGE C)"
> > > a few lines further down.
> > > 
> > > compile...
> > > 
> > > [Note: you probably have to change the name of the __udivsi3_i4i symbol 
> > > to ___udivsi3_i4i too]
> > 
> > Great, thanks for the hint, I'll try that as soon as I can.
> 
> So I finally got the time to test that solution.  Compilation worked like a
> charm indeed, thanks.  All seemed fine until I ran that code.  Indeed the
> result of the division is completely off. :(
> 
> For instance, if I have A = 17719, B = 44, then A / B gives C = 12886, instead
> of the expected 402.  It is as though the result was multiplied by 32.

I gave it a try and It worked?!

[54670.551750] ieee80211 phy14: FW: a:0x4537 b:0x2c a/b:0x192 (0x192 = 402).

(It was nothing else than just define "a" and "b" (as global variables) and
add the INFO("a:0x%x b:0x%x a/b:0x%x", a, b, a/b);)

Regards,
	Chr
