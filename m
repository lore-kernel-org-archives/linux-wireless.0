Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:45241 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029Ab3CGPrd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Mar 2013 10:47:33 -0500
Received: by mail-ee0-f41.google.com with SMTP id c13so441701eek.14
        for <linux-wireless@vger.kernel.org>; Thu, 07 Mar 2013 07:47:32 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 00/13] b43: implement basic TX power mgmt
Date: Thu,  7 Mar 2013 16:47:14 +0100
Message-Id: <1362671247-10766-1-git-send-email-zajec5@gmail.com> (sfid-20130307_164737_089163_9FCB91D1)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After spotting a lot of N-PHY-similar functions in
BCM4331 dump of MMIO ops - split into names parts
I was able to finally improve HT-PHY code.

It now sets TX basically, I can finally talk with devices that are few
meters away, not just few centimetres. It's a little patch bomb, sorry
for that, but I wasn't sure if my code is correct until it was complete
and started working.

Rafał Miłecki (13):
  b43: HT-PHY: rename AFE defines
  b43: HT-PHY: add classifier control function
  b43: HT-PHY: move TX fix to the separated function
  b43: HT-PHY: implement spurious tone avoidance
  b43: HT-PHY: implement MAC reclocking
  b43: HT-PHY: implement CCA reset
  b43: HT-PHY: implement PA override
  b43: HT-PHY: implement controlling TX power control
  b43: HT-PHY: implement stopping sample tone playback
  b43: HT-PHY: implement playing sample tone
  b43: HT-PHY: implement RSSI polling
  b43: HT-PHY: setup TX power control
  b43: HT-PHY: enable basic TX power setup

 drivers/net/wireless/b43/phy_ht.c |  603 +++++++++++++++++++++++++++++++++----
 drivers/net/wireless/b43/phy_ht.h |   77 ++++-
 2 files changed, 613 insertions(+), 67 deletions(-)

-- 
1.7.10.4

