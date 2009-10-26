Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:63772 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755316AbZJZJ2e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2009 05:28:34 -0400
Received: by fg-out-1718.google.com with SMTP id d23so999628fga.1
        for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2009 02:28:38 -0700 (PDT)
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: ext Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Oikarinen Juuso \(Nokia-D\/Tampere\)" <juuso.oikarinen@nokia.com>
Subject: Re: [RFC 1/3] mac80211: WIP - add operating BSSID to device configuration struct
References: <1255696042-28413-1-git-send-email-luciano.coelho@nokia.com>
	<1255696042-28413-2-git-send-email-luciano.coelho@nokia.com>
	<1256201719.12174.19.camel@johannes.local>
	<4AE291DC.3010505@nokia.com> <87pr8ah7pi.fsf@purkki.valot.fi>
	<4AE56792.8080401@nokia.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Mon, 26 Oct 2009 11:28:36 +0200
In-Reply-To: <4AE56792.8080401@nokia.com> (Luciano Coelho's message of "Mon\, 26 Oct 2009 11\:10\:42 +0200")
Message-ID: <87ljiyh5bv.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luciano Coelho <luciano.coelho@nokia.com> writes:

>>> As we discussed on IRC, it is really needed.  We must always provide a
>>> BSSID when changing channels in preparation for an association.
>>
>> I'm not sure about the must part here. Maybe we can workaround it by
>> using ff:ff:ff:ff:ff bssid during authentication and association and
>> send a new join command after association. But that's not a clean
>> solution.
>
> During one of our camps with TI, they told us that we must send the
> correct BSSID, otherwise we are going to have some side-effects.  At
> least BT coext will be affected.  And we have also seen the firmware
> send probe_reqs to ff:ff:ff:ff:ff:ff, which was causing problems.
> The firmware is simply not designed to do this. 

So wl1271 sends a probe request in every join command?

> You probably also remember that we have recently removed extra joins
> from the wl1251 code as well, because they were causing some
> problems.

I think in wl1251 we would be able to workaround this with a careful
placement of join and disconnect commands, but it would be really
complicated. Having proper support in mac80211 is much better choice.

-- 
Kalle Valo
