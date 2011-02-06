Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.platinumzone24.at ([88.198.159.93]:34919 "EHLO
	mail.platinumzone24.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574Ab1BFOE7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Feb 2011 09:04:59 -0500
Message-ID: <4D4EAA82.5010904@davizone.at>
Date: Sun, 06 Feb 2011 15:04:50 +0100
From: David Gnedt <david.gnedt@davizone.at>
MIME-Version: 1.0
To: Kalle Valo <kvalo@adurom.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Grazvydas Ignotas <notasas@gmail.com>,
	Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
Subject: Re: [PATCH 03/18] wl1251: fix scan behaviour while not associated
References: <4D45A598.20709@davizone.at> <4D45B7BA.9080402@davizone.at> <87d3nbcutc.fsf@purkki.adurom.net>
In-Reply-To: <87d3nbcutc.fsf@purkki.adurom.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 2011-02-01 22:24, schrieb Kalle Valo:
> Now that's a weird problem. I wonder this wasn't reported with the
> fremantle kernels. How often did you see the problem?

My guess is that it doesn't occur with the fremantle kernel because it only
uses the JOIN command when it really wants to associate. (It only does joins on
!is_zero_ether_addr(bssid))
The wireless-testing driver uses the JOIN command more often and doesn't check
for zero BSSID.

> Can you resend the patch with just this part and the accompanying
> defines, please? It's better to have debug messages improvements in a
> separate patch.

Yes, I will do that.
