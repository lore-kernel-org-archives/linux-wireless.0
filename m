Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:20237 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387AbYCZJYL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Mar 2008 05:24:11 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH] libertas: convert RSSI to a direct command
Date: Wed, 26 Mar 2008 10:21:13 +0100
References: <200803181342.42704.hs4233@mail.mn-solutions.de> <200803191614.16402.hs4233@mail.mn-solutions.de> <1205940431.4169.10.camel@localhost.localdomain>
In-Reply-To: <1205940431.4169.10.camel@localhost.localdomain>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	libertas-dev@lists.infradead.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200803261021.14066.hs4233@mail.mn-solutions.de> (sfid-20080326_092415_562802_31F26BAE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> My recommendations:
>
> 1) We do need to fix the Ad-Hoc bits somehow, I guess that
> means periodically poking GET_RSSI when connected and
> averaging the result over the last 30 seconds, weighting
> recent results more
>
> 2) Use the windowed average for 'iwconfig'/SIOCGIWSTATS, the
> Ad-Hoc scan result, and scan results on the current channel
>
> 3) Use the default noise floor for all channels not the
> associated channel
>
> If you like, I'm interested in doing this.

That's ok for me.


John W. Linville asked me on IRC about the status of this
patch, as he noticed that this patch isn't acked yet. What
do you think about my "[PATCH, take 2] libertas: convert RSSI to 
a direct command" patch?

It fixed the obvious point 1). From my point of view, 2) and 3) 
are "sugar". It could probably be nice to have this, but in my 
experiments (device sitting on the desk and moving around with 
several APs) it's not really necessary. So 2) and 3) could maybe 
applied as separate patches on top of "take 2".

If you think that the averaging is absolutely needed for AdHoc, 
then I'll revive the old convert-rssi patch that didn't kill the 
averaging. But I think that's not needed.

However, because of my patches from today, the "take 2" doesn't 
apply anymore. But I'll send a "take 3" in a minute :-)
