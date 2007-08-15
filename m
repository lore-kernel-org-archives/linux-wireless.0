Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail5.sea5.speakeasy.net ([69.17.117.7]:33637 "EHLO
	mail5.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755990AbXHOD2I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Aug 2007 23:28:08 -0400
Date: Tue, 14 Aug 2007 20:27:01 -0700
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Ed Howland <ed.howland@gmail.com>,
	David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] hostapd: make it work on the latest kernel
Message-ID: <20070815032701.GH1415@jm.kir.nu>
References: <1186780805.17351.3.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1186780805.17351.3.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 10, 2007 at 11:20:05PM +0200, Johannes Berg wrote:
> i802_if_update isn't actually used so remove all code from it, add
> ieee80211_msg_passive_scan as our own constant and #if 0 more code in
> handle_frame()

Thanks, applied. I think that if_update handler can disappear completely
since it was only used in code that was not merged into the hostapd
releases and I don't have plans on merging it in the future. Similarly,
ieee80211_msg_passive_scan should just go away and like the #if 0'ed
blocks (or at least most of them).

Since there are number of pending patches to driver_devicescape.c, I'll
postpone some of the additional cleanup for now, but this will likely
happen once I've had chance of getting through the queue.

-- 
Jouni Malinen                                            PGP id EFC895FA
