Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56622 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757763AbZE1Bsq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 May 2009 21:48:46 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linux-wireless@vger.kernel.org
Cc: jal2@gmx.de, Peter.Grabienski@Atheros.com,
	Stephen.Chen@Atheros.com, Michael.Fortin@Atheros.com,
	Johnny.Cheng@Atheros.com, Yuan-Gu.Wei@atheros.com,
	otus-devel@lists.madwifi-project.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [RFT 0/2] ar9170: initial stage 1 firmware support /  AVM fritz
Date: Wed, 27 May 2009 21:48:44 -0400
Message-Id: <1243475326-28867-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Please give this a shot with the AVM Fritz device.
At least for me I can only scan, I cannot associate to an AP
yet with the 1 stage firmware but I've been told it does seem
to work with some devices..

If you can even at least scan with the AVM fritz devices then this means
we just need to finish the 1 stage firmware support in order for them to work.
I cannot work on this more though so if someone has time and you want to pick
up the work please refer the Otus code (in staging/otus/ and ensure that the
code #ifdef'd around ZM_OTUS_LINUX_PHASE_2 is _not_ used. ar9170 and otus
are very different (which is good) but unfortunately for this exercise this
means its very difficult to find the exact calls #ifdef'd on the ar9170 port.
I may have missed one or two more.

Luis R. Rodriguez (2):
  ar9170: add initial support for 1-stage firmware
  ar9170: add AVM FRITZ devices

 drivers/net/wireless/ath/ar9170/phy.c |   13 ++++++--
 drivers/net/wireless/ath/ar9170/usb.c |   50 +++++++++++++++++++++++++++++---
 drivers/net/wireless/ath/ar9170/usb.h |    2 +
 3 files changed, 57 insertions(+), 8 deletions(-)

