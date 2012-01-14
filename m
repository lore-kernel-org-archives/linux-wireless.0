Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:60671 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756616Ab2ANUTQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Jan 2012 15:19:16 -0500
Message-ID: <4F11E33F.1000502@lwfinger.net> (sfid-20120114_211937_732616_9CADDA86)
Date: Sat, 14 Jan 2012 14:19:11 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: John W Linville <linville@tuxdriver.com>
CC: chaoming_li@realsil.com.cn, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH V2] rtl8192cu: Fix WARNING on suspend/resume
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

Please drop the patch with this subject. I think I can do a better job than this.

Larry

Commit message:

=============================================
A recent LKML thread 
(http://lkml.indiana.edu/hypermail/linux/kernel/1112.3/00965.html)
discusses warnings that occur during a suspend/resume cycle. The driver
attempts to read the firmware file before userspace is ready, leading to the
following warning:

WARNING: at drivers/base/firmware_class.c:537 _request_firmware+0x3f6/0x420()

For rtl8192cu, the problem is fixed by storing the firmware in a global buffer
rather than one allocated per device. The usage count is increased when
suspending and decreased when resuming. This way, the firmware is retained
through a suspend/resume cycle, and does not have to be reread.

This patch should fix the bug reported in
https://bugzilla.redhat.com/show_bug.cgi?id=771002.

Note: This patch also touches rtl8192ce as the "firmware" loaded message
is now printed in the wrong place.

Reported-by: Mohammed Arafa <bugzilla@in-egypt.net>
Reported-by: Dave Jones <davej@redhat.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Stable <stable@vger.kernel.org>
---

V2 - revised to avoid warning noted by Daniel Halperin.
---


