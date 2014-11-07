Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:58027 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751579AbaKGMcF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Nov 2014 07:32:05 -0500
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com
Date: Fri,  7 Nov 2014 14:31:34 +0200
Message-Id: <1415363497-8475-1-git-send-email-luca@coelho.fi> (sfid-20141107_133209_072804_B8FED68C)
Subject: [PATCH v2 0/3] cfg80211/mac80211: CSA notification
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

This is a rework of the channel switch started notification that I
sent a long time ago.  According to the review, I removed the failure
notification.  Additionally, some other small changes were made to fix
some things and adapt to the current code.

Please review.

--
Luca.

Luciano Coelho (3):
  cfg80211/nl80211: add channel switch started notification
  mac80211: send channel switch started notifications
  cfg80211/nl80211: allow any interface to send channel switch
    notifications

 include/net/cfg80211.h       | 14 ++++++++++++++
 include/uapi/linux/nl80211.h | 15 ++++++++++++++-
 net/mac80211/cfg.c           |  3 +++
 net/mac80211/mlme.c          |  5 +++++
 net/wireless/nl80211.c       | 34 +++++++++++++++++++++++++---------
 net/wireless/trace.h         | 16 ++++++++++++++++
 6 files changed, 77 insertions(+), 10 deletions(-)

-- 
2.1.1

