Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f194.google.com ([74.125.82.194]:41170 "EHLO
	mail-wy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753995Ab1AKUtH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jan 2011 15:49:07 -0500
Received: by wyf23 with SMTP id 23so7204449wyf.1
        for <linux-wireless@vger.kernel.org>; Tue, 11 Jan 2011 12:49:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110111115207.GA28619@jm.kir.nu>
References: <AANLkTi=2N5A0ZBoULj3d0Bp_GeWQouHGFA_LRWWu1k22@mail.gmail.com>
	<20110111115207.GA28619@jm.kir.nu>
Date: Tue, 11 Jan 2011 15:49:06 -0500
Message-ID: <AANLkTin0NYnoki8wD-Q4o33KyNhu8jJwr=LBJx-FCnNF@mail.gmail.com>
Subject: Re: packet injection not working on rt2800usb, ath9k
From: Andy Pyles <andy.pyles@gmail.com>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I do not know about rt2800usb, but monitor mode and packet injection
> works with ath9k. I'm not sure how packetspammer is doing this, but at
> least use of Linux packet socket and simple radiotap header works fine
> in my tests. In addition, it could be useful to update your ath9k driver
> to make sure you are running with all the latest fixes.

Thanks for the tip! After some debugging, it turns out that my
radiotap header is not getting parsed correctly
in ./net/mac80211/tx.c:__ieee80211_parse_tx_radiotap()

Would you mind sending me the radiotap header you are using?
