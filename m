Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:37690 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594Ab0F2AzG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jun 2010 20:55:06 -0400
Received: by gwaa18 with SMTP id a18so2279290gwa.19
        for <linux-wireless@vger.kernel.org>; Mon, 28 Jun 2010 17:55:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201006281747.00128.Sebastian.Smolorz@gmx.de>
References: <201006221651.24853.Sebastian.Smolorz@gmx.de>
	<AANLkTilsEl-smRtQEU8obOO6GDoWzKYHyFYQYO5Lfpps@mail.gmail.com>
	<201006281747.00128.Sebastian.Smolorz@gmx.de>
Date: Mon, 28 Jun 2010 20:55:04 -0400
Message-ID: <AANLkTilyntO2L8LPOd_1BO73PLiDQBNbOv3e10gXI0N8@mail.gmail.com>
Subject: Re: [PATCH 0/2] at76c50x-usb.c: Fix broken authentication process
From: Jason Andryuk <jandryuk@gmail.com>
To: Sebastian Smolorz <Sebastian.Smolorz@gmx.de>
Cc: kalle.valo@iki.fi, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 28, 2010 at 11:46 AM, Sebastian Smolorz
<Sebastian.Smolorz@gmx.de> wrote:
> Jason Andryuk wrote:
>> On Tue, Jun 22, 2010 at 10:51 AM, Sebastian Smolorz
> It does but I must admit that I did not test the direct probing, only the
> authentication.
>
> Which kernel version did you patch?

I used John Linville's wireless-testing tag master-2010-06-24
(2.6.35-rc3).  Your patches were included in the tree.

> The problem is that when probed directly, no (real) bssid is coded in the
> frame, only the multicast address. So with a frame of type
> IEEE80211_STYPE_PROBE_REQ we have no chance to decode the bssid because
> mac80211 doesn't give us the needed information. I think in the case of
> direct probing we are lost, only the authentication works with the patch I
> sent. Another solution would be to change mac80211 but that would be a
> special solution for just one driver. It's questionable if this is a viable
> way. On the other hand it would be great to have a working driver again.

How do you bypass the direct probe and go immediately to
authentication?  NetworkManager/mac80211 tries the direct probe before
authentication.  Without a probe response, mac80211 does not progress
to the actual authentication.

Jason
