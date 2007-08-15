Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail7.sea5.speakeasy.net ([69.17.117.9]:52411 "EHLO
	mail7.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021AbXHODg4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Aug 2007 23:36:56 -0400
Date: Tue, 14 Aug 2007 20:35:55 -0700
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] hostapd: remove use of ieee80211_msg_wep_frame_unknown_key
Message-ID: <20070815033555.GI1415@jm.kir.nu>
References: <1186781366.17351.8.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1186781366.17351.8.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 10, 2007 at 11:29:26PM +0200, Johannes Berg wrote:

> I just removed it from the kernel because hostapd doesn't really use it.
> Kill all references.

Thanks, applied. The current wireless-dev.git seems to still have code
for this, but since it was not currently used in hostapd, I'm fine with
this patch.

This feature was originally used to allow a station to be disassociated
if it seemed to be using incorrect keys. However, this was causing
interoperability issues with some client implementations and the code
was eventually commented out and this was only used to update a dot11
MIB counters. Consequently, I did not see much point in integrating it
into hostapd and we might as well just remove the TODO item completely
from hostapd.

-- 
Jouni Malinen                                            PGP id EFC895FA
