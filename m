Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:59359 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752265AbaKJJKe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Nov 2014 04:10:34 -0500
From: Luca Coelho <luca@coelho.fi>
To: emmanuel.grumbach@intel.com
Cc: linux-wireless@vger.kernel.org,
	Luciano Coelho <luciano.coelho@intel.com>
Date: Mon, 10 Nov 2014 11:10:05 +0200
Message-Id: <1415610621-27438-1-git-send-email-luca@coelho.fi> (sfid-20141110_101124_236371_621C42F1)
Subject: [PATCH 00/16] iwlwifi: mvm: more CSA patches
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Hi,

These patches finalize the CSA implementation for iwlmvm.  These are
the remaining patches that were still pending in our internal tree.
After this, I believe we are aligned.

This series depends on the mac80211/cfg80211 series I sent to Johannes
last Friday (2014-11-07), we probably need to wait those to get
applied to sync things up.

There is one more mac80211 patch that I need to send.  This series
removes the usage of the channel_switch_beacon operation in iwlmvm.
It's the last user of it in the mainline, so we can remove it from
mac80211 after the trees are in sync.

--
Luca.

Andrei Otcheretianski (2):
  iwlwifi: mvm: Handle failed beacon transmissions during CSA
  iwlwifi: mvm: Insert DS Parameter Set placeholder in probes

Luciano Coelho (14):
  iwlwifi: mvm: use new pre_channel_switch op instead of
    channel_switch_beacon
  iwlwifi: mvm: only save csa_vif in AP/GO mode
  iwlwifi: mvm: refactor iwl_mvm_switch_vif_chanctx to support other
    modes
  iwlwifi: mvm: add support for CHANCTX_SWMODE_REASSIGN_VIF
  iwlwifi: mvm: return the actual error code when switch_vif_chanctx
    fails
  iwlwifi: mvm: disable PS during channel switch
  iwlwifi: mvm: use switching_chanctx argument instead of csa_active
  iwlwifi: mvm: add CSA absent time event for clients
  iwlwifi: mvm: schedule CSA time event a bit before beacon 1
  iwlwifi: mvm: finalize on post_switch instead of unassign
  iwlwifi: mvm: add a channel_switch op to bypass mac80211 timer
  iwlwifi: mvm: disable beacon filtering during CSA
  iwlwifi: mvm: clear TE data if CSA time event fails to start
  iwlwifi: mvm: protect session during CSA

 drivers/net/wireless/iwlwifi/iwl-fw.h         |   4 +-
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c   |  21 ++-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c   | 254 +++++++++++++++++++++-----
 drivers/net/wireless/iwlwifi/mvm/mvm.h        |  36 +++-
 drivers/net/wireless/iwlwifi/mvm/scan.c       |  53 +++++-
 drivers/net/wireless/iwlwifi/mvm/sta.c        |  15 ++
 drivers/net/wireless/iwlwifi/mvm/sta.h        |   1 +
 drivers/net/wireless/iwlwifi/mvm/time-event.c |  39 +++-
 8 files changed, 356 insertions(+), 67 deletions(-)

-- 
2.1.1

