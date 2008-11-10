Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:22027 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408AbYKJSma (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Nov 2008 13:42:30 -0500
Received: by ey-out-2122.google.com with SMTP id 6so997726eyi.37
        for <linux-wireless@vger.kernel.org>; Mon, 10 Nov 2008 10:42:28 -0800 (PST)
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH 1/2] rt2x00: Cleanup indirect register access
Date: Mon, 10 Nov 2008 19:41:40 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200811101941.40391.IvDoorn@gmail.com> (sfid-20081110_194235_406674_D495F347)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All code which accessed indirect registers was similar
in respect to the for-loop, the given timeout, etc.
Move it into a seperate function, which for PCI drivers
can be moved into rt2x00pci.

This allows us to cleanup the cleanup the code further
by removing the goto statementsand making the codepath
look a bit nicer.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
http://kernel.org/pub/linux/kernel/people/ivd/patches/0001-rt2x00-Cleanup-indirect-register-access.patch
