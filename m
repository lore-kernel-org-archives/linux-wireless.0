Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40174 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751964Ab0G0RvF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jul 2010 13:51:05 -0400
Subject: [wt PATCH 0/16] libertas: finish conversion to direct command
 architecture
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Jul 2010 12:52:37 -0700
Message-ID: <1280260357.19686.13.camel@dcbw.foobar.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series finishes conversion of all firmware commands to direct
commands instead of using the indirect (and I'd argue less clear) model
that the original vendor driver used.  This was the last barrier to
scale before we can begin cleaning up the command submission structure
to be less convoluted and more reliable.  It's a net code loss too which
makes many kittens and puppies happy.

Please apply to wireless-testing.  Note that wireless-testing is
somewhat broken as a result of the cfg80211 patches, but this series
should make that easier to fix up.

Dan Williams (16):
  libertas: clean up MONITOR_MODE command
  libertas: clean up RSSI command
  libertas: convert 11D_DOMAIN_INFO to a direct command
  libertas: remove unused indirect TPC_CFG command leftovers
  libertas: remove unused Automatic Frequency Control command
  libertas: remove Beacon Control
  libertas: convert LED_GPIO_CTRL to a direct command
  libertas: convert register access to direct commands
  libertas: convert Mesh Blinding Table access to a direct command
  libertas: convert CMD_FWT_ACCESS to a direct command
  libertas: remove unused indirect command response handler
  libertas: convert PS_MODE to a direct command
  libertas: convert DEEP_SLEEP timer to a direct command
  libertas: kill unused lbs_prepare_and_send_command()
  libertas: rename lbs_get_cmd_ctrl_node() to lbs_get_free_cmd_node()
  libertas: remove unused cmd_pending waitq

 drivers/net/wireless/libertas/cfg.c     |  197 +--------
 drivers/net/wireless/libertas/cfg.h     |    6 -
 drivers/net/wireless/libertas/cmd.c     |  718 +++++++++++++------------------
 drivers/net/wireless/libertas/cmd.h     |   25 +-
 drivers/net/wireless/libertas/cmdresp.c |  179 +--------
 drivers/net/wireless/libertas/debugfs.c |   67 +---
 drivers/net/wireless/libertas/decl.h    |    5 -
 drivers/net/wireless/libertas/defs.h    |   18 -
 drivers/net/wireless/libertas/dev.h     |    6 -
 drivers/net/wireless/libertas/host.h    |  142 +++----
 drivers/net/wireless/libertas/if_usb.c  |    4 +-
 drivers/net/wireless/libertas/main.c    |   33 +-
 drivers/net/wireless/libertas/mesh.c    |  216 ++++++++--
 drivers/net/wireless/libertas/mesh.h    |   14 +-
 14 files changed, 613 insertions(+), 1017 deletions(-)


