Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:45316
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753960AbXIWOsn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Sep 2007 10:48:43 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Ulrich Kunitz <kune@deine-taler.de>, Daniel Drake <dsd@gentoo.org>
Subject: zd1211 config operation problem
Date: Sun, 23 Sep 2007 16:48:16 +0200
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
MIME-Version: 1.0
Message-Id: <200709231648.17107.mb@bu3sch.de>
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The zd1211 driver has a bug in the ieee80211 config callback.
It currently unconditionally calls the set_channel() function,
whether the device is running or not. This causes a failed
bus access, if we set some config while the device is down.
The driver must check if the device is running before setting
any config on it (usb->initialized?).
I tried to fix this, but I failed to find the correct condition
to check for.

I'm also wondering why we only set the channel in the config
callback. Is the rest all unsupported by the device, like
setting of TX power and so on?
