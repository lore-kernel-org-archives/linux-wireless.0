Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4005 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752171Ab1IXSJf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Sep 2011 14:09:35 -0400
From: "Arend Van Spriel" <arend@broadcom.com>
To: "Pat Erley" <pat-lkml@erley.org>, James <bjlockie@lockie.ca>
cc: "linux-wireless Mailing List" <linux-wireless@vger.kernel.org>
Date: Sat, 24 Sep 2011 11:09:09 -0700
Subject: RE: higher N rates
Message-ID: <400C43189542CE41BC0A5B252FC90136BC0CD260CF@SJEXCHCCR02.corp.ad.broadcom.com> (sfid-20110924_200943_853509_EA6056AB)
References: <4E7D4EC4.2040506@lockie.ca> <4E7DF8BB.1040807@erley.org>
In-Reply-To: <4E7DF8BB.1040807@erley.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> From: linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-
> owner@vger.kernel.org] On Behalf Of Pat Erley
> Sent: zaterdag 24 september 2011 17:35
> 
> On 09/23/2011 11:30 PM, James wrote:
> > $ iw dev wlan0 scan
> >
> > printed this for my N (only) router:
> >
> > Supported rates: 1.0* 2.0* 5.5* 11.0* 18.0 24.0 36.0 54.0
> > Extended supported rates: 6.0 9.0 12.0 48.0
> >
> > Why doesn't it print the higher N rates?
> 
> I may be WAY off base here, but I believe iw dev wlan0 scan reports
> what's shown in the beacons, and not what rates are actually
> negotiable.
> Beacons only directly advertise 'pre-n' rates (the basic 802.11abg
> rates).

I think you pretty close to base here ;-)

> If you look at more of the scan results, you should see something like:
> 
> 	HT capabilities:
> 		Capabilities: 0x11ce
> 			HT20/HT40
> 			SM Power Save disabled
> 			RX HT40 SGI
> 			TX STBC
> 			RX STBC 1-stream
> 			Max AMSDU length: 3839 bytes
> 			DSSS/CCK HT40
> 		Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
> 		Minimum RX AMPDU time spacing: 8 usec (0x06)
> 		HT TX/RX MCS rate indexes supported: 0-15

The 11n rates are expressed in MCS (Modulation and Coding Scheme) rate
indexes, which translate to a bitrate. So it also advertises 11n rates
albeit in a slightly different format.

Gr. AvS

