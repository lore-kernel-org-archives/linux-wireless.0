Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f227.google.com ([209.85.220.227]:58738 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752AbZJKWCS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Oct 2009 18:02:18 -0400
Received: by fxm27 with SMTP id 27so8491630fxm.17
        for <linux-wireless@vger.kernel.org>; Sun, 11 Oct 2009 15:01:40 -0700 (PDT)
Date: Mon, 12 Oct 2009 00:00:02 +0200
From: Richard Zidlicky <rz@linux-m68k.org>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: 2.6.31.[12] ath5k regression
Message-ID: <20091011220002.GA11603@linux-m68k.org>
References: <20090621134954.GA31505@linux-m68k.org> <20090621180447.GA29469@hash.localnet> <20090623174616.GA3914@linux-m68k.org> <20090623202541.GA3635@hash.localnet> <20090625083636.GA6323@linux-m68k.org> <20090705123105.GE2132@hash.localnet> <20091009143922.GA7848@linux-m68k.org> <20091010125824.GA18841@hash.localnet> <20091011122616.GA27105@linux-m68k.org> <20091011133010.GA21494@hash.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20091011133010.GA21494@hash.localnet>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Oct 11, 2009 at 09:30:10AM -0400, Bob Copeland wrote:
> On Sun, Oct 11, 2009 at 02:26:16PM +0200, Richard Zidlicky wrote:
> > thanks, compiling it right now. Not quite sure - which version of this
> > > > -       ret = ath5k_hw_reset(ah, sc->opmode, sc->curchan, true);
> > > > +       ret = ath5k_hw_reset(ah, sc->opmode, sc->curchan, chan != NULL);
> > 
> > is it supposed to be tested with?
> 
> The "chan != NULL" case.  The patch should apply against latest
> wireless-testing (but will probably work with linus-2.6).

so the results are same like before. The printk message came once only,
I will try to gather more debug info tomorrow.

It is striking that after running the not working driver the machine requires
a power-off reboot to have working ath5k again.

Richard
