Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:32273 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932984Ab2GFWUa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2012 18:20:30 -0400
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: <johannes@sipsolutions.net>, <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <kvalo@qca.qualcomm.com>,
	<arend@broadcom.com>, <henry@logout.com>,
	<senthilb@qca.qualcomm.com>,
	"Luis R. Rodriguez" <mcgrof@frijolero.org>
Subject: [PATCH v3 0/3] wireless: certification onus and cell regulatory hint
Date: Fri, 6 Jul 2012 15:20:23 -0700
Message-ID: <1341613226-11774-1-git-send-email-rodrigue@qca.qualcomm.com> (sfid-20120707_002109_168895_CA51CB10)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@frijolero.org>

This v3 series addresses disabling the cell base station hint
regulatory if no device registered with the wireless core
supports the feature.

I'll also send the ath5k / ath9k patches separately.

Luis R. Rodriguez (3):
  cfg80211: add CONFIG_CFG80211_CERTIFICATION_ONUS
  cfg80211: add cellular base station regulatory hint support
  cfg80211: rename reg_device_remove() to wiphy_regulatory_deregister()

 include/linux/nl80211.h  |   32 +++++++++++++
 include/net/regulatory.h |    4 ++
 net/wireless/Kconfig     |   21 +++++++++
 net/wireless/core.c      |    9 ++--
 net/wireless/nl80211.c   |   15 +++++-
 net/wireless/reg.c       |  115 +++++++++++++++++++++++++++++++++++++++++++---
 net/wireless/reg.h       |    7 ++-
 7 files changed, 190 insertions(+), 13 deletions(-)

-- 
1.7.10.rc1.22.gf5241

