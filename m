Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:13046 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719Ab2GJRXQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2012 13:23:16 -0400
Cc: <linux-wireless@vger.kernel.org>, <kvalo@qca.qualcomm.com>,
	<arend@broadcom.com>, <henry@logout.com>,
	<senthilb@qca.qualcomm.com>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: <johannes@sipsolutions.net>, <linville@tuxdriver.com>
Subject: [PATCH v4 0/5] cfg80211: onus and cell base station hint
Date: Tue, 10 Jul 2012 10:23:06 -0700
Message-ID: <1341940991-11234-1-git-send-email-rodrigue@qca.qualcomm.com> (sfid-20120710_192328_893405_DAA6FB63)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>

These address the latest feedback on the v3 series. I've added
two more patches to address removing of a superflous call
given the introduction of wiphy_regulatory_register().

Luis R. Rodriguez (5):
  cfg80211: add CONFIG_CFG80211_CERTIFICATION_ONUS
  cfg80211: add cellular base station regulatory hint support
  cfg80211: rename reg_device_remove() to wiphy_regulatory_deregister()
  cfg80211: make regulatory_update() static
  cfg80211: remove regulatory_update()

 include/linux/nl80211.h  |   32 ++++++++++++
 include/net/regulatory.h |    5 ++
 net/wireless/Kconfig     |   21 ++++++++
 net/wireless/core.c      |   10 ++--
 net/wireless/nl80211.c   |   23 ++++++++-
 net/wireless/reg.c       |  125 ++++++++++++++++++++++++++++++++++++++++------
 net/wireless/reg.h       |    8 +--
 7 files changed, 201 insertions(+), 23 deletions(-)

-- 
1.7.10.rc1.22.gf5241

