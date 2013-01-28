Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:44200 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751334Ab3A1HLp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2013 02:11:45 -0500
Date: Mon, 28 Jan 2013 12:35:02 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: Re: [PATCH] mwl8k: Announcing AP_VLAN suport
Message-ID: <20130128070502.GA442@markyou> (sfid-20130128_081149_113437_75032607)
References: <20130125105121.GA9541@markyou.marvell.com>
 <1359114330.4655.0.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1359114330.4655.0.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> >  	if (priv->ap_macids_supported || priv->device_info->fw_image_ap) {
> >  		hw->wiphy->interface_modes |= BIT(NL80211_IFTYPE_AP);
> > +		hw->wiphy->interface_modes |= BIT(NL80211_IFTYPE_AP_VLAN);
> >  		hw->wiphy->interface_modes |= BIT(NL80211_IFTYPE_STATION);
> 
> Hmm, why is this needed? mac80211 should add it:
> 
>         /* if low-level driver supports AP, we also support VLAN */
>         if (local->hw.wiphy->interface_modes & BIT(NL80211_IFTYPE_AP)) {
>                 hw->wiphy->interface_modes |= BIT(NL80211_IFTYPE_AP_VLAN);
>                 hw->wiphy->software_iftypes |= BIT(NL80211_IFTYPE_AP_VLAN);
>         }
> 
> Is this run too late, i.e. after registering hw? If so, that's a bug.

Hi Johannes,

   We agree with you. There is no need to explicitly set
NL80211_IFTYPE_AP_VLAN support for AP driver. This patch
is redundant.

@John: Please ignore this patch.

Thanks
Yogesh

> 
> johannes
> 
