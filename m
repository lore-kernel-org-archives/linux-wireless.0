Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:56434 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912Ab1FHTqn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jun 2011 15:46:43 -0400
Date: Wed, 8 Jun 2011 16:46:58 -0300
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org
Subject: pull request: bluetooth-2.6 2011-06-08
Message-ID: <20110608194658.GD13036@joana> (sfid-20110608_214648_566575_C74C1A9C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

First round of fixed for 3.0! There are here a regression fix for 1.1 and
earlier devices and a fix in the shutdown of SCO sockets.  Other 3 patches are
warning shut up. And one byte leak to userspace fix.

Please pull, thanks!


The following changes since commit 51e65257142a87fe46a1ce5c35c86c5baf012614:

  iwlegacy: fix channel switch locking (2011-06-08 14:19:05 -0400)

are available in the git repository at:
  master.kernel.org:/pub/scm/linux/kernel/git/padovan/bluetooth-2.6.git master

David Miller (2):
      Bluetooth: Do not ignore errors returned from strict_strtol()
      Bluetooth: Kill set but unused variable 'cmd' in cmtp_recv_capimsg()

Filip Palian (1):
      Bluetooth: l2cap and rfcomm: fix 1 byte infoleak to userspace.

Luiz Augusto von Dentz (1):
      Bluetooth: fix shutdown on SCO sockets

Stephen Boyd (1):
      Bluetooth: Silence DEBUG_STRICT_USER_COPY_CHECKS=y warning

Ville Tervo (1):
      Bluetooth: Do not send SET_EVENT_MASK for 1.1 and earlier devices

 drivers/bluetooth/btmrvl_debugfs.c |   12 ++++++++++++
 net/bluetooth/cmtp/capi.c          |    3 +--
 net/bluetooth/hci_event.c          |   18 ++++++++++--------
 net/bluetooth/l2cap_sock.c         |    1 +
 net/bluetooth/rfcomm/sock.c        |    4 +++-
 net/bluetooth/sco.c                |   13 ++++++++++++-
 6 files changed, 39 insertions(+), 12 deletions(-)


	Gustavo 
