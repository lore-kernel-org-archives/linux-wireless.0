Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60942 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756536Ab0BEJ7H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Feb 2010 04:59:07 -0500
Subject: Re: [PATCH] nl80211: allow adding new station to devices in mesh
 mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: linux-wireless@vger.kernel.org,
	Andrey Yurovsky <andrey@cozybit.com>
In-Reply-To: <1265362748.3613.0.camel@johannes.local>
References: <1265331642-27773-1-git-send-email-cascardo@holoscopio.com>
	 <1265362748.3613.0.camel@johannes.local>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Feb 2010 10:59:02 +0100
Message-ID: <1265363942.3613.1.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-02-05 at 10:39 +0100, Johannes Berg wrote:
> On Thu, 2010-02-04 at 23:00 -0200, Thadeu Lima de Souza Cascardo wrote:
> > When trying to use the NEW_STATION command, it fails with -EINVAL,
> > because there's no STA_SUPPORTED_RATES parameter. However, for mesh
> > mode, this parameter should be NULL. Besides, it requires
> > LISTEN_INTERVAL to be negative. We allow it to be ommited in the STA
> > case too, in which it will be -1.
> > 
> > ---
> > 
> > Hello.
> > 
> > I was trying to use iw station set in mesh mode and found out I wanted
> > to call NEW_STATION.
> 
> Hmm. Can you explain why you want to do that? Mesh usually discovers its
> peers, and you can add paths, but peers doesn't make a whole lot of
> sense to me?

So it's allowed due to commit 155cc9e4b1d60161ee53ffaf2c15b9411f086fa7,
but I don't understand why. Andrey?

johannes

