Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42513 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646Ab3AUKCV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jan 2013 05:02:21 -0500
Message-ID: <1358762562.5190.1.camel@jlt4.sipsolutions.net> (sfid-20130121_110225_408156_18D201F4)
Subject: Re: [PATCH] nl80211: allow user-space to determine address for
 P2P_DEVICE
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: Linux Wireless List <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>, Greg Goldman <ggoldman@broadcom.com>,
	Jithu Jance <jithu@broadcom.com>
Date: Mon, 21 Jan 2013 11:02:42 +0100
In-Reply-To: <50FD104F.2090006@broadcom.com>
References: <1357636648-4012-1-git-send-email-arend@broadcom.com>
	 <1358374672.15012.23.camel@jlt4.sipsolutions.net>
	 <50FD104F.2090006@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-01-21 at 10:54 +0100, Arend van Spriel wrote:

> >> +	if (type == NL80211_IFTYPE_P2P_DEVICE && info->attrs[NL80211_ATTR_MAC])
> >> +		nla_memcpy(&params.macaddr[0], info->attrs[NL80211_ATTR_MAC],
> >> +			   ETH_ALEN);
> > 
> > It seems like this might need a capability parameter or something, so
> > wpa_s knows this will take effect. OTOH, wpa_s can query the MAC address
> > afterwards, so it's not really needed, so I applied it.
> 
> Not sure if I can follow. I did submit wpa_s patch for flagging the P2P
> device capability. Are you suggesting an additional flag here to
> indicate whether the MAC address can be configured by wpa_s?

Yes, or maybe it's not needed as wpa_s could read the address back after
the interface is created, and see whether it stuck. Right now, for
example, with mac80211 it wouldn't be used at all.

> > I would also like to see a mac80211 change though to make it take effect
> > there.
> 
> See what I can do. I guess it does involve mac80211 device drivers as
> well, right?

Oh, I think there's no mac80211 driver using P2P device yet. :-) I have
a patch for iwlwifi but I'm not merging it until wpa_s gets "more ready"

johannes

