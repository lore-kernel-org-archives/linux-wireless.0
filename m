Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:46262 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329Ab0CTWeQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Mar 2010 18:34:16 -0400
Received: by bwz1 with SMTP id 1so926324bwz.21
        for <linux-wireless@vger.kernel.org>; Sat, 20 Mar 2010 15:34:14 -0700 (PDT)
To: Jouni Malinen <j@w1.fi>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC PATCHv3 0/2] mac80211: cfg80211: Roam trigger support
References: <1268830877-5162-1-git-send-email-juuso.oikarinen@nokia.com>
	<20100317132236.GC2990@tuxdriver.com> <87aau4dcfm.fsf@purkki.valot.fi>
	<20100319145636.GB9552@tuxdriver.com>
	<20100320001520.GA26605@jm.kir.nu>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sun, 21 Mar 2010 00:34:10 +0200
In-Reply-To: <20100320001520.GA26605@jm.kir.nu> (Jouni Malinen's message of "Fri\, 19 Mar 2010 17\:15\:20 -0700")
Message-ID: <87pr2ybp25.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jouni Malinen <j@w1.fi> writes:

> On Fri, Mar 19, 2010 at 10:56:37AM -0400, John W. Linville wrote:
>
>> If you can make wpa_supplicant scan less then I am sold! :-)
>
> I would assume it is not really wpa_supplicant that is triggering too
> many scans for your liking, but NetworkManager..

Yes, I also believe that's the case.

> The goal here (at least from my view point) is to actually make
> wpa_supplicant itself trigger scans more frequently ;-).

Heh, that's the finnish, pessimistic, way of answering to John's
comment :) But as John is from US, we also have to use some optimism
in the answer to not make him too nervous ;)

So the aim is to to scan more when the connection is bad. But if the
connection quality is good enough, wpa_supplicant would not scan at
all. So in some cases scanning is more frequent and in some cases
background scan is completely disabled.

The ultimate goal is to reduce the background scan whenever we can,
for example when connection is good or there's very little or no
traffic at all. But we are nowhere near that yet.

> wpa_supplicant already has a notification function just waiting to be
> called from somewhere when a beacon is lost of signal strength has
> changed.. That somewhere is supposed to be the driver event handler when
> it receives one of these new roam trigger events. At that point,
> wpa_supplicant can then figure out if it should start scanning more
> frequently to find a better BSS.

Very nice.

> I would hope that this feature will make NetworkManager eventually
> stop doing its constant scans

I also hope that this will happen. I think the current setup is just
one big layering violation. After the wifi connection is established,
NetworkManager (nor Connection Manager) should not issue a scan unless
requested by the user.

> (or well, if it doesn't, I will provide an option in for
> wpa_supplicant to ignore D-Bus requests for new scans.. ;-).

That's also one way to do it. But let's hope that we can find a better
solution.

-- 
Kalle Valo
