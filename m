Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:53194 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856Ab1EaHUv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 May 2011 03:20:51 -0400
Received: by gwaa18 with SMTP id a18so1657974gwa.19
        for <linux-wireless@vger.kernel.org>; Tue, 31 May 2011 00:20:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1306823717.9366.3.camel@jlt3.sipsolutions.net>
References: <1305894135-14036-1-git-send-email-rmanoharan@atheros.com>
	<1305894135-14036-6-git-send-email-rmanoharan@atheros.com>
	<1306823717.9366.3.camel@jlt3.sipsolutions.net>
Date: Tue, 31 May 2011 15:20:50 +0800
Message-ID: <BANLkTimotXTy3Lk8CH6LZ3KD=f9iWOtJmw@mail.gmail.com> (sfid-20110531_092054_853681_D3D17A71)
Subject: Re: [PATCH 6/6] mac80211: stop queues before rate control updation
From: Adrian Chadd <adrian@freebsd.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Rajkumar Manoharan <rmanoharan@atheros.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 31 May 2011 14:35, Johannes Berg <johannes@sipsolutions.net> wrote:

> Looks like I completely missed this since you hid it in an ath9k
> patchset. DON'T DO THAT.
>
> Anyway, John, please revert. This is completely useless. Not only is
> abusing the CSA stop reason a show-stopper, the whole patch is also just
> not right, it seems like a workaround around a rate control algorithm
> that isn't able to do an atomic HT change by itself. Also, it won't even
> do what you want, there may be packets being processed concurrently
> while stopping the queue -- calling stop_queues() is no guarantee that
> no packet will be processed afterwards.

I'm unsure of what's going on in mac80211 and ath9k here.

FreeBSD handles it very simply - it goes via ath_reset() which drains
each TX queue, freeing existing packets. Inefficient (ie, packet loss)
but fine for now.

How is ath9k handling the situation where the hardware currently has
HT40 packets queued in the TX queues and you do a 40->20 change?
The 40->20 change in the ath9k instance requires reinit'ing of the
card. What happens to currently queued packets?

Adrian
