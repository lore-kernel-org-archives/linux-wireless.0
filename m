Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lunatiki.de ([85.214.70.22]:48478 "EHLO
	h1112006.serverkompetenz.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756424AbYBOAS0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Feb 2008 19:18:26 -0500
From: Patrick Grimm <patrick@lunatiki.de>
To: "Chatre, Reinette" <reinette.chatre@intel.com>
Subject: Re: [HOTFIX] Re: mac80211/iwl4965: ad-hoc broken in 2.6.25-rc1
Date: Fri, 15 Feb 2008 00:40:05 +0100
Cc: linux-wireless@vger.kernel.org
References: <47B1F422.4060501@scherping.de> <D936D925018D154694D8A362EEB0892003A7FB3E@orsmsx416.amr.corp.intel.com> <47B487EE.3030401@scherping.de>
In-Reply-To: <47B487EE.3030401@scherping.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200802150040.05188.patrick@lunatiki.de> (sfid-20080215_001831_496638_6369806B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Donnerstag, 14. Februar 2008 19:26:54 schrieb Richard Scherping:
> Chatre, Reinette schrieb:
> > On Wednesday, February 13, 2008 1:07 AM, Richard Scherping  wrote:
> >>> iwl4965: I iwl4965_tx_skb Dropping - !iwl4965_is_associated:
> >>> iwl4965_is_associated(priv)=1; priv->assoc_id=0;
> >>> priv->assoc_station_added=1
> >>
> >> Simply uncommenting the check for priv->assoc_id to be
> >> non-zero (line 2938 in iwl4965-base.c) made ad-hoc working.
> >> Thanks for helping me to find this!
> >> Does this change have any negative side effects?
> >>
> >> Richard
> >
> > Could you please try the attached patch instead?
>
> Works for me (iwl4965). Thanks!
For me not.
I use 3945ABG card in an ad-hoc network with 4 other wlan devices
like rt2500 and ath5k.
I have applied your
0001-iwlwifi-only-check-for-association-id-when-associat.patch
patch. But i can't see incoming packets witch tcpdump.
I have try to commet out  the check for associat with the same
result. 

dmesg
iwl3945: I iwl3945_rx_handle r = 76, i = 75, REPLY_3945_RX, 0x1b
iwl3945: I iwl3945_rx_handle r = 77, i = 76, REPLY_3945_RX, 0x1b
iwl3945: I iwl3945_mac_tx enter
iwl3945: I iwl3945_tx_skb Dropping - !iwl3945_is_associated
iwl3945: I iwl3945_mac_tx leave
iwl3945: I iwl3945_rx_handle r = 78, i = 77, REPLY_3945_RX, 0x1b
iwl3945: I iwl3945_rx_handle r = 79, i = 78, REPLY_3945_RX, 0x1b

Patrick
