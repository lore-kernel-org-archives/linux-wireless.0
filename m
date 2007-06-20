Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail8.sea5.speakeasy.net ([69.17.117.10]:54867 "EHLO
	mail8.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106AbXFTNll (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2007 09:41:41 -0400
Date: Wed, 20 Jun 2007 06:41:21 -0700
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: ieee80211_set_aid_for_sta?
Message-ID: <20070620134121.GY5361@jm.kir.nu>
References: <1182296370.3714.21.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1182296370.3714.21.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 20, 2007 at 01:39:30AM +0200, Johannes Berg wrote:

> As with the radar stuff, I don't see any users of
> ieee80211_set_aid_for_sta. It seems to be useful when firmware
> establishes sta MAC->AID mapping, but hostapd doesn't handle that
> currently. Remove until we find new hardware requiring it?

hostapd has code for using it, but it is commented out in the open
source version. I don't remember why that was done, but I would assume
it would have required more changes that I did want to do at the point
when merging this from Devicescape version.

Anyway, this was needed with a PrismGT card where the firmware was
indeed taking care of AID selection and then reporting the selected AID
to hostapd. I don't have anything against removing it for now.

-- 
Jouni Malinen                                            PGP id EFC895FA
