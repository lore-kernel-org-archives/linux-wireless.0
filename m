Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:61895 "HELO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756923AbZLMC2h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Dec 2009 21:28:37 -0500
Received: by ewy19 with SMTP id 19so2312456ewy.21
        for <linux-wireless@vger.kernel.org>; Sat, 12 Dec 2009 18:28:35 -0800 (PST)
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: ext Johannes Berg <johannes@sipsolutions.net>,
	"Coelho Luciano \(Nokia-D\/Helsinki\)" <Luciano.Coelho@nokia.com>,
	"linville\@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 21/31] wl1271: prevent power save entry while not associated
References: <1260531682-4695-1-git-send-email-luciano.coelho@nokia.com>
	<1260531682-4695-22-git-send-email-luciano.coelho@nokia.com>
	<1260532418.2442.129.camel@johannes.local>
	<1260533355.2689.45.camel@wimaxnb.ntc.nokia.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sat, 12 Dec 2009 23:05:50 +0200
In-Reply-To: <1260533355.2689.45.camel@wimaxnb.ntc.nokia.com> (Juuso Oikarinen's message of "Fri\, 11 Dec 2009 14\:09\:15 +0200")
Message-ID: <87aaxn298x.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Juuso Oikarinen <juuso.oikarinen@nokia.com> writes:

> Unfortunately I haven't had the time to investigate this further, but
> for me it did happen after getting de-authenticated from an AP and
> attempting to re-authenticate. While re-authenticating, mac80211
> appeared to request going into power save after transmitting the
> corresponding control messages, preventing the re-authentication from
> succeeding.
>
> My assumption is, that the dynamic power save mechanism is somehow
> getting triggered from the control message exchange - but, as I said, I
> cannot be sure at this point.

I think this was introduced when the master interface was removed.
I'll fix this in mac80211. I have few options how to fix this and I
need to think a bit more about this.

-- 
Kalle Valo
