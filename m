Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.172]:51110 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754335AbYENAx6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 May 2008 20:53:58 -0400
Received: by wf-out-1314.google.com with SMTP id 27so2984030wfd.4
        for <linux-wireless@vger.kernel.org>; Tue, 13 May 2008 17:53:58 -0700 (PDT)
Subject: Re: [PATCH] b43: use the bitrev helpers rather than rolling a
	private one
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200805140124.07982.mb@bu3sch.de>
References: <1210708518.6191.0.camel@brick>
	 <200805140124.07982.mb@bu3sch.de>
Content-Type: text/plain
Date: Tue, 13 May 2008 17:53:56 -0700
Message-Id: <1210726437.6191.17.camel@brick> (sfid-20080514_025402_084471_DAB95671)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-05-14 at 01:24 +0200, Michael Buesch wrote:
> On Tuesday 13 May 2008 21:55:18 Harvey Harrison wrote:
> > The 4-bit reversal flip_4bit is replaced with the bitrev helper
> > bitrev8 and a 4-bit shift.  The B43_WARN is moved to the location
> > where a register is read from for checking there.  The other caller
> > explicitly passes an array index which is guaranteed to be within range
> > and so a B43_WARN is not added there.
> > 
> > Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> 
> ACK
> 
> But I'd prefer if we had something like the following
> and use that:
> 
> #define bitrev4(x)	(bitrev8(x) >> 4)
> 
> This way the confusing (confusing to me :) ) shifts in the code would go away.
> I have a hard time realizing that
> bitrev8(x) >> 3
> does actually mean
> bitrev4(x) << 1
> Maybe I'm just stupid, though. :)
> 

You're not, this was only valid because x < 16....if bit 4 could be set
this doesn't work anymore as bitrev8(x) >> 4 would truncate bit 4
before shifting left.  So there was some subtlety here that makes >> 3
ok.

Do you want an incremental patch adding a bitrev4 to phy.c or are you
going to add it?

Harvey

