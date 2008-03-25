Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4786 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757775AbYCYSHF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Mar 2008 14:07:05 -0400
Date: Tue, 25 Mar 2008 13:42:27 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Chatre, Reinette" <reinette.chatre@intel.com>
Cc: Roel Kluin <12o3l@tiscali.nl>, "Zhu, Yi" <yi.zhu@intel.com>,
	linux-wireless@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RESEND] wireless: convert !X & Y to !(X & Y) in
	iwl4965_is_fat_tx_allowed()
Message-ID: <20080325174227.GB3026@tuxdriver.com> (sfid-20080325_180711_606513_A8A86FB4)
References: <47E9226C.7090403@tiscali.nl> <D936D925018D154694D8A362EEB08920040370C5@orsmsx416.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <D936D925018D154694D8A362EEB08920040370C5@orsmsx416.amr.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 25, 2008 at 09:30:58AM -0700, Chatre, Reinette wrote:
> On Tuesday, March 25, 2008 9:04 AM, Roel Kluin  wrote:
> 
> > from include/linux/ieee80211.h:274:
> > #define IEEE80211_HT_CAP_SUP_WIDTH              0x0002 ---
> > ! has a higher priority than &
> > 
> > Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
> > ---
> > diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c
> > b/drivers/net/wireless/iwlwifi/iwl-4965.c
> > index d727de8..6576757 100644
> > --- a/drivers/net/wireless/iwlwifi/iwl-4965.c
> > +++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
> > @@ -4589,7 +4589,7 @@ static u8
> > iwl4965_is_fat_tx_allowed(struct iwl4965_priv *priv,
> > 
> > 	if (sta_ht_inf) {
> > 		if ((!sta_ht_inf->ht_supported) ||
> > -		   (!sta_ht_inf->cap & IEEE80211_HT_CAP_SUP_WIDTH))
> > +		   (!(sta_ht_inf->cap & IEEE80211_HT_CAP_SUP_WIDTH)))
> return 0;
> > 	}
> 
> This patch has already been acked and merged into wireless-testing, and
> afaik already pushed further upstream.

Yes, but FWIW the problem exists in the 2.6.25 stream as well.
I've been holding-back a patch to fix it there, trying to decide if it
is worth creating the merge conflict to fix it there.  I'm inclined
to think it is better to let things lay as they are and send that
patch for the -stable series once 2.6.25 ships.

Any thoughts on that?

John
-- 
John W. Linville
linville@tuxdriver.com
