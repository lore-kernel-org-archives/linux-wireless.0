Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:59435 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032AbYKVKhg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Nov 2008 05:37:36 -0500
Received: by ey-out-2122.google.com with SMTP id 6so531313eyi.37
        for <linux-wireless@vger.kernel.org>; Sat, 22 Nov 2008 02:37:34 -0800 (PST)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org, orinoco-devel@lists.sourceforge.net
Cc: arvidjaar@mail.ru, David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH 0/4] orinoco: clean up firmware download
Date: Sat, 22 Nov 2008 10:37:24 +0000
Message-Id: <1227350248-8917-1-git-send-email-kilroyd@googlemail.com> (sfid-20081122_113740_289289_5B770FA5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series is a refactorring of the RFC previously posted as
orinoco: Don't keep cached firmware around permanently

The recent patch to load orinoco firmware correctly on resume simply
kept the firmware in RAM for the entire time the module was loaded, and
only applied to Agere firmware.

The first two patches extend this to Symbol firmware.

The third makes the spectrum_cs driver use this functionality directly
during resume instead of resetting the card.

The final patch provides an option to use the new power management
notifiers to load the firmware prior to suspend and release it after
resume.


David Kilroy (4):
  orinoco: Separate fw caching from download
  orinoco: Cache Symbol firmware
  orinoco: Resume spectrum_cs in the same way as orinoco_cs
  orinoco: Provide option to avoid unnecessary fw caching

 drivers/net/wireless/Kconfig               |   15 +++
 drivers/net/wireless/orinoco/orinoco.c     |  156 ++++++++++++++++++++++-----
 drivers/net/wireless/orinoco/orinoco.h     |    6 +-
 drivers/net/wireless/orinoco/spectrum_cs.c |   21 ++++-
 4 files changed, 167 insertions(+), 31 deletions(-)

