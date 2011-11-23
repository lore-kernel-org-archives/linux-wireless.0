Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:40442 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756662Ab1KWPlD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Nov 2011 10:41:03 -0500
Received: by vcbfk14 with SMTP id fk14so442626vcb.19
        for <linux-wireless@vger.kernel.org>; Wed, 23 Nov 2011 07:41:03 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
To: linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Subject: [RFC 0/5] wireless: applying country IE and reg changes immediately
Date: Wed, 23 Nov 2011 10:40:53 -0500
Message-Id: <1322062858-15276-1-git-send-email-mcgrof@qca.qualcomm.com> (sfid-20111123_164107_972069_1600535A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The first patch in this series still needs some work as noted by Rajkumar Manoharan,
but it also made me think more how we are applying power setting and regulatory
settings. Turns out that the reason why the power settings will take effect
*soonish* is that we do things like scanning, and other hardware operations
that trigger applying the settings to hardware. But -- if we want to be even
more efficient we may want to apply the power settings.. say from the country IE
if we are allowed for more power ASAP. The gain is small though.. but this
series adds some junk to where I think we'd need to apply settings and here's
one way of doing it. I am not a fan of it but its one way of doing it.

Not sure if we have alternatives. Apart from power settings consider the
different types of channe types and if for whatever reason a new channel
type that we are on gets disabled. I don't think this is gong to happen...
because considering that if you connect to an AP -- chances are it is
allowed to use that channel on the same channel type you associated to it
with :) The only use case would be if the user manually set the regulatory
domain to override and help compliance.

OK I'm inclined to leave this as-is without all this junk code. But
will send out just as a brain excercise and to see if anyone else has
some thoughts. If we are fine living with the power settings from
the country IE not taking effect immediatley then great.. otherwise
we need something like this. The other thing that I'm not too happy
about is the usage of NL80211_TX_POWER_REG as API and userspace
would simply ignore that -- unless I guesss we send that as an event?
I can't find a better place for this though.

Luis R. Rodriguez (5):
  cfg80211: allow following country IE power for custom regdom cards
  cfg80211: add support to immediately apply reg settings
  mac80211: add support for NL80211_TX_POWER_REG
  ath6kl: add support for NL80211_TX_POWER_REG
  wireless: annotate drivers that do not support NL80211_TX_POWER_REG

 drivers/net/wireless/ath/ath6kl/cfg80211.c         |    6 ++++
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |    2 +
 drivers/net/wireless/iwmc3200wifi/cfg80211.c       |    2 +
 drivers/net/wireless/mwifiex/cfg80211.c            |    3 ++
 include/linux/nl80211.h                            |    4 +++
 include/net/cfg80211.h                             |    4 ++-
 net/mac80211/cfg.c                                 |    6 ++++
 net/wireless/core.c                                |   23 ++++++++++++++++
 net/wireless/core.h                                |    2 +
 net/wireless/nl80211.c                             |    5 +++
 net/wireless/reg.c                                 |   28 +++++++++++++++++---
 11 files changed, 80 insertions(+), 5 deletions(-)

-- 
1.7.4.15.g7811d

