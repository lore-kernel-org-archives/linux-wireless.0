Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lunatiki.de ([85.214.70.22]:49204 "EHLO
	h1112006.serverkompetenz.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755370AbYBOCFl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Feb 2008 21:05:41 -0500
From: Patrick Grimm <patrick@lunatiki.de>
To: "Chatre, Reinette" <reinette.chatre@intel.com>
Subject: Re: [HOTFIX] Re: mac80211/iwl4965: ad-hoc broken in 2.6.25-rc1
Date: Fri, 15 Feb 2008 02:29:09 +0100
Cc: linux-wireless@vger.kernel.org
References: <47B1F422.4060501@scherping.de> <D936D925018D154694D8A362EEB0892003ABCC4A@orsmsx416.amr.corp.intel.com> <D936D925018D154694D8A362EEB0892003ABCCAE@orsmsx416.amr.corp.intel.com>
In-Reply-To: <D936D925018D154694D8A362EEB0892003ABCCAE@orsmsx416.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200802150229.09602.patrick@lunatiki.de> (sfid-20080215_020545_865053_2057C305)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Freitag, 15. Februar 2008 01:21:15 schrieb Chatre, Reinette:
> On , Chatre, Reinette  wrote:
> > On Thursday, February 14, 2008 3:40 PM, Patrick Grimm  wrote:
> >> For me not.
> >> I use 3945ABG card in an ad-hoc network with 4 other wlan devices
> >> like rt2500 and ath5k. I have applied your
> >> 0001-iwlwifi-only-check-for-association-id-when-associat.patch
> >> patch. But i can't see incoming packets witch tcpdump.
> >> I have try to commet out  the check for associat with the same
> >> result.
> >>
> >> dmesg
> >> iwl3945: I iwl3945_rx_handle r = 76, i = 75, REPLY_3945_RX, 0x1b
> >> iwl3945: I iwl3945_rx_handle r = 77, i = 76, REPLY_3945_RX, 0x1b
> >> iwl3945: I iwl3945_mac_tx enter
> >> iwl3945: I iwl3945_tx_skb Dropping - !iwl3945_is_associated
> >> iwl3945: I iwl3945_mac_tx leave
> >> iwl3945: I iwl3945_rx_handle r = 78, i = 77, REPLY_3945_RX, 0x1b
> >> iwl3945: I iwl3945_rx_handle r = 79, i = 78, REPLY_3945_RX, 0x1b
> >
> > When you say "with the same result" does it mean that you comment out
> > the check for priv->assoc_id and you still see the error "Dropping -
> > !iwl3945_is_associated" or do you then see traffic with tcpdump?

I mean that I don't see traffic with tcpdump and I don't see the Dropping 
error.
> >
> > Could you please print out the values of fc, priv->iw_mode,
> > iwl3945_is_associated(priv) and priv->assoc_id just before that error
> > message is printed?

Yes
iwl3945: I iwl3945_tx_skb fc: 8<3>
iwl3945: I iwl3945_tx_skb mode: 2<3>
iwl3945: I iwl3945_tx_skb assoc_id: 0<3>
iwl3945: I iwl3945_tx_skb Dropping - !iwl3945_is_associated
My changes
	IWL_DEBUG_DROP("fc: %d\n", fc);
	IWL_DEBUG_DROP("mode: %d\n", priv->iw_mode);
	IWL_DEBUG_DROP("assoc_id: %d\", priv->assoc_id);
	if ((!iwl3945_is_associated(priv) ||
	    ((priv->iw_mode == IEEE80211_IF_TYPE_STA) && !priv->assoc_id)) &&
	    ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA)) {
		IWL_DEBUG_DROP("Dropping - !iwl3945_is_associated\n");
		goto drop_unlock;
	}
Was it right?
>
> One more question ... did ad-hoc work for you before this patch?

No. In my tests only ipw3945 works in Ad-Hoc mode.
