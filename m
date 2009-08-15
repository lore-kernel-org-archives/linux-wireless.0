Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:58741 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752776AbZHOXHl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Aug 2009 19:07:41 -0400
From: Michael Buesch <mb@bu3sch.de>
To: =?utf-8?q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>
Subject: Re: [PATCH v2] b43: LP-PHY: Update baseband init for recent spec changes
Date: Sun, 16 Aug 2009 01:07:35 +0200
Cc: John Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Mark Huijgen <mark@huijgen.tk>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <4A873F20.4020705@gmail.com>
In-Reply-To: <4A873F20.4020705@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200908160107.35992.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 16 August 2009 01:05:04 Gábor Stefanik wrote:
> The spec had some nasty typos, and a large part of the rev0/1 BB
> init procedure was also missing. Fix these.
> 
> Also make the init-time channel switch debuggable.
> 
> (The change from -EINVAL to -EIO is simply to make it possible
> to distinguish the PLL charge pump error from a channel-not-found
> error.)
> 
> Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
> ---
> V2: Coding style fix suggested by Michael on IRC.

> +	if (err)
> +		b43dbg(dev->wl, "Switch to init channel failed, error = %d.\n",
> +		       err);

Here's still one, but otherwise acked.

-- 
Greetings, Michael.
