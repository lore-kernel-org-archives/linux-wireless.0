Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58024 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754200Ab0IVSyP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Sep 2010 14:54:15 -0400
Received: by fxm12 with SMTP id 12so265230fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 22 Sep 2010 11:54:11 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: David Miller <davem@davemloft.net>
Subject: Re: pull request: wireless-next-2.6 2010-09-21
Date: Wed, 22 Sep 2010 20:54:05 +0200
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
References: <20100921201705.GC2448@tuxdriver.com> <201009221158.13806.chunkeey@googlemail.com> <20100922.092252.116390431.davem@davemloft.net>
In-Reply-To: <20100922.092252.116390431.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201009222054.05469.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 22 September 2010 18:22:52 David Miller wrote:
> From: Christian Lamparter <chunkeey@googlemail.com>
> Date: Wed, 22 Sep 2010 11:58:13 +0200
> 
> > On Wednesday 22 September 2010 03:36:14 David Miller wrote:
> >> From: "John W. Linville" <linville@tuxdriver.com>
> >> Date: Tue, 21 Sep 2010 16:17:05 -0400
> >> 
> >> Pulled, but I suspect the 'packed' attribute usage is wrong in
> >> ath/carl9170 and can just be deleted.
> > 
> > which __packed do you think can be removed?
> > 
> > Note:
> > The overzealous use of __packed is a result of a report from Al Viro
> > for ar9170usb: "arm will pad even between u8's".
> >
> > as decribed in http://tinyurl.com/2ww8c53 [git.kernel.org]
> 
> Then only the structure that has the "u8's" needs the __packed attribute
> not every single other structure it is included in.

Which exactly is the "every single other structure"?
All structs which are internal to the driver are not packed
(e.g.: device context, tid & sta info, tx info, etc... - carl9170.h).

Only the structs which deal with hardware (hw.h, eeprom.h, wlan.h)
or firmware (fwcmd.h, fwdesc.h & wlan.h) interface have the
__packed attribute. And there are several good reasons.

e.g.:
 * prevent gcc from aligning the elements to the architecture boundary,
   which would be fatal because it can cause the device to malfunction.

 * prevent possibly fatal unaligned memory access bugs on
   architectures that don't allow/support unaligned memory access.
   (as described in Documentation/unaligned-memory-access.txt )

 * __packed does not only affect a structs element position, but
   also prevent gcc from adding additional padding at the end.
   This is bad because it breaks BUILD_BUG_ON asserts (as reported by Al Viro)

 * consistency and future-proofing changes.
   The firmware is open source, and other people which are not familiar with
   the point above are working/adding new stuff to the code.
   Therefore the firmware descriptor (fwdesc.h), firmware command  interface
   (fwcmd.h) and the super tx/rx descriptors (wlan.h) can change _alot_. 
   So even it looks like some structs that currently don't necessarily need
   to be __packed they need it in the future.
   (no stable API nonsense!)

In my opinion __packed is necessary for these *interface definitions/API*
as long as it can't be 100% proven that the questionable structure would
not cause problems with any compiler on any platform or architecture at
any time.

But If anyone thinks: "That's all just utter rubbish, you have no idea
what you are talking about!" Then he/she is entitled to take action and
draft a new guild-line which lists valid technical(not religious!) reasons
why the use of __packed is discouraged for interface protocol definitions.

This worked before, take a look at the rants in:
volatile-considered-harmful.txt. Now check-patch.pl warns as soon
as a volatile is buried deep between the lines.

Best Regards,
	Chr 
