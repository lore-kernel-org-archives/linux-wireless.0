Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qult.net ([82.238.217.46]:59385 "EHLO qult.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752173Ab1APMsj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Jan 2011 07:48:39 -0500
Date: Sun, 16 Jan 2011 13:48:33 +0100
From: Ignacy Gawedzki <i@lri.fr>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Dividing by a non-static value in carl9170-fw?
Message-ID: <20110116124833.GA4711@zenon.in.qult.net>
References: <20110116031600.GA21973@zenon.in.qult.net>
 <201101161245.54221.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201101161245.54221.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jan 16, 2011 at 12:45:53PM +0100, thus spake Christian Lamparter:
> Hello,
> 
> please CC your mails to linux-wireless mailing-list in the future.

Okay, sorry about that.

> On Sunday 16 January 2011 04:16:00 Ignacy Gawedzki wrote:
> > Since I recently noticed that you added the support for the ticks_per_msec
> > field in fw, I thought it would be better to use that to convert durations
> > from ticks to milliseconds, instead of the fixed 44 literal. =)
> 
> Is this a regression on my part? I don't see any references to __udivsi3_i4i
> during build.

Absolutely not.  I'm talking about my (experimental) modifications to the
firmware code to measure TX frame service time and report that in msec in the
tx status.

> Also, you can almost always get around it by converting "a / b = c" to
> "a = b * c".

I doubt so, since what I need to do is roughly

  msec_to_report = ticks_measured / ticks_per_msec;

my input being of course ticks_measured. :/

> > Unfortunately, it seems that dividing by a non-static value is not supported
> > natively on that platform and I get undefined reference to __udivsi3_i4i.  Do
> > you, by any chance, know how to fix that?  Apparently there are some support
> > libs in the toolchain's gcc with that symbol, but I just got lost in the CMake
> > file hierarchy while looking for a place to start hacking that in.
> 
> No need for a hack, just get a udivsi3_i4i.S (a good place is the linux kernel
> library sources in arch/sh/lib, you could also import one from the original
> ar9170fw.git) and place it into carlfw/src. Next, you need to modify the
> carlfw/CMakeLists.txt: add src/udivsi3_i4i.S to carl9170_lib_src and put
> "set_source_files_properties(src/udivsi3_i4i.S PROPERTIES LANGUAGE C)"
> a few lines further down.
> 
> compile...
> 
> [Note: you probably have to change the name of the __udivsi3_i4i symbol 
> to ___udivsi3_i4i too]

Great, thanks for the hint, I'll try that as soon as I can.

Regards,

Ignacy

-- 
To err is human, to moo bovine.
