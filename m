Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45642 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754227Ab2GEIZB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jul 2012 04:25:01 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1SmhMy-0002Zl-H0
	for linux-wireless@vger.kernel.org; Thu, 05 Jul 2012 10:25:00 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: pull-request: iwlwifi-next 2012-07-05
Date: Thu,  5 Jul 2012 10:24:46 +0200
Message-Id: <1341476695-6889-1-git-send-email-johannes@sipsolutions.net> (sfid-20120705_102514_567239_CCD8EEFE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

It's been a while since my last pull request, and even though
we haven't accumulated many patches I thought I'd send you
some more. :-)

I've included disabling watchdog queues by default, at least
while we figure out why they sometimes stall for longer than
the watchdog, only to recover if it's disabled. Also included
is a fix from Richard for rejecting debugfs access early when
the device isn't running. To top it off, some small fixes and
refactorings from Emmanuel and myself.

johannes

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

The following changes since commit e75dac921d88ac1fa1ad08686ab242556f8b888b:

  iwlwifi: limit mac_change_interface to BSS context (2012-06-21 10:01:43 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git for-john

for you to fetch changes up to 0ff1bd35f5aece42879b04cbfe6b4040cf50a697:

  iwlwifi: disallow log_event access if interface down (2012-07-03 14:03:26 +0200)

- ----------------------------------------------------------------
Emmanuel Grumbach (2):
      iwlwifi: configure the queues from the op_mode
      iwlwifi: disable the watchdog for queues by default

Johannes Berg (6):
      iwlwifi: bump trace message limit
      iwlwifi: use __get_str in tracing
      iwlwifi: limit dwell time more strictly
      iwlwifi: add trailing newline to some messages
      iwlwifi: fix debug message level
      iwlwifi: remove unneeded NULL check

Richard A. Griffiths (1):
      iwlwifi: disallow log_event access if interface down

 drivers/net/wireless/iwlwifi/dvm/commands.h  |   40 +++++++++++++++++-
 drivers/net/wireless/iwlwifi/dvm/debugfs.c   |    6 ++-
 drivers/net/wireless/iwlwifi/dvm/dev.h       |   16 --------
 drivers/net/wireless/iwlwifi/dvm/main.c      |   56 +-------------------------
 drivers/net/wireless/iwlwifi/dvm/scan.c      |   37 ++++++++++++-----
 drivers/net/wireless/iwlwifi/dvm/ucode.c     |   37 +++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-debug.c     |    5 ++-
 drivers/net/wireless/iwlwifi/iwl-devtrace.h  |    4 +-
 drivers/net/wireless/iwlwifi/iwl-drv.c       |    1 +
 drivers/net/wireless/iwlwifi/iwl-trans.h     |   27 ++++++++-----
 drivers/net/wireless/iwlwifi/pcie/internal.h |    3 +-
 drivers/net/wireless/iwlwifi/pcie/rx.c       |    3 --
 drivers/net/wireless/iwlwifi/pcie/trans.c    |   36 ++++++-----------
 13 files changed, 145 insertions(+), 126 deletions(-)
-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJP9U7uAAoJEDBSmw7B7bqrrQAP/i8jduHKaRbj5STN+9G6835q
akQiY1L9vW98Ry217c+a7GwxzPIxyZ8xftQwITgxQOVMYAu60gRf5bA2EVwgNgJg
U8IaXyP7vWbiSEzaLXdOIiLmJUcDuSUXj3vDzKXMfl2mil/6g9fPj3ELzZ4hO+ca
fH2Ox4QRwhvWYTj9bQWA666yUQurRCobeNgPxiCt6dfdE7Vjz7C+PoO5Hua/HtSX
o6HDUM24gdC27miTbVBeieGM2XaMhth9uOSMTeyEscaQN/5tZTuyS2pdesxCOPKV
dkjLYJTeoz9NAnCPGob8UBQ9sPSoZzcTNBD1xZZgijnoGHHoEh4M+nbB2xp8z/7e
RlTRw4SwL/0qdOT7zB/By2aAacnSBL6kKlqbRs+5B8dkfLdsz1PhNr3buAqy+DZ6
NHkESrTQsZv0oSmMJ75N/C8LfUo0aK2onfIZTeTagQHDCSNu/WIqzIWkAy+hCe4L
ut+I1qLZWIOQLx4dlbzXvbh4uCH5cWTrqPva3HUQja8+bniyY9qYd3BZ+/pU+4OI
dcp8KiuysnpfD6y4KXRsehvAID7SLOlk+z7Ut0mCgODDtqfbZSSjLHHp+c1JGq5E
wvdKpImZVbw8VzHJ96saKkAIszQ77Qttog4SAaJVKpWXdVQMWmd8oI39cPEoyJID
Q/XpOZH5yUfqHRKzAq5z
=6lHU
-----END PGP SIGNATURE-----


johannes

