Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f176.google.com ([209.85.211.176]:47172 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838AbZJKMce (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Oct 2009 08:32:34 -0400
Received: by ywh6 with SMTP id 6so7458032ywh.4
        for <linux-wireless@vger.kernel.org>; Sun, 11 Oct 2009 05:31:58 -0700 (PDT)
Date: Sun, 11 Oct 2009 14:26:16 +0200
From: Richard Zidlicky <rz@linux-m68k.org>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: 2.6.31.[12] ath5k regression
Message-ID: <20091011122616.GA27105@linux-m68k.org>
References: <20090621134954.GA31505@linux-m68k.org> <20090621180447.GA29469@hash.localnet> <20090623174616.GA3914@linux-m68k.org> <20090623202541.GA3635@hash.localnet> <20090625083636.GA6323@linux-m68k.org> <20090705123105.GE2132@hash.localnet> <20091009143922.GA7848@linux-m68k.org> <20091010125824.GA18841@hash.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20091010125824.GA18841@hash.localnet>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Oct 10, 2009 at 08:58:24AM -0400, Bob Copeland wrote:
> On Fri, Oct 09, 2009 at 04:39:22PM +0200, Richard Zidlicky wrote:
> > -       ret = ath5k_hw_reset(ah, sc->opmode, sc->curchan, true);
> > +       ret = ath5k_hw_reset(ah, sc->opmode, sc->curchan, chan != NULL);
> >         if (ret) {
> >                 ATH5K_ERR(sc, "can't reset hardware (%d)\n", ret);
> >                 goto err;
> 
> So, this change effectively just ensures we now program the pcu registers
> at startup (every other time chan should not be null).  So my guess is
> programming the pcu actually causes some problem.  Can you try this patch
> instead?

thanks, compiling it right now. Not quite sure - which version of this
> > -       ret = ath5k_hw_reset(ah, sc->opmode, sc->curchan, true);
> > +       ret = ath5k_hw_reset(ah, sc->opmode, sc->curchan, chan != NULL);

is it supposed to be tested with?

Richard
