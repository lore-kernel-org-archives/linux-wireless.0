Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:38018 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754779AbcGELnY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2016 07:43:24 -0400
Received: by mail-wm0-f51.google.com with SMTP id r201so148805769wme.1
        for <linux-wireless@vger.kernel.org>; Tue, 05 Jul 2016 04:43:23 -0700 (PDT)
From: Jakub Kicinski <jakub.kicinski@netronome.com>
To: kvalo@codeaurora.org, linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org, hannes@stressinduktion.org, nbd@nbd.name,
	linux-kernel@vger.kernel.org,
	Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCHv4 wl-drv-next 0/2] register-field manipulation macros
Date: Tue,  5 Jul 2016 12:42:57 +0100
Message-Id: <1467718979-20029-1-git-send-email-jakub.kicinski@netronome.com> (sfid-20160705_134423_851520_90323331)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!

This set moves to a global header file macros which I find
very useful and worth popularising.  The basic problem is
that since C bitfields are not very dependable accessing
subfields of registers becomes slightly inconvenient.
It is nice to have the necessary mask and shift operations
wrapped in a macro.  It is also nice to have that macro
compute the shift amount based on the mask automatically.

My implementation follows what Felix Fietkau has done in
mt76.  Hannes Frederic Sowa suggested more use of standard
Linux/GCC functions.  Since the RFC I've also added a 
compile-time check to validate that the value passed to
setters fits in the mask.

I attempted the use of static inlines instead of macros
but it makes GCC < 6.0 barf at the BUILD_BUG_ON()s.
I also noticed that forcing arguments to be u32 for inlines
makes the compiler use 32bit arithmetic where it could
get away with 64bit before (on 64bit machines, obviously).
That's a potential performance concern but probably not
a very practical one today.  Apart from looking "cleaner"
static inlines would have the advantage that we could #undef
the auxiliary macros at the end of the header.

v3:
Build bot caught a build failure with -Os set.  AFAICT gcc
did not handle temporary variable I put in the macro
expression too well.  I work around that by defining
__BUILD_BUG_ON_NOT_POWER_OF_2 and using it instead of
BUILD_BUG_ON(!tmp || is_power_of_2(tmp)).

Please review and advise on improvements.

If accepted I think would be best to push this through
Kalle's tree, since the only existing user is in
drivers/net/wireless/.

v4:
 - add documentation in the header.
v3:
 - don't use variables in statement expressions;
 - use __BUILD_BUG_ON_NOT_POWER_OF_2.
v2:
 - change Felix's email address.

Jakub Kicinski (2):
  add basic register-field manipulation macros
  mt7601u: use linux/bitfield.h

 drivers/net/wireless/mediatek/mt7601u/dma.h     |   2 -
 drivers/net/wireless/mediatek/mt7601u/mt7601u.h |   5 +-
 drivers/net/wireless/mediatek/mt7601u/util.h    |  77 -----------------
 include/linux/bitfield.h                        | 110 ++++++++++++++++++++++++
 include/linux/bug.h                             |   3 +
 5 files changed, 117 insertions(+), 80 deletions(-)
 delete mode 100644 drivers/net/wireless/mediatek/mt7601u/util.h
 create mode 100644 include/linux/bitfield.h

-- 
1.9.1

