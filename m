Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:19705 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760581AbYCSTxZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2008 15:53:25 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: libertas-dev@lists.infradead.org
Subject: Re: [RFC] libertas: change quality calculation
Date: Wed, 19 Mar 2008 16:25:39 +0100
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org
References: <200803181510.52726.hs4233@mail.mn-solutions.de> <1205937928.26119.29.camel@localhost.localdomain>
In-Reply-To: <1205937928.26119.29.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200803191625.39210.hs4233@mail.mn-solutions.de> (sfid-20080319_195437_332201_91FFA1D6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > I also found that the average noise floor is -86 dBm, not
> > -96 dBm. So I changed this constant. Maybe this is wrong,
> > what values do your cards report?
>
> When possible, we should use a window-ed average of the cards
> reported noise from beacons or received frames instead of a
> constant, that's a further improvement though.

The changed value of MRVDRV_NF_DEFAULT_SCAN_VALUE is only used to 
magically conjure the missing noise value for scan results, see 
my other mail about this.

Okay, it's also used in the case of a failed GET_RSSI command :-)

> Well, when we had the (badly) averaged array values in there,
> the noise floor was available to the scan reporting.

Something might have been available for scan reporting, but if 
this "something" made sense is a different question. See my 
other mail :-)

> There are tables to map RSSI -> dBm for each part which should
> be in the firmware spec or seen in the driver code.

I didn't see such a table so far, where is it?
