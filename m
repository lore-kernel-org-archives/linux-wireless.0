Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:46682 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757002Ab0KVSPA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Nov 2010 13:15:00 -0500
Date: Mon, 22 Nov 2010 16:14:11 -0200
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org
Subject: pull request: bluetooth-2.6 2010-11-22
Message-ID: <20101122181411.GD23109@vigoh>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Following batch is intended to 2.6.37, it includes a very trivial return
err fix from myself and an remote name request fix from Johan Hedberg.
This fix move the remote name request (during the connection creation
process) to the kernelspace. In addition we have removed this operation
from BlueZ in userspace. Quoting part of Johan's patch which already
explain the change:

   "So far userspace has been responsible for this extra name request but
    tighter control is needed in order not to flood Bluetooth controllers
    with two many commands during connection creation. It has been shown
    that some controllers simply fail to function correctly if they get too
    many (almost) simultaneous commands during connection creation. The
    simplest way to acheive better control of these commands is to move
    their sending completely to the kernel side."

As side effect, we have a clean up patch in preparation to this fix.

Please pull, or let me know any problems you find here. Thanks.


The following changes since commit 3bf30b56c4f0a1c4fae34050b7db4527c92891e8:

  ath9k_htc: Avoid setting QoS control for non-QoS frames (2010-11-18 13:17:47 -0500)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/padovan/bluetooth-2.6.git master

Gustavo F. Padovan (1):
      Bluetooth: Fix not returning proper error in SCO

Johan Hedberg (3):
      Bluetooth: Simplify remote features callback function logic
      Bluetooth: Create a unified authentication request function
      Bluetooth: Automate remote name requests

 net/bluetooth/hci_event.c |  153 ++++++++++++++++++++++++++++++++-------------
 net/bluetooth/sco.c       |    6 +-
 2 files changed, 112 insertions(+), 47 deletions(-)

-- 
Gustavo F. Padovan
http://profusion.mobi
