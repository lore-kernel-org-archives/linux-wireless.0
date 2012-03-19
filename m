Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f51.google.com ([209.85.210.51]:51274 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742Ab2CSEte (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Mar 2012 00:49:34 -0400
Received: by dady9 with SMTP id y9so8916242dad.10
        for <linux-wireless@vger.kernel.org>; Sun, 18 Mar 2012 21:49:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20326.44233.811876.892785@gargle.gargle.HOWL>
References: <1331818214.3432.12.camel@jlt3.sipsolutions.net>
	<8F3AF1C9F856774F8C8D67AA7EDFEC8801E3005E@aphydexd01b>
	<1331902885.6753.10.camel@jlt3.sipsolutions.net>
	<8F3AF1C9F856774F8C8D67AA7EDFEC8801E3040B@aphydexd01b>
	<1332065984.3609.5.camel@jlt3.sipsolutions.net>
	<CAJ-VmomNGku0CNfX+feeeUET4mXEFDj976sSfg-GG-KUSGCWvw@mail.gmail.com>
	<20326.44233.811876.892785@gargle.gargle.HOWL>
Date: Sun, 18 Mar 2012 21:49:33 -0700
Message-ID: <CAJ-VmonSYm6G6Y9zkgwFvEQzDx56q=S6-USPkr7To-drMNh5JA@mail.gmail.com> (sfid-20120319_055006_590946_70F88800)
Subject: Re: mac80211 20/40 coexist
From: Adrian Chadd <adrian@freebsd.org>
To: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"Manoharan, Rajkumar" <rmanohar@qca.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 18 March 2012 20:49, Sujith Manoharan <c_manoha@qca.qualcomm.com> wrote:

>> When are stations being notified of a CWM change?
>>
>> I know FreeBSD handles it with a big stick at the moment - it just
>> does a full interface reset and channel change. I don't necessarily
>> like it, but I haven't yet sat down to look at when and why this is
>> occuring.
>
> For AP mode, we currently don't have dynamic CWM - and if it is ever implemented,
> it would probably be in hostapd.

Right, but for AP mode what's involved?

* Does it send out a CSA to the same channel but different operational
mode stuff?
* are all current aggregation sessions maintained, or are they reset
when a CSA to the same channel is done?
* What about stuff to do with power saving?

>
> For station mode, HT bandwidth changes can be notified via beacons, probe responses
> or action frames. mac80211 currently processes beacons and the HT operation element.

Same deal as above.

I'm ignoring CWM for now until I've finished off these SMP TX
aggregation bugs, then I'll sort out channel scanning and power saving
stuff. That sets all the right "bits" for CWM (ie, being able to queue
all the frames without flushing them, then restarting the software TX
queue as needed.) Once that's done, CWM should be:

* signal stop TX;
* wait for TX threads, TX completion and TX DMA to complete;
* signal a rate control change;
* recalculate the rate control selection for everything in the software queues;
* restart..



Adrian
