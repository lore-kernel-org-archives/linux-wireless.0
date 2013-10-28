Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:39932 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755041Ab3J1BxH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Oct 2013 21:53:07 -0400
Received: by mail-we0-f177.google.com with SMTP id x55so5757737wes.8
        for <linux-wireless@vger.kernel.org>; Sun, 27 Oct 2013 18:53:06 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linux-wireless@vger.kernel.org
Cc: wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 0/6] crda: few updates and license changes
Date: Mon, 28 Oct 2013 02:52:56 +0100
Message-Id: <1382925182-7393-1-git-send-email-mcgrof@do-not-panic.com> (sfid-20131028_025311_889139_0789CFD8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here's a few updates to CRDA. This depends on the removal of
antenna gain patches I posted last week. The tools developed
in this series are designed to help folks who want to contribute
to wireless-regdb but have a regulatory database format in some
other form that is non-optimized. The stream parser helps users
get their data out into non optimized form, and provide also
optimizers.

The optimizer work by doing a union and intersections on the
set of rules of a regulatory domain. Lastly as I mentioned the
last wireless summit I'd be making a library here, making CRDA
and its other tools share code. Other tools may use the library
later but these require a bit more work and as it is right now
the db2rd and optimizer require a bit more work to be shipped
by default.

This work has all been valgrinized.

Luis R. Rodriguez (6):
  crda: relicense under copyleft-next-0.3.0
  crda: fix -pedantic gcc compilation
  crda: add regulatory domain stream parser
  crda: add regulatory domain optimizer
  crda: make ssl keys include stdint.h
  crda: make reglib a shared library

 LICENSE             |  14 +-
 Makefile            |  54 +++-
 copyleft-next-0.3.0 | 219 +++++++++++++++
 crda.c              |   4 +-
 db2rd.c             |  30 ++
 optimize.c          |  38 +++
 reglib.c            | 790 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 reglib.h            |  60 ++++
 utils/key2pub.py    |   2 +
 9 files changed, 1199 insertions(+), 12 deletions(-)
 create mode 100644 copyleft-next-0.3.0
 create mode 100644 db2rd.c
 create mode 100644 optimize.c

-- 
1.8.4.rc3

