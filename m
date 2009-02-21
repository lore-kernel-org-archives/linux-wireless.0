Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f167.google.com ([209.85.220.167]:43588 "EHLO
	mail-fx0-f167.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828AbZBURBH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Feb 2009 12:01:07 -0500
Received: by fxm11 with SMTP id 11so682132fxm.13
        for <linux-wireless@vger.kernel.org>; Sat, 21 Feb 2009 09:01:05 -0800 (PST)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org, orinoco-devel@lists.sourceforge.net
Cc: David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH v2 0/2] orinoco: improve robustness of firmware load
Date: Sat, 21 Feb 2009 16:52:52 +0000
Message-Id: <1235235174-8106-1-git-send-email-kilroyd@googlemail.com> (sfid-20090221_180121_003928_F971C438)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We don't currently do any verification of the firmware that we attempt
to load, and it is possible to cause a kernel oops. For example, see
<http://marc.info/?l=orinoco-users&m=123411762524637>

This series introduces a few nominal checks to reject files which are
incorrectly formatted, and then makes sure that we do not attempt to
read data outside the firmware.

It is still possible to load a duff firmware. However it shouldn't be
possible to cause any permanent damage. Hopefully it can't oops either.

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
David Kilroy (2):
  orinoco: validate firmware header
  orinoco: prevent accessing memory outside the firmware image

 drivers/net/wireless/orinoco/fw.c         |   49 +++++++++++++--
 drivers/net/wireless/orinoco/hermes_dld.c |   99 +++++++++++++++--------------
 drivers/net/wireless/orinoco/hermes_dld.h |   12 +++-
 3 files changed, 104 insertions(+), 56 deletions(-)

