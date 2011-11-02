Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:38596 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753213Ab1KBNTi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Nov 2011 09:19:38 -0400
Message-ID: <4EB14365.6000505@openwrt.org> (sfid-20111102_141942_100037_5C58D464)
Date: Wed, 02 Nov 2011 14:19:33 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
CC: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	rodrigue@qca.qualcomm.com, linville@tuxdriver.com
Subject: Re: [PATCH] ath9k: preserve DFS flags in calcrxfilter
References: <1320235803-12190-1-git-send-email-zefir.kurtisi@neratec.com>
In-Reply-To: <1320235803-12190-1-git-send-email-zefir.kurtisi@neratec.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-11-02 1:10 PM, Zefir Kurtisi wrote:
> RX filter flags previously set for DFS radar detection were not
> preserved after "ath9k: disable unnecessary PHY error reporting".
>
> This patch ensures that the flags required for DFS support are
> kept set.
>
> Signed-off-by: Zefir Kurtisi<zefir.kurtisi@neratec.com>
I think preserving the existing register values is a bit fragile wrt. 
hardware resets, register clobbering, etc.
How about just adding an internal flag or bool in the softc?

- Felix
