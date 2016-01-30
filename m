Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from glaubenleben.de ([85.214.105.140]:53789 "EHLO glaubenleben.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751977AbcA3RCR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jan 2016 12:02:17 -0500
From: Andreas Kemnade <andreas@kemnade.info>
To: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, hns@goldelico.com
Subject: [PATCH v3 0/6] libertas: ieee80211 powersave mode 
Date: Sat, 30 Jan 2016 18:01:50 +0100
Message-Id: <1454173316-13444-1-git-send-email-andreas@kemnade.info> (sfid-20160130_180440_870440_BAA97CB5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series makes IEEE 80211 powersave mode work again so
that power usage is dramatically reduced when the device is connected.
It does not include other power saving methods which are working
when the device is not connected (like enabling
deep sleep modus)

Tested on GTA04 which includes a
W2CBW003 chip (Marvel 8686) with sdio interface

Changes in v3:
s/wireless:libertas/libertas/
s|net/wireless/libertas|net/wireless/marvell/libertas|

Changes in v2:
improved some commit messages, order changed,
former 6/6 was too late it needs to be before
implementing the cfg80211  power saving interface
to have it git-bisectable. 
moving the former 3/6 to the end fixes
all bisect problems

[PATCH v3 1/6] libertas: fix pointer bugs for PS_MODE
[PATCH v3 2/6] libertas: check whether bus can do more than
[PATCH v3 3/6] libertas: do not confirm sleep if commands
[PATCH v3 4/6] libertas: go back to ps mode without commands
[PATCH v3 5/6] libertas: fix ps-mode related removal
[PATCH v3 6/6] libertas: add an cfg80211 interface for
