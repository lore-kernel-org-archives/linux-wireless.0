Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:64386 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S943647AbcJSPCD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Oct 2016 11:02:03 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Wim Van Sebroeck <wim@iguana.be>,
        Guenter Roeck <linux@roeck-us.net>
Cc: Alexander Usyskin <alexander.usyskin@intel.com>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-watchdog@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 0/5] mei: mei client bus api changes
Date: Wed, 19 Oct 2016 16:33:26 +0300
Message-Id: <1476884011-20645-1-git-send-email-tomas.winkler@intel.com> (sfid-20161019_170237_128240_8F6B1D53)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We are adding a helper module macro for removing boilerplate  
code in driver registration, and removing redundant context
argument from the event callback.

The changes go over misc, nfc, and watchdog subtrees. 
I believe it should be conflict free to merge it to the misc
tree.

Tomas Winkler (5):
  mei: bus: add  module_mei_cl_driver helper macro
  watchdog: mei_wdt: use module_mei_cl_driver macro
  nfc: mei: use module_mei_cl_driver macro
  nfc: mei_phy: get phy from the driver data
  mei: bus: remove rx callback context

 drivers/misc/mei/bus.c      |  6 ++----
 drivers/nfc/mei_phy.c       | 10 ++++++----
 drivers/nfc/microread/mei.c | 23 +----------------------
 drivers/nfc/pn544/mei.c     | 23 +----------------------
 drivers/watchdog/mei_wdt.c  | 26 +++-----------------------
 include/linux/mei_cl_bus.h  | 19 +++++++++++++++----
 6 files changed, 28 insertions(+), 79 deletions(-)

-- 
2.7.4
