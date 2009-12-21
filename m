Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from parez.praha12.net ([78.108.102.1]:44846 "EHLO parez.praha12.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757326AbZLUVu4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2009 16:50:56 -0500
From: =?UTF-8?q?Luk=C3=A1=C5=A1=20Turek?= <8an@praha12.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	lrodriguez@atheros.com, ath5k-devel@lists.ath5k.org
Subject: [PATCH v3 0/5] Setting coverage class (and ACK timeout and slot time), take two
Date: Mon, 21 Dec 2009 22:50:46 +0100
Message-Id: <1261432252-1855-1-git-send-email-8an@praha12.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These patches implement a feature essential for long distance wireless links:
setting ACK timeout and slot time. The API is based on a parameter called
Coverage Class specified by the 802.11 standard.

The first two patches add support to the kernel 802.11 stack via a new nl80211
attribute and a mac80211 callback.

Following three patches implement the callback in ath5k driver, after some
requisite fixes. Implementation in ath9k driver is planned.

Please note the last patch outside the series is not a kernel patch, it adds
the necessary support to userspace program iw.

This is a third version of these patches, with following minor changes:
* mac80211: add drv_ wrapper for mac80211 callback including tracer
* ath5k: move setting ah_coverage_class to ath5k_hw_set_coverage_class()

Lukas Turek
