Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.183]:26288 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929AbXKLXxX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Nov 2007 18:53:23 -0500
Received: by py-out-1112.google.com with SMTP id u77so1587213pyb
        for <linux-wireless@vger.kernel.org>; Mon, 12 Nov 2007 15:53:22 -0800 (PST)
Subject: Re: [PATCH 4/4] o80211s: (zd1211rw-mac80211) support for mesh
	interface
From: Luis Carlos Cobo <luisca@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1194689934.7258.66.camel@johannes.berg>
References: <473516f2.15528c0a.7196.3372@mx.google.com>
	 (sfid-20071110_022703_924708_89D9D43C)  <1194689934.7258.66.camel@johannes.berg>
Content-Type: text/plain
Date: Mon, 12 Nov 2007 15:53:19 -0800
Message-Id: <1194911599.6980.107.camel@localhost> (sfid-20071112_235326_949904_6A36DB6E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2007-11-10 at 11:18 +0100, Johannes Berg wrote:
> > +		{ CR_CAM_MODE,			MODE_AP_WDS},
> 
> Shouldn't that depend on the interface type? I.e. set it for WDS/MESH
> but clear it for station so that the station won't ack WDS frames? OTOH,
> it may just as well ack WDS frames for itself...

Yes, it doesn't look like it does any harm.

> 
> > +			zd_mac_config_beacon(hw, conf->beacon);
> > +			kfree_skb(conf->beacon);
> > +			zd_set_beacon_interval(&mac->chip, BCN_MODE_IBSS | 100);
> 
> Does that mean you're hardcoding the beacon interval here while before
> you confused me how we should handle that setting in userspace? :)

I am not sure what are you referring to... anyway, by now I think it's
fine to hard code the beacon interval, but in mac80211 instead of the
driver adding a beacon_int field to ieee80211_if_conf.

-- 
Luis Carlos Cobo Rus       GnuPG ID: 44019B60
cozybit Inc.


