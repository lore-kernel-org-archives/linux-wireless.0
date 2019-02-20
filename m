Return-Path: <SRS0=0XaW=Q3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CBCEC10F07
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 21:13:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 063A920880
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 21:13:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726363AbfBTVND (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Feb 2019 16:13:03 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:51380 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbfBTVND (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Feb 2019 16:13:03 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC5)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gwZAi-0008E4-Tt; Wed, 20 Feb 2019 22:12:53 +0100
Message-ID: <534525d0b2aa88085fc548b9b5ad6425301a367d.camel@sipsolutions.net>
Subject: Re: bug report: iwlwifi: mvm: support mac80211 TXQs model
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Colin Ian King <colin.king@canonical.com>,
        Sara Sharon <sara.sharon@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        netdev@vger.kernel.org
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date:   Wed, 20 Feb 2019 22:12:51 +0100
In-Reply-To: <427786ae-159a-a7d1-2334-46656d3f2b51@canonical.com> (sfid-20190220_154028_279172_DCB58F52)
References: <427786ae-159a-a7d1-2334-46656d3f2b51@canonical.com>
         (sfid-20190220_154028_279172_DCB58F52)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2019-02-20 at 14:40 +0000, Colin Ian King wrote:
> 
> ..when the used_hw_queues initialization was removed:
> 
> @@ -360,8 +300,6 @@ int iwl_mvm_mac_ctxt_init(struct iwl_mvm *mvm,
> struct ieee80211_vif *vif)
>                 mvm->hw, IEEE80211_IFACE_ITER_RESUME_ALL,
>                 iwl_mvm_mac_iface_iterator, &data);
> 
> -       used_hw_queues = iwl_mvm_get_used_hw_queues(mvm, vif);
> -
>         /*
>          * In the case we're getting here during resume, it's similar to
>          * firmware restart, and with RESUME_ALL the iterator will find
> 
> 
> I'm not 100% sure if the right thing to do is just to now initialize
> used_hw_queues to zero; it's not entirely clear what the initial value
> should be now.

My gut feeling says that we should just remove all of the code - we no
longer use the vif->hw_queue stuff. Which also explains why we didn't
notice any problems from this :)

Something like

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index aa308f7e7989..f90383943c62 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -263,8 +263,7 @@ int iwl_mvm_mac_ctxt_init(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 		.found_vif = false,
 	};
 	u32 ac;
-	int ret, i, queue_limit;
-	unsigned long used_hw_queues;
+	int ret, i;
 
 	lockdep_assert_held(&mvm->mutex);
 
@@ -341,38 +340,9 @@ int iwl_mvm_mac_ctxt_init(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 	INIT_LIST_HEAD(&mvmvif->time_event_data.list);
 	mvmvif->time_event_data.id = TE_MAX;
 
-	/* No need to allocate data queues to P2P Device MAC and NAN.*/
 	if (vif->type == NL80211_IFTYPE_P2P_DEVICE ||
-	    vif->type == NL80211_IFTYPE_NAN) {
-		for (ac = 0; ac < IEEE80211_NUM_ACS; ac++)
-			vif->hw_queue[ac] = IEEE80211_INVAL_HW_QUEUE;
-
+	    vif->type == NL80211_IFTYPE_NAN)
 		return 0;
-	}
-
-	/*
-	 * queues in mac80211 almost entirely independent of
-	 * the ones here - no real limit
-	 */
-	queue_limit = IEEE80211_MAX_QUEUES;
-
-	/*
-	 * Find available queues, and allocate them to the ACs. When in
-	 * DQA-mode they aren't really used, and this is done only so the
-	 * mac80211 ieee80211_check_queues() function won't fail
-	 */
-	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
-		u8 queue = find_first_zero_bit(&used_hw_queues, queue_limit);
-
-		if (queue >= queue_limit) {
-			IWL_ERR(mvm, "Failed to allocate queue\n");
-			ret = -EIO;
-			goto exit_fail;
-		}
-
-		__set_bit(queue, &used_hw_queues);
-		vif->hw_queue[ac] = queue;
-	}
 
 	/* Allocate the CAB queue for softAP and GO interfaces */
 	if (vif->type == NL80211_IFTYPE_AP ||


I'll think about it a bit more and test it out, thanks for the report!

johannes

