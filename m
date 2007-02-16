Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dhost002-77.dex002.intermedia.net ([64.78.20.107]:56625 "EHLO
	DHOST002-77.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932438AbXBPQFB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Feb 2007 11:05:01 -0500
From: "Jouni Malinen" <jkm@devicescape.com>
Date: Fri, 16 Feb 2007 08:04:56 -0800
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Jiri Benc <jbenc@suse.cz>
Subject: Re: [PATCH] remove IEEE80211_HW_FRAGLIST flag
Message-ID: <20070216160456.GA6173@instant802.com>
References: <1171569181.5220.60.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1171569181.5220.60.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 15, 2007 at 08:53:01PM +0100, Johannes Berg wrote:
> This patch removes the IEEE80211_HW_FRAGLIST flag as it is neither used
> nor makes sense (since we never submit fragmented frames to the master
> device.)

The reason for this flag was to reduce host CPU load for frame
aggregation (merging multiple frames (skb's) into one frame. It was used
to implement one part of Atheros Super A/G enhancements, but I don't see
those proprietary changes being generic enough to be worth adding into
net/d80211. However, IEEE 802.11n has similar features that may indeed
benefit from this flag. As such, I would not remove it.

-- 
Jouni Malinen                                            PGP id EFC895FA
