Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:9311 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752128Ab1GYQ1A (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jul 2011 12:27:00 -0400
Message-ID: <4E2D9950.1080404@gnu.org> (sfid-20110725_182707_312253_6232550D)
Date: Mon, 25 Jul 2011 12:26:56 -0400
From: Pavel Roskin <proski@gnu.org>
MIME-Version: 1.0
CC: =?UTF-8?B?UmFmYcWCTWnFgmVja2k=?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] b43: fix invalid memory access in b43_ssb_remove()
References: <20110722220016.15648.30628.stgit@mj.roinet.com>
In-Reply-To: <20110722220016.15648.30628.stgit@mj.roinet.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/22/2011 06:07 PM, Pavel Roskin wrote:
> wldev is freed in b43_one_core_detach() and should not be accessed after
> that call.  Keep wldev->dev in a local variable.
>
> Signed-off-by: Pavel Roskin<proski@gnu.org>
> ---
>
> Linux 3.0 is not affected.  The bug was introduced in 482f0538.

P.S. This needs to be propagated to Linux 3.1.

> -	b43_one_core_detach(wldev->dev);
> +	b43_one_core_detach(dev);

As a long term solution, we probably want a function that takes wldev 
and has "free" in its name, so that the effect is clear.

-- 
Regards,
Pavel Roskin
