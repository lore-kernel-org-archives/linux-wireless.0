Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:57895 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245Ab1D1V3n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Apr 2011 17:29:43 -0400
Date: Thu, 28 Apr 2011 18:29:58 -0300
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org
Subject: pull request: bluetooth-next-2.6 2011-04-28
Message-ID: <20110428212958.GD2302@joana> (sfid-20110428_232949_066560_3E96F756)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Some more updates to 2.6.40! A new step on the L2CAP refactor by me.
An initial support to 16 digit pin code by Waldemar Rymarkiewicz,
and finally a bunch of fixes against the BITE tester from Johan Hedberg.

Please pull! Thanks.

The following changes since commit c989bb15e95a93e20fc86783264f6298116e8651:

  cfg80211: fix regresion on reg user timeout (2011-04-26 16:14:55 -0400)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/padovan/bluetooth-next-2.6.git master

Gustavo F. Padovan (11):
      Merge master.kernel.org:/.../padovan/bluetooth-2.6
      Bluetooth: Refactor L2CAP channel allocation
      Bluetooth: Move conf_state to struct l2cap_chan
      Bluetooth: Rename l2cap_do_connect() to l2cap_chan_connect()
      Bluetooth: Move some more elements to struct l2cap_chan
      Bluetooth: Move more vars to struct l2cap_chan
      Bluetooth: Move more channel info to struct l2cap_chan
      Bluetooth: Move more vars to struct l2cap_chan
      Bluetooth: Move conn to struct l2cap_chan
      Bluetooth: Fix memory leak with L2CAP channels
      Bluetooth: Don't export l2cap_sock_ops

Johan Hedberg (14):
      Bluetooth: Add basic discovery commands to the management interface
      Bluetooth: Add discovering event to the Management interface
      Bluetooth: Add automated SSP user confirmation responses
      Bluetooth: Add variable SSP auto-accept delay support
      Bluetooth: Fix HCI_CONN_AUTH_PEND flag for all authentication requests
      Bluetooth: Add confirm_hint parameter to user confirmation requests
      Bluetooth: Fix reason code for pairing rejection
      Bluetooth: Fix logic in hci_pin_code_request_evt
      Bluetooth: Fix link key persistent storage criteria
      Bluetooth: Fix old_key_type logic for non-persistent keys
      Bluetooth: Fix connection key type updating for buggy controllers
      Bluetooth: Remove old_key_type from mgmt_ev_new_key
      Bluetooth: Add store_hint parameter to mgmt_new_key
      Bluetooth: Fix updating conn->auth_type in hci_io_capa_request_evt                             
                                                                                                     
Waldemar Rymarkiewicz (6):                                                                           
      Bluetooth: Add definitions for link key types                                                  
      Bluetooth: Don't modify sec_level if auth failed                                               
      Bluetooth: Map sec_level to link key requirements                                              
      Bluetooth: Ignore key unauthenticated for high security                                        
      Bluetooth: Respect local MITM req in io_cap reply                                              
      Bluetooth: Add secure flag for mgmt_pin_code_req                                               
                                                                                                     
 drivers/bluetooth/Kconfig        |    4 +-                                                          
 drivers/bluetooth/ath3k.c        |    3 -                                                           
 drivers/bluetooth/btmrvl_sdio.c  |  124 ++-                                                         
 drivers/bluetooth/btmrvl_sdio.h  |   68 +-                                                          
 drivers/bluetooth/hci_ath.c      |    7 +-                                                          
 drivers/bluetooth/hci_h4.c       |    7 +-                                                          
 drivers/bluetooth/hci_ldisc.c    |    6 +-                                                          
 include/net/bluetooth/hci.h      |   49 +-                                                          
 include/net/bluetooth/hci_core.h |   41 +-                                                          
 include/net/bluetooth/l2cap.h    |  177 ++--                                                        
 include/net/bluetooth/mgmt.h     |   57 ++-                                                         
 net/bluetooth/bnep/bnep.h        |  148 ++--                                                        
 net/bluetooth/bnep/core.c        |   71 +-                                                          
 net/bluetooth/bnep/sock.c        |    2 +-                                                          
 net/bluetooth/cmtp/capi.c        |    6 +-                                                          
 net/bluetooth/cmtp/cmtp.h        |   11 +-                                                          
 net/bluetooth/cmtp/core.c        |   28 +-                                                          
 net/bluetooth/cmtp/sock.c        |    2 +-                                                          
 net/bluetooth/hci_conn.c         |   78 ++-                                                         
 net/bluetooth/hci_core.c         |  158 +++-                                                        
 net/bluetooth/hci_event.c        |  262 +++++-                                                      
 net/bluetooth/hci_sysfs.c        |   71 ++-                                                         
 net/bluetooth/hidp/core.c        |   96 +-                                                          
 net/bluetooth/hidp/hidp.h        |    6 +-
 net/bluetooth/hidp/sock.c        |    7 +-
 net/bluetooth/l2cap_core.c       | 1815 ++++++++++++++++++++------------------
 net/bluetooth/l2cap_sock.c       |  288 +++---
 net/bluetooth/mgmt.c             |  609 ++++++++++++-
 net/bluetooth/rfcomm/core.c      |   21 +-
 net/bluetooth/rfcomm/sock.c      |    5 +-
 30 files changed, 2731 insertions(+), 1496 deletions(-)

-- 
Gustavo F. Padovan
http://profusion.mobi
