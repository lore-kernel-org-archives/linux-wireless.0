Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41943 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144AbcEJQig (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2016 12:38:36 -0400
Date: Tue, 10 May 2016 22:08:26 +0530
From: Mohammed Shafi Shajakhan <mohammed@codeaurora.org>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Subject: Re: [PATCH v2 3/5] ath10k: Add WARN_ON if we over-write peer-map
 pointer.
Message-ID: <20160510163826.GB21638@atheros-ThinkPad-T61> (sfid-20160510_183840_202948_4852E5B2)
References: <1459545132-11295-1-git-send-email-greearb@candelatech.com>
 <1459545132-11295-3-git-send-email-greearb@candelatech.com>
 <20160510071214.GD25626@atheros-ThinkPad-T61>
 <5731F328.30803@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5731F328.30803@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 10, 2016 at 07:41:44AM -0700, Ben Greear wrote:
> 
> 
> On 05/10/2016 12:12 AM, Mohammed Shafi Shajakhan wrote:
> >Hi Ben,
> >
> >On Fri, Apr 01, 2016 at 02:12:10PM -0700, greearb@candelatech.com wrote:
> >>From: Ben Greear <greearb@candelatech.com>
> >>
> >>Not sure this can happen, but seems like a reasonable sanity
> >>check.
> >
> >[shafi] possibly if the peer is removed and the bit is not cleared in the driver
> >? when the new peer occupies the slot
> 
> A firmware bug could cause this, but I never saw this WARN hit.  Still seems like
> a good sanity check to me, though...it would be quite hard to debug this sort of bug
> if it actually did happen.

[shafi] yeah its good to have, in one of the case i saw a duplicate event
(though its harmless )

> 
> >
> >>
> >>Signed-off-by: Ben Greear <greearb@candelatech.com>
> >>---
> >>  drivers/net/wireless/ath/ath10k/txrx.c | 1 +
> >>  1 file changed, 1 insertion(+)
> >>
> >>diff --git a/drivers/net/wireless/ath/ath10k/txrx.c b/drivers/net/wireless/ath/ath10k/txrx.c
> >>index a779a4e..2edef8a 100644
> >>--- a/drivers/net/wireless/ath/ath10k/txrx.c
> >>+++ b/drivers/net/wireless/ath/ath10k/txrx.c
> >>@@ -309,6 +309,7 @@ void ath10k_peer_map_event(struct ath10k_htt *htt,
> >>  	ath10k_warn(ar, /*ATH10K_DBG_HTT,*/ "htt peer map vdev %d peer %pM id %d\n",
> >>  		   ev->vdev_id, ev->addr, ev->peer_id);
> >>
> >>+	WARN_ON(ar->peer_map[ev->peer_id] && (ar->peer_map[ev->peer_id] != peer));
> >>  	ar->peer_map[ev->peer_id] = peer;
> >>  	set_bit(ev->peer_id, peer->peer_ids);
> >>  exit:
> >>--
> >>2.4.3
> >
> >regards,
> >shafi
> >
> >>
> >>
> >>_______________________________________________
> >>ath10k mailing list
> >>ath10k@lists.infradead.org
> >>http://lists.infradead.org/mailman/listinfo/ath10k
> >
> >_______________________________________________
> >ath10k mailing list
> >ath10k@lists.infradead.org
> >http://lists.infradead.org/mailman/listinfo/ath10k
> >
> 
> -- 
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com
> 
> _______________________________________________
> ath10k mailing list
> ath10k@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/ath10k
