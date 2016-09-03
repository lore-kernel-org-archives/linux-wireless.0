Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:32865 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753268AbcICLFh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 3 Sep 2016 07:05:37 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Jakub Kicinski <jakub.kicinski@netronome.com>
Cc: Linux Wireless List <linux-wireless@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv8 0/4] register-field manipulation macros
References: <1471625049-12643-1-git-send-email-jakub.kicinski@netronome.com>
        <1472644007-20959-1-git-send-email-jakub.kicinski@netronome.com>
Date: Sat, 03 Sep 2016 14:05:17 +0300
In-Reply-To: <1472644007-20959-1-git-send-email-jakub.kicinski@netronome.com>
        (Jakub Kicinski's message of "Wed, 31 Aug 2016 12:46:43 +0100")
Message-ID: <87y439xmz6.fsf@kamboji.qca.qualcomm.com> (sfid-20160903_130545_295901_094D5FA5)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jakub Kicinski <jakub.kicinski@netronome.com> writes:

> Small improvement suggested by Daniel Borkmann - use
> two underscore prefix.
>
> https://www.mail-archive.com/netdev@vger.kernel.org/msg125423.html
>
> -- v6 blurb:
>
> This set moves to a global header file macros which I find
> very useful and worth popularising.  The basic problem is
> that since C bitfields are not very dependable accessing
> subfields of registers becomes slightly inconvenient.
> It is nice to have the necessary mask and shift operations
> wrapped in a macro and have that macro compute shift
> at compilation time using FFS.
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
> Build bot caught a build failure with -Os set.  AFAICT gcc
> did not handle temporary variable I put in the macro
> expression too well.  I work around that by defining
> __BUILD_BUG_ON_NOT_POWER_OF_2 and using it instead of
> BUILD_BUG_ON(!tmp || is_power_of_2(tmp)).
>
> I'm planning to use those macros in another driver soon,
> Felix may also use them when upstreaming mt76 if he chooses
> to do so.
>
> IMHO if accepted it would be best to push these through
> Kalle's wireless drivers' tree, since the only existing
> user is in drivers/net/wireless/.
>
> v8:
>  - use two underscores for auxiliary macros (Daniel B).
> v7:
>  - drop the explicit type marking (u32/u64) - depend on the type
>    of the mask instead;
>  - only allow compilation time constant masks;
>  - barf at "type of register too small to ever match mask" on get;
>  - rename PUT -> PREP.
> v6:
>  - do a full rename in patch 2;
>  - CC many people.
> v5:
>  - repost.
> v4:
>  - add documentation in the header.
> v3:
>  - don't use variables in statement expressions;
>  - use __BUILD_BUG_ON_NOT_POWER_OF_2.
> v2:
>  - change Felix's email address.
>
> Jakub Kicinski (4):
>   add basic register-field manipulation macros
>   mt7601u: remove redefinition of GENMASK
>   mt7601u: remove unnecessary include
>   mt7601u: use linux/bitfield.h

I applied these now to the pending branch of my wireless-drivers-next
tree. Let's see if the kbuild bot finds any problems.

Please also CC lkml, did that now.

-- 
Kalle Valo
