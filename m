Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:43872 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755653Ab0F1WzO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jun 2010 18:55:14 -0400
Message-ID: <4C29284C.5050707@openwrt.org>
Date: Tue, 29 Jun 2010 00:55:08 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@lists.ath9k.org
Subject: Re: ath9k: ap tsf seems random and only uses lower 24 bits or so
References: <AANLkTilG4qxjX0e5u_BGp0YcPoVBbsqd6Hlb8E0j_S8S@mail.gmail.com>
In-Reply-To: <AANLkTilG4qxjX0e5u_BGp0YcPoVBbsqd6Hlb8E0j_S8S@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-06-29 12:31 AM, Björn Smedman wrote:
> Hi all,
> 
> I'm getting weird values from the debugfs file ieee80211/phy0/tsf: the
> value goes up and down rather randomly and only the lower 24 bits or
> so seem to ever be used (see below for details).
> 
> The only thing running on phy0 is a single ap interface (and the
> monitor companion that hostapd sets up). I was expecting tsf to
> increase monotonically until all 64 bits had been used.
> 
> For a moment I thought it might be the kernel snprintf (on mips)
> playing a trick on me so I tried the following patch. But the result
> is the same.
IMHO the most likely problem source is stuck beacons. Please compile the
driver with the debug option enabled and load it with
insmod ath9k debug=0x00000100

- Felix
