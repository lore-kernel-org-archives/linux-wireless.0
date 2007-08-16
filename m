Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail6.sea5.speakeasy.net ([69.17.117.8]:50217 "EHLO
	mail6.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689AbXHPBvN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Aug 2007 21:51:13 -0400
Date: Wed, 15 Aug 2007 18:50:11 -0700
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] hostapd: remove use of ieee80211_msg_wep_frame_unknown_key
Message-ID: <20070816015011.GT1415@jm.kir.nu>
References: <1186781366.17351.8.camel@johannes.berg> <20070815033555.GI1415@jm.kir.nu> <1187174759.3998.8.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1187174759.3998.8.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 15, 2007 at 12:45:59PM +0200, Johannes Berg wrote:
> On Tue, 2007-08-14 at 20:35 -0700, Jouni Malinen wrote:
> > However, this was causing
> > interoperability issues with some client implementations and the code
> > was eventually commented out and this was only used to update a dot11
> > MIB counters. Consequently, I did not see much point in integrating it
> > into hostapd and we might as well just remove the TODO item completely
> > from hostapd.

> I'm not sure whether it'd be worth it going forward anyway, with WEP
> deployments hopefully going down.

I don't think we can enable the original behavior of disassociating a
station based on use of incorrect key index since it can cause problems
with commonly used clients (well, clients that were commonly used four
years ago ;-) and there are also potential issues with opening yet
another DoS problem. If needed, we could have a MIB counter for the
errors updated, but I'm not too concerned about not having this
available.

-- 
Jouni Malinen                                            PGP id EFC895FA
