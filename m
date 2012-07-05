Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:34028 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754636Ab2GEL0G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jul 2012 07:26:06 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v2 0/2] High bitrate support
Date: Thu, 5 Jul 2012 14:25:48 +0300
Message-ID: <1341487550-11502-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20120705_132609_877166_126E3988)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I like what Johannes suggested, thus name for new bitrate option
changed to NL80211_RATE_INFO_BITRATE32

Patch for iw will follow shortly

Proposed patches solve issue with high bitrates not fitting into u16.                                                                                                              
                                                                                                                                                                                   
I split it into 2 patches: one introduces new u32 bitrate,                                                                                                                         
and 2-nd adds 60g specific calculations.                                                                                                                                           
                                                                                                                                                                                   
Idea is to report (in nl80211) both old and new values,
or only new if it not fits into u16.
User space tools encouraged to migrate to the new bitrate.

cfg80211_calculate_bitrate() changed to return u32
There are few places where cfg80211_calculate_bitrate() used
besides nl80211.c; but these places are OK with bitrate changing
from u16 to u32.

Vladimir Kondratiev (2):
  {nl,cfg}80211: support high bitrates
  cfg80211: bitrate calculation for 60g

 include/linux/nl80211.h |    8 ++++++++
 include/net/cfg80211.h  |    4 +++-
 net/wireless/nl80211.c  |    9 +++++++--
 net/wireless/util.c     |   51 ++++++++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 68 insertions(+), 4 deletions(-)

-- 
1.7.9.5

