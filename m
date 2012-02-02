Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:51585 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754654Ab2BBEZZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Feb 2012 23:25:25 -0500
Date: Wed, 1 Feb 2012 22:25:21 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	Felix Fietkau <nbd@openwrt.org>
Subject: CTS timeout issue with AR9285
Message-ID: <20120202042521.GA20635@ubuntu-macmini> (sfid-20120202_052529_870762_4F77B0B8)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I recently updated a machine with AR9285 wireless from kernel version
3.0 to 3.2 and saw that wireless had become slow and unreliable. It
seems that the problem is extremely frequent CTS timeouts, which began
happening with commit adb5066 (ath9k_hw: do not apply the 2.4 ghz ack
timeout workaround to cts). Restoring the CTS timeout to the value prior
to this commit on top of 3.2 gets performance back to what it was with
3.0.

I don't have any other ath9k cards lying around, but various other cards
are working fine with this router. Any ideas what's wrong here?

Thanks,
Seth
