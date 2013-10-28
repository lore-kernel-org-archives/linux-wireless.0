Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:51922 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456Ab3J1QmT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Oct 2013 12:42:19 -0400
Received: by mail-we0-f178.google.com with SMTP id q59so6961325wes.9
        for <linux-wireless@vger.kernel.org>; Mon, 28 Oct 2013 09:42:17 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linux-wireless@vger.kernel.org
Cc: wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH v2 0/6] crda: few more updates
Date: Mon, 28 Oct 2013 17:42:00 +0100
Message-Id: <1382978526-23929-1-git-send-email-mcgrof@do-not-panic.com> (sfid-20131028_174222_344863_80C9858A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here's a second spin, after quite a bit more testing I ran
into a few small issues with the parser and library. This
has these additional fixes / enhancements:

  * Lifts the restriction on 32 rules, although the kernel
    is limited by this we don't adhere to this limit on our
    stream parser or optimizer

  * The union code got updated to address two cases that are
    invalid for unions

  * A few fixes on db2rd and optimizer on using the stream
    parser, if its NULL, bail, we weren't checking for it

  * The optimizer was not considering band differences as
    part of its key broker (when it decides it can use
    two rules for optimization), to address this we deduce
    the band and add that to the key mixing. Note that this
    will need to be updated upon new frequency band additions.
    This limits the scope of optimizations between their own
    respective bands.

I've also gone ahead and tested this with a huge fluffy
non optimized regulatory domain of 40 rules, and also with
the wireless-regdb db.txt. I'll send some optimizations
based on this for wireless-regdb.

The only patches that go modified are the stream parser
and the optimizer.

Luis R. Rodriguez (6):
  crda: relicense under copyleft-next-0.3.0
  crda: fix -pedantic gcc compilation
  crda: add regulatory domain stream parser
  crda: add regulatory domain optimizer
  crda: make ssl keys include stdint.h
  crda: make reglib a shared library

 LICENSE             |  14 +-
 Makefile            |  54 +++-
 copyleft-next-0.3.0 | 219 ++++++++++++++
 crda.c              |   4 +-
 db2rd.c             |  32 ++
 optimize.c          |  40 +++
 reglib.c            | 839 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 reglib.h            |  60 ++++
 utils/key2pub.py    |   2 +
 9 files changed, 1252 insertions(+), 12 deletions(-)
 create mode 100644 copyleft-next-0.3.0
 create mode 100644 db2rd.c
 create mode 100644 optimize.c

-- 
1.8.4.rc3

