Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:37246 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550AbZBRIGV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Feb 2009 03:06:21 -0500
Subject: Re: Missing link quality with wireless-testing
From: Marcel Holtmann <marcel@holtmann.org>
To: Jouni Malinen <j@w1.fi>
Cc: Dan Williams <dcbw@redhat.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20090218073104.GA23366@jm.kir.nu>
References: <1234896777.4678.7.camel@californication>
	 <1234899806.29785.35.camel@johannes.local>
	 <1234902294.4678.12.camel@californication>
	 <1234904111.29785.44.camel@johannes.local>
	 <1234904978.4678.31.camel@californication>
	 <1234913132.11832.10.camel@70-5-246-164.pools.spcsdns.net>
	 <1234933059.21412.28.camel@californication>
	 <20090218073104.GA23366@jm.kir.nu>
Content-Type: text/plain
Date: Wed, 18 Feb 2009 09:06:31 +0100
Message-Id: <1234944391.21412.47.camel@californication> (sfid-20090218_090628_180105_6D05F331)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jouni,

> > > Would setting qual->updated |= IW_QUAL_QUAL_INVALID; work for you?  If
> > > some app doesn't handle that, it's totally, completely broken.
> > 
> > does wpa_supplicant handle this value correctly? I actually never
> > checked that.
> 
> No, it doesn't use qual->updated at all. Then again, neither does it
> rely on qual->qual either. The signal level (qual->level) is used first
> and only if that is not available, qual->qual will be used in sorting
> the results.

so it seems the missing value is affecting the details wpa_supplicant is
handing out via its D-Bus interface. I didn't check the code yet to see
what is actually happening or if I just happen to run an outdated
version.

Regards

Marcel


