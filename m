Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:62640 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757860Ab1CBDrU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2011 22:47:20 -0500
Date: Wed, 2 Mar 2011 00:47:35 -0300
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org
Subject: pull request: bluetooth-next-2.6 2011-03-01
Message-ID: <20110302034735.GA2202@joana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Here is the latest batch of Bluetooth changes, they are most changes in the
HCI Management interface both from Johan Hedberg and Szymon Janc. The rest are
just clean ups and bug fixes.

Please pull, thanks a lot!

The following changes since commit e46395a4b3d32d161d8b6d8e4a002972b1faae3e:

  mac80211: make rate control Kconfig warning depend on mac80211 (2011-03-01 13:48:22 -0500)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/padovan/bluetooth-next-2.6.git master

Anand Gadiyar (2):
      Bluetooth: fix build break on hci_sock.c
      Bluetooth: remove unnecessary call to hci_sock_cleanup

Anderson Briglia (1):
      Bluetooth: Fix LE conn creation

Gustavo F. Padovan (1):
      Bluetooth: Remove duplicated BT_INFO() from L2CAP

Johan Hedberg (8):
      Bluetooth: Make pending_add return a pointer to the added entry
      Bluetooth: Add mgmt_pair_device command
      Bluetooth: Add management support for user confirmation request
      Bluetooth: Fix mgmt_pin_code_reply command status opcode
      Bluetooth: Fix mgmt_pin_code_reply return parameters
      Bluetooth: Add mgmt_auth_failed event
      Bluetooth: Fix inititial value for remote authentication requirements
      Bluetooth: Fix unnecessary list traversal in mgmt_pending_remove

Szymon Janc (8):
      Bluetooth: Use proper command structure in remove_uuid
      Bluetooth: Move index to common header in management interface
      Bluetooth: Validate data size before accessing mgmt commands
      Bluetooth: Fix possible NULL pointer dereference in cmd_complete                         
      Bluetooth: Log all parameters in cmd_status for easier debugging                         
      Bluetooth: Remove unused code from get_connections                                       
      Bluetooth: Use variable name instead of type in sizeof()                                 
      Bluetooth: Fix some small code style issues in mgmt.c                                    
                                                                                               
Ville Tervo (1):                                                                               
      Bluetooth: Use ERR_PTR as return error from hci_connect                                  
                                                                                               
 include/net/bluetooth/hci.h      |   17 +                                                     
 include/net/bluetooth/hci_core.h |   21 +                                                     
 include/net/bluetooth/mgmt.h     |   73 ++--                                                  
 net/bluetooth/af_bluetooth.c     |    4 +-                                                    
 net/bluetooth/hci_conn.c         |    8 +-                                                    
 net/bluetooth/hci_event.c        |   69 ++++-                                                 
 net/bluetooth/hci_sock.c         |    2 +-                                                    
 net/bluetooth/l2cap_core.c       |   13 +-                                                    
 net/bluetooth/mgmt.c             |  751 +++++++++++++++++++++++++-------------                
 net/bluetooth/sco.c              |    7 +-                                                    
 10 files changed, 663 insertions(+), 302 deletions(-)                                        

-- 
Gustavo F. Padovan
http://profusion.mobi
