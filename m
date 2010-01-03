Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:52456 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532Ab0ACVQZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Jan 2010 16:16:25 -0500
Received: from saunalahti-vams (vs3-12.mail.saunalahti.fi [62.142.5.96])
	by emh03-2.mail.saunalahti.fi (Postfix) with SMTP id 02462EBBBD
	for <linux-wireless@vger.kernel.org>; Sun,  3 Jan 2010 23:07:26 +0200 (EET)
Received: from [127.0.1.1] (a91-155-131-184.elisa-laajakaista.fi [91.155.131.184])
	by emh02.mail.saunalahti.fi (Postfix) with ESMTP id E0E852BD49
	for <linux-wireless@vger.kernel.org>; Sun,  3 Jan 2010 23:07:24 +0200 (EET)
Subject: [PATCH 0/9] mac80211: templates for drivers
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sun, 03 Jan 2010 23:07:24 +0200
Message-ID: <20100103210552.29287.20384.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

there has been talk of creating templates in mac80211 for drivers and
here's what I have been thinking. I have also included wl1251 usage as
an example. Please comment.

---

Kalle Valo (9):
      mac80211: add functions to create PS Poll and Nullfunc templates
      mac80211: use PS Poll and Nullfunc templates when sending such frames
      wl1251: get PS Poll and Nullfunc templates from mac80211
      mac80211: create Probe Request template
      mac80211: use Probe Request template when sending a direct scan
      wl1251: cleanup scanning code
      wl1251: get probe request template from mac80211
      wl1251: use mac80211 provided channel parameters in scanning
      wl1251: fix sleep related error paths in wl1251_op_bss_info_changed()


 drivers/net/wireless/wl12xx/wl1251_cmd.c  |   83 +++++++++
 drivers/net/wireless/wl12xx/wl1251_cmd.h  |   22 ++
 drivers/net/wireless/wl12xx/wl1251_main.c |  274 ++++++-----------------------
 include/linux/ieee80211.h                 |    9 +
 include/net/mac80211.h                    |   47 +++++
 net/mac80211/mlme.c                       |   48 +----
 net/mac80211/tx.c                         |  128 ++++++++++++++
 net/mac80211/util.c                       |   40 ++--
 8 files changed, 363 insertions(+), 288 deletions(-)

