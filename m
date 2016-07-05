Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55182 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168AbcGENYZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2016 09:24:25 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Jakub Kicinski <jakub.kicinski@netronome.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	hannes@stressinduktion.org, nbd@nbd.name,
	linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCHv4 wl-drv-next 0/2] register-field manipulation macros
References: <1467718979-20029-1-git-send-email-jakub.kicinski@netronome.com>
Date: Tue, 05 Jul 2016 16:24:18 +0300
In-Reply-To: <1467718979-20029-1-git-send-email-jakub.kicinski@netronome.com>
	(Jakub Kicinski's message of "Tue, 5 Jul 2016 12:42:57 +0100")
Message-ID: <87lh1g2p6l.fsf@kamboji.qca.qualcomm.com> (sfid-20160705_152442_254491_BB530410)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jakub Kicinski <jakub.kicinski@netronome.com> writes:

> This set moves to a global header file macros which I find
> very useful and worth popularising.  The basic problem is
> that since C bitfields are not very dependable accessing
> subfields of registers becomes slightly inconvenient.
> It is nice to have the necessary mask and shift operations
> wrapped in a macro.  It is also nice to have that macro
> compute the shift amount based on the mask automatically.
>
> My implementation follows what Felix Fietkau has done in
> mt76.  Hannes Frederic Sowa suggested more use of standard
> Linux/GCC functions.  Since the RFC I've also added a 
> compile-time check to validate that the value passed to
> setters fits in the mask.
>
> I attempted the use of static inlines instead of macros
> but it makes GCC < 6.0 barf at the BUILD_BUG_ON()s.
> I also noticed that forcing arguments to be u32 for inlines
> makes the compiler use 32bit arithmetic where it could
> get away with 64bit before (on 64bit machines, obviously).
> That's a potential performance concern but probably not
> a very practical one today.  Apart from looking "cleaner"
> static inlines would have the advantage that we could #undef
> the auxiliary macros at the end of the header.

This information about various compiler problems is good to have in the
commit log as the cover letter itself is not stored in the git log.

> v3:
> Build bot caught a build failure with -Os set.  AFAICT gcc
> did not handle temporary variable I put in the macro
> expression too well.  I work around that by defining
> __BUILD_BUG_ON_NOT_POWER_OF_2 and using it instead of
> BUILD_BUG_ON(!tmp || is_power_of_2(tmp)).
>
> Please review and advise on improvements.
>
> If accepted I think would be best to push this through
> Kalle's tree, since the only existing user is in
> drivers/net/wireless/.

I like it. But I feel much more comfortable to take these if I get an
ack from someone like Dave Miller or Andrew Morton (CCed).

Full patches here:

https://patchwork.kernel.org/patch/9214129/
https://patchwork.kernel.org/patch/9214135/

-- 
Kalle Valo
