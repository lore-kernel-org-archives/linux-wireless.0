Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53499 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754316Ab0ISBTj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Sep 2010 21:19:39 -0400
Received: by iwn5 with SMTP id 5so3123840iwn.19
        for <linux-wireless@vger.kernel.org>; Sat, 18 Sep 2010 18:19:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AC090B9732AB2B4DB7FF476E907FE6600113431FC4@dnce02.ent.ti.com>
References: <1284575472-19888-1-git-send-email-shahar_levi@ti.com>
 <1284575472-19888-5-git-send-email-shahar_levi@ti.com> <1284578468.1569.29.camel@powerslave>
 <AANLkTimCrCH_yh5y3L8WcfNus9A2RFMCqvK7Xb82VGUL@mail.gmail.com>
 <AC090B9732AB2B4DB7FF476E907FE6600113431B85@dnce02.ent.ti.com>
 <AANLkTinPodQRk8HYDxxZ9BiKJ=-yAg8nybVqGpCqXsa2@mail.gmail.com> <AC090B9732AB2B4DB7FF476E907FE6600113431FC4@dnce02.ent.ti.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Sun, 19 Sep 2010 11:19:19 +1000
Message-ID: <AANLkTin=Mk2P2ak9VAYxN4ehgPMcvKP9J7iEV55WKtx7@mail.gmail.com>
Subject: Re: [PATCH 04/04] wl1271: 11n Support, 11n Kconfig Configurable
To: "Levi, Shahar" <shahar_levi@ti.com>
Cc: Luciano Coelho <luciano.coelho@nokia.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/9/19 Levi, Shahar <shahar_levi@ti.com>:
> I am confuse. If there option that patch isn't applied from a series how we could trust any patches series we send to that list. I would greatly appreciate if you help me to understand and elaborate what it bisection danger. Am I missing something?
> I really appreciate your willingness to help.

Unless people dislike your patches, there's no danger that they won't
all be applied to the kernel.

That said, there are still circumstances when only part of a patch
series like your one will be applied to a kernel. One of these is when
a user is using git bisection to find exactly which commit caused a
particular bug.

So, let's say you upgrade your kernel from 2.6.35 to 2.6.38 and your
wl1271 device now won't connect to an AP running on some random
proprietary hardware. The simplest way to determine exactly which
patch caused this issue is to use git bisect to do a binary search
over the changes between these two kernel versions to determine the
exact patch that broke it. Now, let's assume that, this particular
piece of hardware won't connect to *anything* when 802.11n support is
added, so you've already excluded that from your kernel. If git bisect
decides to leap into the middle of your series, so that 802.11n
support is added before the Kconfig option is added, then 802.11n
support will be unconditionally enabled, and you'll see the symptoms
of that bug, and won't be able to quickly determine whether the bug
existed before the 802.11n patches or after, and git bisect might
wrongly assume that these patches were the cause of the bug.

As such, it's generally regarded as a good idea to introduce Kconfig
options with the code they guard.

Thanks,

-- 

Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
