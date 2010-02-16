Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:33309 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757060Ab0BPVWj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Feb 2010 16:22:39 -0500
Subject: Re: [PATCH] mac80211: give warning if building w/out rate ctrl
 algorithm
From: Marcel Holtmann <marcel@holtmann.org>
To: Andres Salomon <dilinger@collabora.co.uk>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <20100216161656.42079d77@droptest.queued.net>
References: <20100216161656.42079d77@droptest.queued.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Feb 2010 13:21:19 -0800
Message-ID: <1266355279.8849.24.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Andres,

> I discovered that if EMBEDDED=y, one can accidentally build a mac80211 stack
> and drivers w/ no rate control algorithm.  For drivers like RTL8187 that don't
> supply their own RC algorithms, this will cause ieee80211_register_hw to
> fail (making the driver unusable).
> 
> This will tell kconfig to provide a warning if no rate control algorithms
> have been selected.  That'll at least warn the user; users that know that
> their drivers supply a rate control algorithm can safely ignore the
> warning, and those who don't know (or who expect to be using multiple
> drivers) can select a default RC algorithm.

this is not an acceptable policy. You are generating false positives now
for drivers that have been fine before.

Regards

Marcel


