Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f45.google.com ([209.85.214.45]:38012 "EHLO
        mail-it0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751396AbdB1Wdc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Feb 2017 17:33:32 -0500
Received: by mail-it0-f45.google.com with SMTP id y135so19457501itc.1
        for <linux-wireless@vger.kernel.org>; Tue, 28 Feb 2017 14:33:31 -0800 (PST)
To: sara.sharon@intel.com
Cc: linux-wireless@vger.kernel.org, luciano.coelho@intel.com,
        liad.kaufman@intel.com
From: Jens Axboe <axboe@kernel.dk>
Subject: WARNING: CPU: 1 PID: 23668 at
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c:1539 iwl_mvm_rm_sta+0x3ce/0x450
Message-ID: <c60e6859-f1ec-6656-2625-b5ce5f18059a@kernel.dk> (sfid-20170228_233335_716177_931FE2ED)
Date: Tue, 28 Feb 2017 11:02:02 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm hitting this one a lot with current -git, which is this one:

if (iwl_mvm_is_dqa_supported(mvm)) {                            
        iwl_mvm_disable_sta_queues(mvm, vif, mvm_sta);          
        /*                                                      
         * If pending_frames is set at this point - it must be  
         * driver internal logic error, since queues are empty  
         * and removed successuly.                              
         * warn on it but set it to 0 anyway to avoid station   
         * not being removed later in the function              
         */                                                     
        WARN_ON(atomic_xchg(&mvm->pending_frames[sta_id], 0));  
}

It's hit 4 times over the last day. The bug is probably older than the
commit that added this warning:

commit 94c3e614df2117626fccfac8f821c66e30556384
Author: Sara Sharon <sara.sharon@intel.com>
Date:   Wed Dec 7 15:04:37 2016 +0200

    iwlwifi: mvm: fix pending frame counter calculation

but the pestering is new.

-- 
Jens Axboe
