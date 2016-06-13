Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42274 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423429AbcFMOCk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jun 2016 10:02:40 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Jakub Kicinski <jakub.kicinski@netronome.com>
Cc: netdev@vger.kernel.org, hannes@stressinduktion.org, nbd@nbd.name,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/2] register-field manipulation macros
References: <1465824594-29662-1-git-send-email-jakub.kicinski@netronome.com>
Date: Mon, 13 Jun 2016 17:02:30 +0300
In-Reply-To: <1465824594-29662-1-git-send-email-jakub.kicinski@netronome.com>
	(Jakub Kicinski's message of "Mon, 13 Jun 2016 14:29:52 +0100")
Message-ID: <87bn35chl5.fsf@kamboji.qca.qualcomm.com> (sfid-20160613_160258_885444_C2DE83D0)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jakub Kicinski <jakub.kicinski@netronome.com> writes:

> Hi!
>
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
>
> Please review and advise on improvements.
>
> If accepted I think would be best to push this through
> Kalle's tree, since the only existing user is in
> drivers/net/wireless/.
>
> Jakub Kicinski (2):
>   add basic register-field manipulation macros
>   mt7601u: use linux/bitfield.h

I guess you forgot to CC linux-wireless, adding it now, and hence I
don't see these in my patchwork either. So better to resend.

-- 
Kalle Valo
