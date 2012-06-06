Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:44354 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751652Ab2FFKGc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 06:06:32 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	linux-nfc@lists.01.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 00/29] NFC updates for 3.6 
Date: Wed,  6 Jun 2012 12:16:17 +0200
Message-Id: <1338977806-30279-1-git-send-email-sameo@linux.intel.com> (sfid-20120606_120636_301736_20EB2755)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

This is the first NFC patchset for 3.6. With this one we have:

- Peer to peer target mode support. Peer devices can now detect and activate
  us as targets, not only as initiators.
- An LLCP socket handling code simplification. It's simpler and race free now.
- LLCP fixes. Attending the NFC plugfest helped fixed a few LLCP bugs. 
- At the NFC plugfest I also found some issues with the pn533 radio and
  digital settings. This should be improved now.
- The pn533 also gets a few improvements, like a semaphore to mutex conversion
  and a proper polling loop implementation (alternating between target and
  initiator modes).

You can either apply those patches manually, or pull it from here:

git://git.kernel.org/pub/scm/linux/kernel/git/sameo/nfc-3.0.git tags/nfc-next-3.6-1

Thanks in advance for merging this code.

Samuel Ortiz (29):
  NFC: Take a reference on the LLCP local pointer when creating a
    socket
  NFC: Socket linked list
  NFC: Move LLCP receiver window value to socket structure
  NFC: Move LLCP MIU extension value to socket structure
  NFC: LLCP's MIUX is 10 bytes long, not 7
  NFC: Export LLCP general bytes getter
  NFC: Add target mode protocols to the polling loop startup routine
  NFC: Implement pn533 target mode polling loop
  NFC: Add target mode activation netlink event
  NFC: Set the NFC device RF mode appropriately
  NFC: Introduce target mode tx ops
  NFC: Introduce target mode rx data callback
  NFC: Implement the pn533 target mode data fetching routine
  NFC: Implement the pn533 target mode Tx op
  NFC: Don't hold a NULL connecting LLCP socket lock
  NFC: Call the DEP link down ops even when in target mode
  NFC: Reset poll mod list when stopping pn533 poll
  NFC: Unregister device if pn533 initial configuration fails
  NFC: Configure pn533 RF timings
  NFC: Add passive initiator data for pn533
  NFC: Add type A and type F parameters for pn533 target mode
  NFC: Implement pn533 polling loop
  NFC: Requeue lost LLCP frames
  NFC: Send a receiver ready frame only to reply to an I frame
  NFC: Switch to Initiator mode when getting NFC_ATTR_PROTOCOLS
  NFC: Destroy LLCP timout workqueue when releasing the link
  NFC: Set the proper baud rate when trying to activate pn533 targets
  NFC: Convert pn533 from semaphore to mutex
  NFC: Monitor pn533 target mode

 drivers/nfc/pn533.c     |  662 ++++++++++++++++++++++++++++++++++++++---------
 drivers/nfc/pn544_hci.c |   10 +-
 include/linux/nfc.h     |   12 +
 include/net/nfc/hci.h   |    3 +-
 include/net/nfc/nfc.h   |   14 +-
 include/net/nfc/shdlc.h |    3 +-
 net/nfc/core.c          |  119 +++++++---
 net/nfc/hci/core.c      |   13 +-
 net/nfc/hci/shdlc.c     |    6 +-
 net/nfc/llcp/commands.c |   54 +++-
 net/nfc/llcp/llcp.c     |  421 ++++++++++++++++++------------
 net/nfc/llcp/llcp.h     |   26 ++-
 net/nfc/llcp/sock.c     |   47 ++--
 net/nfc/nci/core.c      |   15 +-
 net/nfc/netlink.c       |   81 ++++++-
 net/nfc/nfc.h           |   12 +-
 16 files changed, 1106 insertions(+), 392 deletions(-)

-- 
1.7.9.1

