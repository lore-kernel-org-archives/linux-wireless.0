Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:32360 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752432Ab3FGNgV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Jun 2013 09:36:21 -0400
Received: from 89-71-197-70.dynamic.chello.pl (HELO localhost.localdomain) (moorray3@[89.71.197.70])
          (envelope-sender <moorray3@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with SMTP
          for <linux-wireless@vger.kernel.org>; 7 Jun 2013 15:36:19 +0200
From: Jakub Kicinski <moorray3@wp.pl>
To: linux-wireless@vger.kernel.org
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	Felix Fietkau <nbd@openwrt.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	nietrywialneprzejscie@gmail.com
Subject: [RFC 0/5] Fix mac addr enforcement on monitor interfaces
Date: Fri,  7 Jun 2013 15:36:14 +0200
Message-Id: <1370612179-24385-1-git-send-email-moorray3@wp.pl> (sfid-20130607_153625_109656_EE0E6951)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jakub Kicinski <kubakici@wp.pl>

It's still possible for users to hurt themselves 
by setting incompatible mac addresses on hardware
that needs conformance to addr_mask. This series
aims to fix that and improve address assignment to
active monitors.

Unfortunately there is a merge conflict in mac80211.git
and mac80211-next.git between:

ac20976dca mac80211: Allow single vif mac address change with addr_mask
and
31eba5bc56 mac80211: support active monitor interfaces

so I got confused and based the series on
wireless-testing.git. Is this acceptable?

Jakub Kicinski (5):
  mac80211: introduce __ieee80211_assign_perm_addr
  mac80211: return new mac address as soon as possible
  mac80211: always default to address compatible with mask
  mac80211: enforce address verification on monitors
  mac80211: assign right mac addr to active monitors

 net/mac80211/cfg.c         |   2 +-
 net/mac80211/ieee80211_i.h |   2 +-
 net/mac80211/iface.c       | 197 ++++++++++++++++++++++-----------------------
 net/mac80211/main.c        |   2 +-
 4 files changed, 99 insertions(+), 104 deletions(-)

-- 
1.8.1.4

