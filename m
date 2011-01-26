Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51182 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718Ab1AZI3y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jan 2011 03:29:54 -0500
Subject: Re: [PATCH 6/6] ath: Fix WEP hardware encryption
From: Johannes Berg <johannes@sipsolutions.net>
To: Bruno Randolf <br1@einfach.org>
Cc: Jouni Malinen <j@w1.fi>, linville@tuxdriver.com,
	ath5k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org
In-Reply-To: <201101261138.53169.br1@einfach.org>
References: <20110125041522.6944.22566.stgit@localhost6.localdomain6>
	 <20110125041549.6944.15800.stgit@localhost6.localdomain6>
	 <20110125183205.GA29410@jm.kir.nu>  <201101261138.53169.br1@einfach.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 Jan 2011 09:29:48 +0100
Message-ID: <1296030588.3635.12.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-01-26 at 11:38 +0900, Bruno Randolf wrote:

> Even without my patch, WEP does not work with multiple vifs. 
> (As far as i understand it, with WEP the lookup is just done based on the key 
> index in the WLAN header field. mac80211 (or is it hostapd?) sets up both keys 
> for both interfaces with a key index of 0, which causes the lookup to go to 
> the same key for both vifs. I guess mac80211 or hostapd would need to be 
> changed to use different key indices for different vif WEP keys, but then of 
> course we can only use 4 different WEP keys in sum, and not 4 different WEP 
> keys per vif. No big deal imho.)

Are you saying software WEP in mac80211 is broken with multiple VIFs? I
find that hard to believe :-)

johannes

