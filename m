Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:58374 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757728AbYBOQmc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2008 11:42:32 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: [HOTFIX] Re: mac80211/iwl4965: ad-hoc broken in 2.6.25-rc1
Date: Fri, 15 Feb 2008 08:39:56 -0800
Message-ID: <D936D925018D154694D8A362EEB0892003ABCF72@orsmsx416.amr.corp.intel.com> (sfid-20080215_164312_321913_233FFED4)
In-Reply-To: <200802150229.09602.patrick@lunatiki.de>
References: <47B1F422.4060501@scherping.de> <D936D925018D154694D8A362EEB0892003ABCC4A@orsmsx416.amr.corp.intel.com> <D936D925018D154694D8A362EEB0892003ABCCAE@orsmsx416.amr.corp.intel.com> <200802150229.09602.patrick@lunatiki.de>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "Patrick Grimm" <patrick@lunatiki.de>
Cc: <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday, February 14, 2008 5:29 PM, Patrick Grimm  wrote:

>>> Could you please print out the values of fc, priv->iw_mode,
>>> iwl3945_is_associated(priv) and priv->assoc_id just before that
>>> error message is printed?
> 
> Yes
> iwl3945: I iwl3945_tx_skb fc: 8<3>
> iwl3945: I iwl3945_tx_skb mode: 2<3>
> iwl3945: I iwl3945_tx_skb assoc_id: 0<3>
> iwl3945: I iwl3945_tx_skb Dropping - !iwl3945_is_associated
> My changes
> 	IWL_DEBUG_DROP("fc: %d\n", fc);
> 	IWL_DEBUG_DROP("mode: %d\n", priv->iw_mode);
> 	IWL_DEBUG_DROP("assoc_id: %d\", priv->assoc_id);
> 	if ((!iwl3945_is_associated(priv) ||
> 	    ((priv->iw_mode == IEEE80211_IF_TYPE_STA) &&
> !priv->assoc_id)) &&
> 	    ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA)) {
> 		IWL_DEBUG_DROP("Dropping - !iwl3945_is_associated\n");
goto
> 	drop_unlock; }
> Was it right?

great - thanks!

I think you have given us hints about why ad-hoc does not work in
iwl3945. From the above the device thinks it is in STA mode, it should
be in IBSS mode. This is thus a different bug from what the patch is
trying to solve. The patch is still good for iwl3945.

>> One more question ... did ad-hoc work for you before this patch?
> 
> No. In my tests only ipw3945 works in Ad-Hoc mode.

ok - that explains things. The patch assumes that ad-hoc mode is
working, which is unfortunately not the case. We have to fix this.

Reinette


