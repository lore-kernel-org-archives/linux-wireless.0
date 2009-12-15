Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from parez.praha12.net ([78.102.11.253]:40009 "EHLO
	parez.praha12.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759924AbZLOR45 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Dec 2009 12:56:57 -0500
From: =?UTF-8?q?Luk=C3=A1=C5=A1=20Turek?= <8an@praha12.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	ath5k-devel@lists.ath5k.org
Subject: [PATCH 0/5] Setting coverage class (and ACK timeout and slot time), take two
Date: Tue, 15 Dec 2009 18:56:47 +0100
Message-Id: <1260899813-17585-1-git-send-email-8an@praha12.net>
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

This is a second version of these patches, with these changes:

* The coverage class is calculated from roundtrip time instead of one-way
  delay asi specified by the standard

* Calculation of slot time and ACK timeouts is based on 802.11 standard and
  Madwifi 0.10.5.6, instead of athctrl program from Madwifi 0.9.4

* Full name "coverage_class" is used everywhere for consistency

Lukas Turek
