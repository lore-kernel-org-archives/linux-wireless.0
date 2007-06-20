Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail1.sea5.speakeasy.net ([69.17.117.3]:36258 "EHLO
	mail1.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbXFTNuV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2007 09:50:21 -0400
Date: Wed, 20 Jun 2007 06:50:00 -0700
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: ieee80211_radar_status?
Message-ID: <20070620135000.GZ5361@jm.kir.nu>
References: <1182296182.3714.19.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1182296182.3714.19.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 20, 2007 at 01:36:21AM +0200, Johannes Berg wrote:

> Is there any documentation for the arguments to ieee80211_radar_status?

Apparently not. It looks like it was only used for reporting a detected
radar and none of the arguments were really used, i.e., it is just a
callback from low-level driver to notify if a radar was detected on the
current channel.

> When moving to nl80211, this shall be handled there, but since we don't
> have anybody using it right now we might as well kill it off completely
> until we need it (again).

This function is called by low-level driver and it would not have
anything to do with nl80211.. The ieee80211_msg_radar type message to
user space would be the one that would need to be replaced.

-- 
Jouni Malinen                                            PGP id EFC895FA
