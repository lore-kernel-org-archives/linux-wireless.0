Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:57396 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197AbYIGA76 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Sep 2008 20:59:58 -0400
Subject: Re: [PATCH] Ath9k: Add RF kill support.
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Jouni Malinen <Jouni.Malinen@Atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
In-Reply-To: <1220721788.10102.3.camel@johannes.berg>
References: <20080906123842.GA27504@vasanth-lnx.users.atheros.com>
	 <1220721347.6714.114.camel@californication>
	 (sfid-20080906_191538_728310_1EC0FE5D)  <1220721572.10102.0.camel@johannes.berg>
	 (sfid-20080906_192003_595621_9791F144)  <1220721788.10102.3.camel@johannes.berg>
Content-Type: text/plain
Date: Sun, 07 Sep 2008 03:00:16 +0200
Message-Id: <1220749216.6714.122.camel@californication> (sfid-20080907_030003_234543_46BA0FDC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> > > > CONFIG_ATH9K_RFKILL needs to be set
> > > > to enable this support.
> > > 
> > > why do we have to introduce yet another config option for this? What is
> > > the advantage of disabling RFKILL support? I really don't see it and all
> > > these extra config options are rather confusing than useful.
> > 
> > "if EMBEDDED", I think you may want to build a router without rfkill
> > stuff.
> 
> Although I don't like all the select business, can't we just have this
> be an invisible option and make it depend on RFKILL? That way, when
> RFKILL isn't selected, ath9k-rfkill won't be compiled, but if it is, it
> will be, and RFKILL can be "default y" and "if EMBEDDED"

that would be a good compromise. I hate all these extra options that are
basically useless since we enable them anyway. There have already been
various complains about useless options. So at least hide them inside
CONFIG_EMBEDDED if you really think it is worth it. My personal opinion
is that RFKILL support should not be optional. If the hardware supports
it then it should be enabled.

Regards

Marcel


