Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:3785 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757884Ab2B2P4E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Feb 2012 10:56:04 -0500
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Mohammed Shafi <shafi.wireless@gmail.com>,
	Emmanuel Grumbach <egrumbach@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
	linux-wireless Mailing List <linux-wireless@vger.kernel.org>
Subject: RE: sleeping function called from invalid context at
 drivers/net/wireless/iwlwifi/iwl-trans.h:452
Date: Wed, 29 Feb 2012 15:55:54 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB30B3B09@HASMSX103.ger.corp.intel.com> (sfid-20120229_165609_443459_9B65DF7F)
References: <CAD2nsn1b0FtbY3MX9MhWxkRwv9KvNvRD7p5jM8GDA=PqS_yiqA@mail.gmail.com>
In-Reply-To: <CAD2nsn1b0FtbY3MX9MhWxkRwv9KvNvRD7p5jM8GDA=PqS_yiqA@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Hi Emmanuel,
> 
> was debugging some issue in ath9k with UDP bidirectional traffic and
> then used my inbuilt iwlwifi with bidirectional UDP had this warnings
> 
> * iwlagn_mac_ampdu_action->iwlagn_tx_agg_start ->  (we take spinlock
> 'sta_lock' ) -> iwl_trans_tx_agg_alloc (which has might_sleep)
> * iwlagn_mac_ampdu_action->iwlagn_tx_agg_stop ->  (we take spinlock
> 'sta_lock' ) -> iwl_trans_tx_agg_disable (which has might_sleep)
> 
So I was hoping that nobody would hit that one before we push the next batch of patches that includes the fix for this (courtesy of Johannes). In vain.
Sorry, this is stupid bug: iwl_trans_tx_agg_{alloc,disable} must be atomic...
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

