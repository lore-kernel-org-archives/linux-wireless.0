Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:14152 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752546AbYFLJ4M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jun 2008 05:56:12 -0400
MIME-Version: 1.0
Subject: RE: [PATCH 1/1] mac80211: [RFC] do not fragment while aggregationis in use
Date: Thu, 12 Jun 2008 12:56:07 +0300
Message-ID: <1879838866982C46A9CB3D56BA49ADEB050224AF@hasmsx411.ger.corp.intel.com> (sfid-20080612_115617_186091_4C9DEAAA)
In-Reply-To: <1213219526.3827.0.camel@johannes.berg>
References: <1213207296-14548-1-git-send-email-ron.rindjunsky@intel.com> <1213219526.3827.0.camel@johannes.berg>
From: "Rindjunsky, Ron" <ron.rindjunsky@intel.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> -	/*
>> -	 * Warn when submitting a fragmented A-MPDU frame and drop it.
>> -	 * This is an error and needs to be fixed elsewhere, but when
>> -	 * done needs to take care of monitor interfaces (injection)
>> -	 * etc.
>> -	 */
>> -	if (WARN_ON(tx->flags & IEEE80211_TX_CTL_AMPDU ||
>> -		    skb_get_queue_mapping(tx->skb) >=
>> -			ieee80211_num_regular_queues(&tx->local->hw)))
>> -		return TX_DROP;
>> -

> Should we keep that, just in case? If it ever happens and the hw
rejects
> a fragment for some reason, we'll otherwise clobber some state and
> probably crash.

Agree. Should I resend the patch or would you just remove it from the
original patch?

> johannes
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

