Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog137.obsmtp.com ([74.125.149.18]:56412 "EHLO
	na3sys009aog137.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751344Ab2GHNKZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jul 2012 09:10:25 -0400
Received: by lbbgm6 with SMTP id gm6so18336206lbb.19
        for <linux-wireless@vger.kernel.org>; Sun, 08 Jul 2012 06:10:21 -0700 (PDT)
Message-ID: <1341753019.4354.39.camel@cumari.coelho.fi> (sfid-20120708_151028_966531_DA7EF293)
Subject: Re: [PATCH 7/8] wl18xx: don't send static global struct to FW
From: Luciano Coelho <coelho@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, arik@wizery.com
Date: Sun, 08 Jul 2012 16:10:19 +0300
In-Reply-To: <1341740110.4987.4.camel@jlt3.sipsolutions.net>
References: <1341732211-25871-1-git-send-email-coelho@ti.com>
	 <1341732211-25871-8-git-send-email-coelho@ti.com>
	 (sfid-20120708_092401_300367_EF4BD9AD) <1341740110.4987.4.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-07-08 at 11:35 +0200, Johannes Berg wrote:
> So the subject is wrong since "&priv->conf.phy" can hardly be "static
> global", but 
> 
> > We get DMA alignment trouble if the beginning of the struct is
> > unaligned. Allocate memory and send it to FW.
> 
> If this is all about alignment, and
> 
> > +	params = kzalloc(sizeof(*params), GFP_KERNEL);
> 
> kzalloc (which is pointless -- use kmemdup) alignment is sufficient,
> then most likely you could just put "__aligned(4)" or something on the
> conf.phy struct member and not allocate memory at all?

I'll leave this one out for now until Arik has the time to look into it.

Thanks for your comments, Johannes!

--
Luca.

