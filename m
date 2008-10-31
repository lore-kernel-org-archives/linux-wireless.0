Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:19697 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101AbYJaBPs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 21:15:48 -0400
Received: by ey-out-2122.google.com with SMTP id 6so363356eyi.37
        for <linux-wireless@vger.kernel.org>; Thu, 30 Oct 2008 18:15:46 -0700 (PDT)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org, orinoco-devel@lists.sourceforge.net
Cc: arvidjaar@mail.ru, linux-pm@lists.linux-foundation.org,
	David Kilroy <kilroyd@googlemail.com>
Subject: [RFC PATCH 0/2] orinoco: Don't keep cached firmware around permanently
Date: Fri, 31 Oct 2008 01:15:41 +0000
Message-Id: <1225415743-28209-1-git-send-email-kilroyd@googlemail.com> (sfid-20081031_021553_096622_24ABDEBB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The recent patch to load orinoco firmware correctly on resume simply
kept the firmware in RAM for the entire time the module was loaded, and
only applied to Agere firmware.

The first patch uses the new power management notifiers to load and
release the firmware prior to suspend and after resume (for both Agere
and Symbol). I'm not an expert on where suspend/resume is headed, so I'd
appreciate any advice from linux-pm on whether this is the preferred way
to do things.

The second patch makes the spectrum_cs driver actually invoke this
functionality during resume.

David Kilroy (2):
  orinoco: Use PM notifier to cache firmware for use during resume
  orinoco: Resume spectrum_cs in the same way as orinoco_cs

 drivers/net/wireless/orinoco.c     |  140 ++++++++++++++++++++++++++++--------
 drivers/net/wireless/orinoco.h     |    8 ++-
 drivers/net/wireless/spectrum_cs.c |   21 +++++-
 3 files changed, 135 insertions(+), 34 deletions(-)

