Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:37304 "EHLO
	mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932353AbcHPPTF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Aug 2016 11:19:05 -0400
Received: by mail-wm0-f45.google.com with SMTP id i5so175008503wmg.0
        for <linux-wireless@vger.kernel.org>; Tue, 16 Aug 2016 08:18:54 -0700 (PDT)
From: Jakub Kicinski <jakub.kicinski@netronome.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
	gregkh@linuxfoundation.org, davem@davemloft.net,
	kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	dinan.gunawardena@netronome.com,
	Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCHv6 0/2] register-field manipulation macros
Date: Tue, 16 Aug 2016 16:18:22 +0100
Message-Id: <1471360704-10507-1-git-send-email-jakub.kicinski@netronome.com> (sfid-20160816_171927_721651_89913CD2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!

This set moves to a global header file macros which I find
very useful and worth popularising.  The basic problem is
that since C bitfields are not very dependable accessing
subfields of registers becomes slightly inconvenient.
It is nice to have the necessary mask and shift operations
wrapped in a macro and have that macro compute shift
at compilation time using FFS.

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

Build bot caught a build failure with -Os set.  AFAICT gcc
did not handle temporary variable I put in the macro
expression too well.  I work around that by defining
__BUILD_BUG_ON_NOT_POWER_OF_2 and using it instead of
BUILD_BUG_ON(!tmp || is_power_of_2(tmp)).

I'm planning to use those macros in another driver soon,
Felix may also use them when upstreaming mt76 if he chooses
to do so.

IMHO if accepted it would be best to push these through
Kalle's wireless drivers' tree, since the only existing
user is in drivers/net/wireless/.

As lowly device driver developers we would greatly
appreciate an Ack or a nod from the experts.

v6:
Do a full rename in patch 2.  CC many people.

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

 drivers/net/wireless/mediatek/mt7601u/dma.c     |   2 +-
 drivers/net/wireless/mediatek/mt7601u/dma.h     |  10 +--
 drivers/net/wireless/mediatek/mt7601u/eeprom.c  |  12 +--
 drivers/net/wireless/mediatek/mt7601u/init.c    |   9 +-
 drivers/net/wireless/mediatek/mt7601u/mac.c     |  38 ++++-----
 drivers/net/wireless/mediatek/mt7601u/mcu.c     |  18 ++--
 drivers/net/wireless/mediatek/mt7601u/mt7601u.h |   4 +-
 drivers/net/wireless/mediatek/mt7601u/phy.c     |  36 ++++----
 drivers/net/wireless/mediatek/mt7601u/tx.c      |  16 ++--
 drivers/net/wireless/mediatek/mt7601u/util.h    |  77 -----------------
 include/linux/bitfield.h                        | 109 ++++++++++++++++++++++++
 include/linux/bug.h                             |   3 +
 12 files changed, 184 insertions(+), 150 deletions(-)
 delete mode 100644 drivers/net/wireless/mediatek/mt7601u/util.h
 create mode 100644 include/linux/bitfield.h

-- 
1.9.1
