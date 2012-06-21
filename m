Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47935 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755113Ab2FUHHD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jun 2012 03:07:03 -0400
Message-ID: <1340262417.4489.2.camel@jlt3.sipsolutions.net> (sfid-20120621_090708_151964_DB6F7AE0)
Subject: Re: [PATCH v2 5/7] nl80211/cfg80211: add ap channel switch
 command/event
From: Johannes Berg <johannes@sipsolutions.net>
To: "Goldenshtein, Victor" <victorg@ti.com>
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, zefir.kurtisi@neratec.com,
	adrian.chadd@gmail.com, j@w1.fi, coelho@ti.com, assaf@ti.com,
	yoni.divinsky@ti.com, igalc@ti.com, adrian@freebsd.org,
	nbd@nbd.name, simon.wunderlich@s2003.tu-chemnitz.de
Date: Thu, 21 Jun 2012 09:06:57 +0200
In-Reply-To: <CAK80WHabv2ajEKREHLgnrezs7ydjpyOXWq7DNQOtdaA0WsCELA@mail.gmail.com>
References: <1340111463-4554-1-git-send-email-victorg@ti.com>
	 <1340111463-4554-5-git-send-email-victorg@ti.com>
	 <1340182072.4655.41.camel@jlt3.sipsolutions.net>
	 <CAK80WHYpxpPftCcO0+Uv4meZOg7h5Ys1GfJFg2SQDf3AiiJMNg@mail.gmail.com>
	 <1340213979.4655.78.camel@jlt3.sipsolutions.net>
	 <CAK80WHabv2ajEKREHLgnrezs7ydjpyOXWq7DNQOtdaA0WsCELA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-06-21 at 08:35 +0300, Goldenshtein, Victor wrote:

> > Well, you'll have to move the struct definition into cfg80211 and into
> > this patch I think.
> >
> 
> The STA channel switch struct (struct ieee80211_channel_switch) is
> defined in mac80211.h, thus I think the new struct for the ap channel
> switch should be also there, I will just split the mac patch into two.

You can't use mac80211 structs from cfg80211 though, and for STA channel
switch cfg80211 isn't involved ... you do need to move the struct
definition :)

johannes

