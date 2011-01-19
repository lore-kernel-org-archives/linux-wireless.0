Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:58539 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753876Ab1AST1g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jan 2011 14:27:36 -0500
Date: Wed, 19 Jan 2011 17:27:40 -0200
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org
Subject: pull request: bluetooth-2.6 2011-01-19
Message-ID: <20110119192739.GF11083@joana>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Here is the first set of Bluetooth fixes for 2.6.38. It includes a patch from
Alexander Holler to reduce memory usage by the ath3k bluetooth driver. A
misusu of logical operation in L2CAP by David Sterba. There is also a fix to a
RFCOMM crash by Lukáš Turek.

Last we have six patches from Johan Hedberg, the first fix a leak in the
HCI blacklist feature. The other 5 patches, are fixes created against the BITE
tester (used in the Bluetooth qualification process). All of them are very
simple. Worth to note that one of them is a revert and "Bluetooth: Create a
unified auth_type evaluation function" is a very simple refactoring. These
patches makes 2.6.38 ready for the Bluetooth qualification process.

Please merge, or let me know any doubts or problems you find. Thanks.


The following changes since commit 38d59392b29437af3a702209b6a5196ef01f79a8:

  iwlwifi: fix valid chain reading from EEPROM (2011-01-18 15:10:31 -0500)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/padovan/bluetooth-2.6.git master

Alexander Holler (1):
      Bluetooth: ath3k: reduce memory usage

David Sterba (1):
      Bluetooth: l2cap: fix misuse of logical operation in place of bitop

Johan Hedberg (6):
      Bluetooth: Fix leaking blacklist when unregistering a hci device
      Revert "Bluetooth: Update sec_level/auth_type for already existing connections"
      Bluetooth: Fix MITM protection requirement preservation
      Bluetooth: Create a unified auth_type evaluation function
      Bluetooth: Fix authentication request for L2CAP raw sockets
      Bluetooth: Fix race condition with conn->sec_level

Lukáš Turek (1):
      Bluetooth: Never deallocate a session when some DLC points to it

 drivers/bluetooth/ath3k.c        |   75 +++++++++-------------------------
 include/net/bluetooth/hci_core.h |    1 +
 net/bluetooth/hci_conn.c         |   16 ++++---
 net/bluetooth/hci_core.c         |    4 ++
 net/bluetooth/hci_event.c        |    9 ++--
 net/bluetooth/l2cap.c            |   84 ++++++++++++++-----------------------
 net/bluetooth/rfcomm/core.c      |    3 +-
 7 files changed, 73 insertions(+), 119 deletions(-)

-- 
Gustavo F. Padovan
http://profusion.mobi
