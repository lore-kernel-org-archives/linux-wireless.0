Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34418 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754879Ab1AVDc7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Jan 2011 22:32:59 -0500
Received: by pzk35 with SMTP id 35so398752pzk.19
        for <linux-wireless@vger.kernel.org>; Fri, 21 Jan 2011 19:32:59 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19770.20402.711305.279934@gargle.gargle.HOWL>
Date: Sat, 22 Jan 2011 09:02:02 +0530
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	"ath9k-devel" <ath9k-devel@lists.ath9k.org>,
	Jouni Malinen <j@w1.fi>
Subject: Re: [RFC/WIP 00/33] ath9k_htc AP mode
In-Reply-To: <19770.18332.859418.283909@gargle.gargle.HOWL>
References: <19768.62903.947245.576431@gargle.gargle.HOWL>
	<201101212226.40435.chunkeey@googlemail.com>
	<19770.18241.787715.680555@gargle.gargle.HOWL>
	<19770.18332.859418.283909@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith wrote:
> Sujith wrote:
> > What about hardware that doesn't report any kind of TX status information at all ?
> > Currently, there is no way to determine whether the frame has actually gone out,
> > all that can be known is that it was pushed to the target.
> 
> Am curious how carl9170 gets the TX status ?
> Is there a separate endpoint ?

I looked a bit into carl9170 and it looks like the TX status
is obtained as incoming data through the CMD endpoint, am I correct ?

And the cookie is used to match the status information with the approporiate
packet ?

Though for ath9k_htc this would mean changes in both the host and FW, the host has to queue
up packets in some kind of queue and process them on reception of status interrupts.
The FW has to be changed to actually deliver the TX status information. :)

It does make it a bit neat to have such a mechanism. And for AP mode, I would think
that it's kinda essential unless someone comes with an ingenious way of solving
the PS race for drivers that don't set IEEE80211_HW_REPORTS_TX_ACK_STATUS. :-)

Sujith
