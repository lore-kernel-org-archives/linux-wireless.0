Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49742 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808Ab2GFTsb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2012 15:48:31 -0400
Date: Fri, 6 Jul 2012 15:37:33 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: thomas <thomas@net.t-labs.tu-berlin.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, nbd@openwrt.org,
	brcm80211-dev-list@broadcom.com, pieterpg@broadcom.com,
	gregkh@suse.de, frankyl@broadcom.com, arend@broadcom.com,
	rvossen@broadcom.com, brudley@broadcom.com
Subject: Re: [PATCH v2] brcmsmac: restructure info->control.sta handling as
 it is goning to be removed soon.
Message-ID: <20120706193733.GC1879@tuxdriver.com> (sfid-20120706_214836_692954_A1D79519)
References: <1340974563-77085-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
 <1340975210.4472.1.camel@jlt3.sipsolutions.net>
 <4FEDC3F0.1000201@net.t-labs.tu-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4FEDC3F0.1000201@net.t-labs.tu-berlin.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 29, 2012 at 11:04:16AM -0400, thomas wrote:
> Johannes Berg schrieb:
> 
> > On Fri, 2012-06-29 at 05:56 -0700, Thomas Huehn wrote:
> >> brcmsmac uses info->control.sta while doing ampdu aggregation. This patch
> >> changes the usage of the structure info->control.sta, as it is going to be
> >> removed soon from struct ieee80211_tx_info. This patch is a pre-requisit in
> >> order to add transmission power control (TPC) to the mac80211 subsystem.
> >>
> >> Suggested-by: Felix Fietkau <nbd@openwrt.org>
> >> Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
> >> ---
> >> Change sequence of overwriting data. Thx to Johannes.
> > 
> > 
> >> @@ -665,7 +665,7 @@ brcms_c_sendampdu(struct ampdu_info *ampdu, struct brcms_txq_info *qi,
> >>  			u8 plcp0, plcp3, is40, sgi;
> >>  			struct ieee80211_sta *sta;
> >>  
> >> -			sta = tx_info->control.sta;
> >> +			sta = tx_info->rate_driver_data[0];
> > 
> > Are you sure it actually works now?
> 
> 
> From locking at the code, sta is never used after it gets overridden.
> The brcmsmac driver does not use the vif pointer at all. I asked Felix
> to double check as I do not have a Broadcom device over here.
> 
> Bye Thomas

Any comments on this one from the Broadcom camp?

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
