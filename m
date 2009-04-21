Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:37643 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253AbZDUT4T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Apr 2009 15:56:19 -0400
Subject: Re: Problem with IEEE80211_MONITORING_INTERVAL
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
In-Reply-To: <1240248773.4632.13.camel@johannes.local>
References: <1239837672.11795.46.camel@violet>
	 (sfid-20090416_012123_293746_81110E23)  <1239875168.9737.10.camel@johannes.local>
	 <1240247636.5260.11.camel@localhost.localdomain>
	 <1240248008.4632.10.camel@johannes.local>
	 <1240248385.5260.15.camel@localhost.localdomain>
	 (sfid-20090420_192718_984250_38AB6869)  <1240248773.4632.13.camel@johannes.local>
Content-Type: text/plain
Date: Tue, 21 Apr 2009 20:56:15 +0100
Message-Id: <1240343775.3327.3.camel@localhost.localdomain> (sfid-20090421_215623_171016_458DA260)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> > I can try but I am not home anymore. So no promises. However it keeps
> > happening in a pretty constant rate. Like every 2-5 seconds interval.
> 
> Ok. The thing I don't understand is why the AP would deauth you. And
> with that reason code to boot.
> 
> > Could be the iwlagn driver for 5350 hardware doing something wrong here.
> > And I also forced it to use sw_crypto.
> 
> I suppose I could try 5350. But I see no reason it would influence the
> auth/assoc handshake.

so I have built the latest wireless-testing tree with a new patches sent
by Reinette fixing the DMA issue. So far I have no problems and I am
unable to re-produce it. However this is a different AP and I disabled
the power control feature for now.

I also updated wpa_supplicant and iw to the latest code and assume that
no fix in there silently fixed it for me.

So we are suspecting that this issue was because of me having 3GB of RAM
and running on a 64-bit kernel. Does this makes sense and could be the
problem why it kept failing until I unload the iwlagn driver?

Regards

Marcel


