Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45598 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111Ab0IOD1b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Sep 2010 23:27:31 -0400
Received: by wwd20 with SMTP id 20so605070wwd.1
        for <linux-wireless@vger.kernel.org>; Tue, 14 Sep 2010 20:27:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100915030444.GB8429@hash.localnet>
References: <AANLkTi=azJS6bn7-=Bbb--ibACaQWqv4ZGLMUpfxynm7@mail.gmail.com>
 <AANLkTi==HEkmY4TR=r+4Ymk_55fBORmRgF+SFGQzK750@mail.gmail.com>
 <AANLkTim=hRJxQW+UomOQygmLjrePym=Cn-o7RzKqWc+D@mail.gmail.com>
 <201009150958.14525.br1@einfach.org> <AANLkTinZmv-o-tbR=2kso8jqZPTMdG=eKFCbM9DJ41d2@mail.gmail.com>
 <20100915030444.GB8429@hash.localnet>
From: Jonathan Guerin <jonathan@guerin.id.au>
Date: Wed, 15 Sep 2010 13:20:15 +1000
Message-ID: <AANLkTi=EhtU-ahDRdP+qqQ5hYcVtMmw_=RiYc95fDAU4@mail.gmail.com>
Subject: Re: [ath5k-devel] [support] ath5k contention windows
To: Bob Copeland <me@bobcopeland.com>,
	Nick Kossifidis <mickflemm@gmail.com>
Cc: Bruno Randolf <br1@einfach.org>,
	ath5k-devel <ath5k-devel@lists.ath5k.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 15, 2010 at 1:04 PM, Bob Copeland <me@bobcopeland.com> wrote:
>
> Just a wild guess, driver may include a small fudge factor to account
> for time spent in qcu.  At one point I compared all of the initvals
> to those from the HAL; we're at least bug-compatible with it if there
> are errors here.

But, the SIFS and SLOT_TIME values should already account for those times?

>From the spec (Section 9.2.10 DCF timing relations):
aSIFSTime is:	aRxRFDelay + aRxPLCPDelay + aMACProcessingDelay +
aRxTxTurnaroundTime.
aSlotTime is:	aCCATime + aRxTxTurnaroundTime + aAirPropagationTime +
aMACProcessingDelay.

>
>> By the way, I may be completely wrong about some of these things, I'm
>> just going off the understanding I have regarding the register values.
>
> Well mostly no one has looked at them, so you may well have found
> some problems.
>
> FWIW if you use coverage classes (not default), we appear to use the
> right values there.

I'm going to plead ignorance here and say that I'm not sure what you
mean by coverage classes...

>
> --
> Bob Copeland %% www.bobcopeland.com
>
> _______________________________________________
> ath5k-devel mailing list
> ath5k-devel@lists.ath5k.org
> https://lists.ath5k.org/mailman/listinfo/ath5k-devel
>
