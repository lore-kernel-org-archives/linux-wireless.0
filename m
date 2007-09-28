Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail3.sea5.speakeasy.net ([69.17.117.5]:49511 "EHLO
	mail3.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730AbXI1BQo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2007 21:16:44 -0400
Date: Thu, 27 Sep 2007 18:16:30 -0700
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: hostapd: passing sta info struct to drivers?
Message-ID: <20070928011630.GI27241@jm.kir.nu>
References: <1190911599.5021.4.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1190911599.5021.4.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 27, 2007 at 06:46:39PM +0200, Johannes Berg wrote:

> During porting the STA management to nl80211 it turned out that it would
> be much nicer in the kernel if we would always set all the flags on a
> STA that the kernel needs to get from hostapd.

That I might be able to support at least partially by merging together
some operations, but still, I would expect there to be valid scenarios
where it would be useful to be able to just toggle a single flag.

> To implement that, it would be good to simply pass the sta_info
> structure, e.g. we currently have this code:

This is not going to happen. struct sta_info (the one in hostapd) is
internal for the core implementation and the driver wrappers should
never touch it directly, i.e., pointer to this is not passed on purpose.
If changes to the operation between the driver wrapper and kernel is
desired, it will need to be done in a different way.

-- 
Jouni Malinen                                            PGP id EFC895FA
