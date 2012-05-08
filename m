Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:37444 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203Ab2EHMzH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 May 2012 08:55:07 -0400
Received: by yhmm54 with SMTP id m54so5263721yhm.19
        for <linux-wireless@vger.kernel.org>; Tue, 08 May 2012 05:55:07 -0700 (PDT)
Date: Tue, 8 May 2012 08:54:52 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Dmitry Tarnyagin <abi.dmitryt@gmail.com>
Cc: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 09/21] cw1200: txrx.*, implementation of datapath.
Message-ID: <20120508125452.GA15792@localhost> (sfid-20120508_145513_580360_9A929DC8)
References: <1330652495-25837-1-git-send-email-dmitry.tarnyagin@stericsson.com>
 <1330652495-25837-10-git-send-email-dmitry.tarnyagin@stericsson.com>
 <20120507125316.GA25400@localhost>
 <CAMG6FYgQLexa=VAqrLmMxscef=bDyqPo6mThYAeZGqB6p5Zo_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAMG6FYgQLexa=VAqrLmMxscef=bDyqPo6mThYAeZGqB6p5Zo_g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 08, 2012 at 09:09:24AM +0200, Dmitry Tarnyagin wrote:
> Yes, correct, you mentioned all the 3 problems with the minstrel.
> "Buggy" is not the best word here, minstrel just behaves in this way,
> and the behavior is specified. It can be changed (at least last two),
> but carefully and with respect to other minstrel clients.

OK, thanks.  I (and others) had also noticed these issues a while ago;
I guess we should take a look at fixing it in the core.

> As I remember compiler changes divide to a shift only for
> unsigned divisions, isn't it? Or do modern gcc-s changes it for signed
> divs as well?

It's easy enough to check.  I can't speak for ARM, but on gcc 4.6.0
for x86, I get the following:

signed x / 2 compiles to (%eax = dividend):

    mov    %eax,%edx             ; put x into edx
    shr    $0x1f,%edx            ; edx >>= 31, so sign of x is LSB of edx
    add    %edx,%eax             ; eax += 1 (round up) if eax is signed
    sar    %eax                  ; arithmetic (sign-preserving) shift right eax

This sequence corrects for, say, -3 / 2 == -1 vs -3 >> 1 == -2.

unsigned x / 2 compiles to:

    shr    %eax                  ; same as x >> 1

Gcc has some neat tricks -- even something like "x * 22/7" gets turned
into a pair of multiplies.

> Well, it's datapath. This code is executed for every SDU in data traffic,
> with frequency ~3kHz on target throughput. For me it's a good reason
> to explicitly eliminate divisions :)

Fair enough :)

-- 
Bob Copeland %% www.bobcopeland.com
