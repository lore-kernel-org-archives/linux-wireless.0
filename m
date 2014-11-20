Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:16085 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756658AbaKTV1G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Nov 2014 16:27:06 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 0/4] brcm80211: minor rework
Date: Thu, 20 Nov 2014 22:26:58 +0100
Message-ID: <1416518822-29585-1-git-send-email-arend@broadcom.com> (sfid-20141120_222717_227651_0473A362)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series touches some minor stuff in both drivers. The first
change was a report from Dan Carpenter which gets rid of smatch
warning/error. In brcmsmac I extended the hardware info file
contents in debugfs. The last patch solves a problem in brcmfmac
that I came across during testing.

The series is intended for 3.19 and applies to the master branch
of the wireless-next repository.

Arend van Spriel (4):
  brcmfmac: fix static checker warning in pmklist handling
  brcmutil: add helper function to format board revision
  brcmsmac: extend hardware info shown in debugfs
  brcmfmac: correct .disconnect() callback while connecting

 drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c |  8 ++---
 drivers/net/wireless/brcm80211/brcmsmac/debug.c    | 40 +++++++++++++++-------
 drivers/net/wireless/brcm80211/brcmutil/utils.c    | 16 +++++++++
 .../net/wireless/brcm80211/include/brcmu_utils.h   |  2 ++
 4 files changed, 49 insertions(+), 17 deletions(-)

-- 
1.9.1

