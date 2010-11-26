Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:56270 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751249Ab0KZUuM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Nov 2010 15:50:12 -0500
Date: Fri, 26 Nov 2010 22:50:02 +0200
From: Jouni Malinen <j@w1.fi>
To: Ben Greear <greearb@candelatech.com>
Cc: hostap@lists.shmoo.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] supplicant:  Enable sharing of scan results.
Message-ID: <20101126205002.GA4302@jm.kir.nu>
References: <1289950756-18452-1-git-send-email-greearb@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1289950756-18452-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 16, 2010 at 03:39:16PM -0800, Ben Greear wrote:
> When using multiple VIFs on the same physical radio,
> we can share scan results with sibling interfaces.
> This decreases time it takes to connect many VIFs.

Thanks! This looks reasonable. I did some cleanup and applied it.

Based on a quick test, this seemed to be able to connect over 100
station vifs using WPA2-Personal to a single AP without major problems.
Some resources are running out (just CPU?) that makes some of the 4-way
handshakes fail (timeout?), but after couple of tries, I got 116 of
124 stations connected. This is with all interfaces starting at the
same time; using some more latency there would likely make this quite a
bit more robust.

wpa_supplicant seemed to stop trying to reconnect in some cases, so this
probably triggered some bugs that need to be addressed. Anyway, manual
"wpa_cli -i<ifname> reassociate" on the missing eight vifs was able to
get all the 124 stations connected at the same time.

-- 
Jouni Malinen                                            PGP id EFC895FA
