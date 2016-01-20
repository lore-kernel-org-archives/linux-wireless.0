Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from glaubenleben.de ([85.214.105.140]:44409 "EHLO glaubenleben.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758062AbcATHgZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jan 2016 02:36:25 -0500
From: Andreas Kemnade <andreas@kemnade.info>
To: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, hns@goldelico.com
Subject: [PATCH 0/6] wireless:libertas: ieee80211 powersave mode
Date: Wed, 20 Jan 2016 08:35:33 +0100
Message-Id: <1453275339-25122-1-git-send-email-andreas@kemnade.info> (sfid-20160120_083644_174304_F2486E88)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series makes IEEE 80211 powersave mode work again so
that power usage is dramatically reduced when the device is connected.
It does not include other power saving methods which are working
when the device is not connected (like enabling
deep sleep modus)

Tested on GTA04 which includes a
W2CBW003 chip (Marvel 8686) with sdio interface

Changes in v2:
improved some commit messages, order changed,
former 6/6 was too late it needs to be before
implementing the cfg80211  power saving interface
to have it git-bisectable. 
moving the former 3/6 to the end fixes
all bisect problems

[PATCH v2 1/6] wireless:libertas: fix pointer bugs for PS_MODE
[PATCH v2 2/6] wireless:libertas: check whether bus can do more than
[PATCH v2 3/6] wireless:libertas: do not confirm sleep if commands
[PATCH v2 4/6] wireless:libertas: go back to ps mode without commands
[PATCH v2 5/6] wireless:libertas: fix ps-mode related removal
[PATCH v2 6/6] wireless:libertas: add an cfg80211 interface for
