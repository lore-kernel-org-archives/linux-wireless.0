Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:57164 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753249Ab3CJX6A (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Mar 2013 19:58:00 -0400
Date: Mon, 11 Mar 2013 00:57:30 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Linux NFC <linux-nfc@lists.01.org>,
	Linux Wireless <linux-wireless@vger.kernel.org>
Subject: [GIT] [3.9] NFC fixes
Message-ID: <20130310235730.GA27335@zurbaran> (sfid-20130311_005804_724501_E4A3C62F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

This is the first NFC pull request for 3.9 fixes

With this one we have:

- A fix for properly decreasing socket ack log.
- A timer and works cleanup upon NFC device removal.
- A monitoroing socket cleanup round from llcp_socket_release.
- A proper error report to pending sockets upon NFC device removal.

Thanks in advance for pulling them in.

The following changes since commit 930df2dfc7073c9ed2d0b47a08e47027ae83c545:

  Merge branch 'for-davem' of git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless (2013-03-06 15:33:15 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/nfc-fixes.git tags/nfc-fixes-3.9-1

for you to fetch changes up to 3bbc0ceb7ac2bf694d31362eea2c71a680e5deeb:

  NFC: llcp: Report error to pending sockets when a device is removed (2013-03-08 17:35:22 +0100)

----------------------------------------------------------------
Samuel Ortiz (4):
      NFC: llcp: Decrease socket ack log when accepting a connection
      NFC: llcp: Clean local timers and works when removing a device
      NFC: llcp: Clean raw sockets from nfc_llcp_socket_release
      NFC: llcp: Report error to pending sockets when a device is removed

 net/nfc/llcp/llcp.c |   62 +++++++++++++++++++++++++++++++++++++++++++--------
 net/nfc/llcp/sock.c |    2 ++
 2 files changed, 55 insertions(+), 9 deletions(-)

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
