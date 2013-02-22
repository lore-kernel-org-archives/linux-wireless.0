Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60361 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808Ab3BVUYh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2013 15:24:37 -0500
Message-ID: <1361564668.3420.8.camel@jlt4.sipsolutions.net> (sfid-20130222_212445_607625_41EA9FEB)
Subject: Re: [PATCH] ieee80211: mark 802.11 related structs as being 2-byte
 aligned
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 22 Feb 2013 21:24:28 +0100
In-Reply-To: <1361550529-96159-1-git-send-email-nbd@openwrt.org>
References: <1361550529-96159-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-02-22 at 17:28 +0100, Felix Fietkau wrote:
> Regardless of what header features they use, or if they align the IP
> header or not, 802.11 packets from all drivers guarantee a 2-byte
> alignment (and there's a debug WARN_ON in case they don't).
> 
> Annotate packet structs with __aligned(2) to allow the compiler to use
> 16-bit load/store operations on platforms with extremely inefficient
> unaligned access (e.g. MIPS).
> 
> This reduces code size and improves performance on affected platforms
> and causes no binary code change on others.

Applied.

johannes

