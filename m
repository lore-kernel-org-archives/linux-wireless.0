Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:46608 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394AbZIXSCu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2009 14:02:50 -0400
Received: from vaebh106.NOE.Nokia.com (vaebh106.europe.nokia.com [10.160.244.32])
	by mgw-mx06.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id n8OI2DaH005652
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2009 21:02:37 +0300
Received: from [127.0.1.1] (essapo-nirac25264.europe.nokia.com [10.162.252.64])
	by mgw-da01.ext.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id n8OI2PZF028049
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2009 21:02:29 +0300
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 0/2] cfg80211: firmware and hardware version
To: linux-wireless@vger.kernel.org
Date: Thu, 24 Sep 2009 11:02:29 -0700
Message-ID: <20090924180048.14503.9579.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here's my suggestion how to provide firmware and hardware version to
user space. First I was thinking adding a new nl80211 command and
it looked so ugly that I decided include the versions in struct wiphy
instead.

Please comment.

---

Kalle Valo (2):
      at76c50x-usb: set firmware and hardware version in wiphy
      cfg80211: add firmware and hardware version to wiphy


 drivers/net/wireless/at76c50x-usb.c |   15 +++++++++++++++
 include/linux/nl80211.h             |    3 +++
 include/net/cfg80211.h              |    5 +++++
 net/wireless/nl80211.c              |   11 +++++++++++
 4 files changed, 34 insertions(+), 0 deletions(-)

