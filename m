Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:48651 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716AbZH0VBg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Aug 2009 17:01:36 -0400
Received: by ewy2 with SMTP id 2so1603719ewy.17
        for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2009 14:01:37 -0700 (PDT)
Message-ID: <4A96F42C.30501@lwfinger.net>
Date: Thu, 27 Aug 2009 16:01:32 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?R8OhYm9yIFN0ZWZhbmlr?= <netrolller.3d@gmail.com>
CC: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>, Mark Huijgen <mark@huijgen.tk>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] b43: Implement antenna diversity support for LP-PHY
References: <4A96D6D6.3050201@gmail.com>
In-Reply-To: <4A96D6D6.3050201@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gábor Stefanik wrote:
> static void b43_lpphy_op_set_rx_antenna(struct b43_wldev *dev, int antenna)
> {
> -    //TODO
> +    int autodiv = ;
> +
> +    if (dev->phy.rev >= 2)
> +        return; // rev2+ doesn't support antenna diversity
> +
> +    if (B43_WARN_ON(antenna > B43_ANTENNA_AUTO1))
> +        return;
> +
> +    b43_phy_maskset(dev, B43_LPPHY_CRSGAIN_CTL, 0xFFFD, antenna & 0x2);
> +    b43_phy_maskset(dev, B43_LPPHY_CRSGAIN_CTL, 0xFFFE, antenna & 0x1);
> }
> 
> static void b43_lpphy_op_adjust_txpower(struct b43_wldev *dev)

I noticed that your code didn't look like the specs, which is why I
thought the recent changes had affected this section.

It took me a while to figure it out, but the code above is correct.
The part that led to confusion is that the vendor uses 3 to indicate
"start with antenna 0", while you use 2 for that state. Even if we get
it wrong later, it shouldn't matter.

Larry
