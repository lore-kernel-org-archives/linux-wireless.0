Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:53460 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755765Ab2GDHWO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jul 2012 03:22:14 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v1 0/2] High bitrate support
Date: Wed, 4 Jul 2012 10:21:58 +0300
Message-ID: <1341386520-25244-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20120704_092218_723983_8D7E6351)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I rephrased comments following Luis's input.

As for the name for new option, still have no idea what
is the best name, thus leaving NL80211_RATE_INFO_BITRATE_HT

Anyone to suggest better name?

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

