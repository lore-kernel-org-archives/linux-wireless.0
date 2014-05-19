Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:62676 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016AbaESKkg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2014 06:40:36 -0400
MIME-Version: 1.0
Date: Mon, 19 May 2014 13:40:34 +0300
Message-ID: <CANUX_P2MSK_rUMyN2xa8A9dZwuPSKh+eiOr10KG6PocCQdVhvA@mail.gmail.com> (sfid-20140519_124039_639427_3640FB87)
Subject: How to disable beacon filtering in iwlwifi in 3.13 and 3.14
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: "stable@vger.kernel.org" <stable@vger.kernel.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I need to disable a feature on 3.13 and 3.14. But I don't have any
patch upstream that I can point to as the patch that needs to be
backported.
We have a feature that is buggy in 3.13 and 3.14. We refactored (and
fixed) this feature in 3.15 but the refactor is really not stable
material, so basically, I can't backport the fix to 3.13 / 3.14. A
user reported that disabling the feature solved (part of) his issues:
https://bugzilla.kernel.org/show_bug.cgi?id=72601.
OTOH, I don't have any patch in linux.git that could be backported to
do what I want in 3.13 / 3.14 - i.e. disable the feature.
What is the right process here? I understand that this isn't covered
by the "stable rules". So what should I do here?

FYI: this is the patch:

commit 31e56634bea6ab23817faa069663af3103da0609
Author: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Date:   Sun May 18 19:05:23 2014 +0300

    iwlwifi: mvm: disable beacon filtering

    This feature has been causing trouble - disable it for now.
    Fixes are available, but they are too big to be backported.

    https://bugzilla.kernel.org/show_bug.cgi?id=72601

    Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index cd6ea2e..17c097d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -619,7 +619,7 @@ static int iwl_mvm_mac_add_interface(struct
ieee80211_hw *hw,
        if (ret)
                goto out_remove_mac;

-       if (!mvm->bf_allowed_vif &&
+       if (!mvm->bf_allowed_vif && false &&
            vif->type == NL80211_IFTYPE_STATION && !vif->p2p &&
            mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_BF_UPDATED){
                mvm->bf_allowed_vif = mvmvif;



Emmanuel Grumbach
egrumbach@gmail.com
