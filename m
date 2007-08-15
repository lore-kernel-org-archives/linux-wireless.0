Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail8.sea5.speakeasy.net ([69.17.117.10]:60826 "EHLO
	mail8.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735AbXHODlV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Aug 2007 23:41:21 -0400
Date: Tue, 14 Aug 2007 20:40:19 -0700
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] hostapd: don't reference ieee80211_msg_sta_not_assoc if it's unused anyway
Message-ID: <20070815034019.GJ1415@jm.kir.nu>
References: <1186781881.17351.15.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1186781881.17351.15.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 10, 2007 at 11:38:01PM +0200, Johannes Berg wrote:
> Hostapd doesn't do anything about such frames. Kernel no longer sends
> them and the constant was removed, so let's not reference it any longer.

This is not good.. We should really make sure that deauth/disassoc is
sent out at proper time to avoid clients getting stuck believing that
they are associated.

Why does the kernel no longer send this notification? The current
wireless-dev.git seems to have this still in use and as such, I have not
applied this change into hostapd and would rather not apply it either,
i.e., if there is some need for getting rid of
ieee80211_msg_sta_not_assoc, I would like to see it being done by
providing similar functionality by some other means, not by just
removing this.

-- 
Jouni Malinen                                            PGP id EFC895FA
