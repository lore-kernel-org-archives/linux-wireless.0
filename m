Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34699 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220Ab0J3DOt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Oct 2010 23:14:49 -0400
Date: Sat, 30 Oct 2010 04:15:03 +0100
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: linville@tuxdriver.com
Cc: linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: pull request: bluetooth-2.6 2010-10-30
Message-ID: <20101030031503.GB24188@vigoh>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

The following batch contains some bugfixes for 2.6.37. A fix for unaligned
access in L2CAP, a Kconfig error, and two fixes related to security of
the Bluetooth links. There is also a one line patch from Matthew Garret,
that enables USB autosuspend for btusb module, which shall be completely
safe. Please pull, thanks.


The following changes since commit c1758012971e0410790b2bc96a77e26d7b286593:

  igb: Fix unused variable warning. (2010-10-27 19:43:55 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/padovan/bluetooth-2.6.git master

Gustavo F. Padovan (1):
      Bluetooth: fix endianness conversion in L2CAP

Johan Hedberg (1):
      Bluetooth: Fix non-SSP auth request for HIGH security level sockets

Luiz Augusto von Dentz (1):
      Bluetooth: fix not setting security level when creating a rfcomm session

Matthew Garrett (1):
      Bluetooth: Enable USB autosuspend by default on btusb

Randy Dunlap (1):
      Bluetooth: fix hidp kconfig dependency warning

steven miao (1):
      bluetooth: fix unaligned access to l2cap conf data

 drivers/bluetooth/btusb.c   |    2 ++
 net/bluetooth/hci_event.c   |    6 ++++++
 net/bluetooth/hidp/Kconfig  |    2 +-
 net/bluetooth/l2cap.c       |    8 ++++----
 net/bluetooth/rfcomm/core.c |   13 ++++++++++---
 5 files changed, 23 insertions(+), 8 deletions(-)

-- 
Gustavo F. Padovan
ProFUSION embedded systems - http://profusion.mobi
