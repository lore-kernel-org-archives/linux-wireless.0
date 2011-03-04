Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:58681 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630Ab1CDDgj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2011 22:36:39 -0500
Received: by iwn34 with SMTP id 34so1561817iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 03 Mar 2011 19:36:39 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 3 Mar 2011 19:36:39 -0800
Message-ID: <AANLkTinxpWeaQNvbTwUteu2ieOBOw5spAbHjgBK0T2jF@mail.gmail.com>
Subject: [PATCH 0/7] {mac|nl}80211: Support for SAE mesh authentication in userspace
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: devel@lists.open80211s.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Javier Cardona (7):
 mac80211: Support RSN information element on mesh interfaces
 mac80211: New constant definitions for SAE
 mac80211: Let user space receive and send mesh auth/deauth frames
 mac80211: Accept mesh auth frames before a peer link has been
    established
  nl80211: Let userspace set the authenticated flag for a mesh peer
  mac80211: Parse RSN information element to determine if a peer needs
    authentication
  mac80211: Check auth status before attempting to establish a peer
    link

  include/linux/ieee80211.h  |   19 +++++++++++++++++
  include/linux/nl80211.h    |   13 ++++++++++-
  include/net/cfg80211.h     |    4 +++
  net/mac80211/cfg.c         |   25 +++++++++++++++++++--
  net/mac80211/ieee80211_i.h |    4 ++-
  net/mac80211/main.c        |    4 ++-
  net/mac80211/mesh.c        |   33 ++++++++++++++++++++++++++++-
  net/mac80211/mesh.h        |    2 +-
  net/mac80211/mesh_plink.c  |   15 +++++++++++-
  net/mac80211/rx.c          |    3 +-
  net/mac80211/tx.c          |    3 +-
  net/mac80211/util.c        |   49 ++++++++++++++++++++++++++++++++++++++++++-
  net/wireless/nl80211.c     |   16 +++++++++++++-
  13 files changed, 175 insertions(+), 15 deletions(-)
