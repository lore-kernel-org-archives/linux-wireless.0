Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50294 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751418Ab3IMKiG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Sep 2013 06:38:06 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: ilw@linux.intel.com
Cc: linux-wireless@vger.kernel.org
Subject: [RFC 0/5] mac80211/iwlwifi: quiesce before restart hw
Date: Fri, 13 Sep 2013 12:36:03 +0200
Message-Id: <1379068568-27552-1-git-send-email-sgruszka@redhat.com> (sfid-20130913_123818_118833_9C9B2479)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here is continuation of short discussion I started here:
http://marc.info/?l=linux-wireless&m=137724899704012&w=2

I made patches which do quiesce and that can be used by iwlwifi
restart procedure to avoid calling iwlwifi methods by mac80211
while firmware is not alive.

But honestly, I'm not happy with that work. It does not fix root of the
problem (microcode errors/hangs) and seems to be just to much
complication to avoid warnings, which are consequence of firmware
malfunction. So I just prefer to remove WARN_ONCE(trans->state !=
IWL_TRANS_FW_ALIVE) and replace it by ordinary IWL_WARN(), which
does not generate auto bug reports.

Regarding firmware problems debugging, perhaps ftrace can be used
for that. iwlwifi has already tracing capabilities. Allow to gather
log using trace-cmd and call tracing_off() when firmware error will
happen, perhaps will allow to debug firmware problems efficiently.
If you think that's right we could add WARN_ONCE on firmware error
to have automatic bug reports. Then we could ask user for the trace
to debug and solve the issue. Would that work for you?

Stanislaw Gruszka (5):
  Revert "mac80211: cleanup suspend/resume on mesh mode"
  Revert "mac80211: cleanup suspend/resume on ibss mode"
  Revert "mac80211: cleanup suspend/resume on managed mode"
  mac80211: add generic quiesce procedure
  iwlwifi: quiesce mac80211 before fw restart

 drivers/net/wireless/iwlwifi/dvm/mac80211.c |  1 +
 drivers/net/wireless/iwlwifi/dvm/main.c     |  4 +-
 include/net/mac80211.h                      | 10 +++++
 net/mac80211/ibss.c                         | 27 +++++++++++-
 net/mac80211/ieee80211_i.h                  |  9 ++++
 net/mac80211/main.c                         | 33 +++++++++++++++
 net/mac80211/mesh.c                         | 55 +++++++++++++++++++++++-
 net/mac80211/mesh.h                         | 12 ++++++
 net/mac80211/mesh_plink.c                   | 27 +++++++++++-
 net/mac80211/mlme.c                         | 65 +++++++++++++++++++++++++++--
 net/mac80211/sta_info.h                     |  2 +
 net/mac80211/util.c                         | 19 ++++++++-
 12 files changed, 254 insertions(+), 10 deletions(-)

-- 
1.8.3.1

