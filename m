Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:26181 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757310AbZJGJgN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Oct 2009 05:36:13 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Dan Williams <dcbw@redhat.com>
Subject: Re: [WIP, RFC] libertas: allow scanning via "iw"
Date: Wed, 7 Oct 2009 11:34:49 +0200
Cc: linux-wireless <linux-wireless@vger.kernel.org>
References: <200910061633.08237.hs4233@mail.mn-solutions.de> <1254869377.8034.8.camel@localhost.localdomain>
In-Reply-To: <1254869377.8034.8.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200910071134.49515.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > * signal isn't reported in dBm or mBm. The scan response from
> >   the firmware tells me some "RSSI" value.
> 
> #define MRVDRV_NF_DEFAULT_SCAN_VALUE		(-96)
> #define SCAN_RSSI(RSSI)			(0x100 - ((u8)(RSSI)))
> 
> 	iwe.u.qual.level = SCAN_RSSI(bss->rssi);
> 
> 	rssi = iwe.u.qual.level - MRVDRV_NF_DEFAULT_SCAN_VALUE;
> 
> so it's more or less dBm.

I'm not that sure about that. I made a test and moved with my 
laptop away from an access-point. In the table below you find 
the signal from ipw2200/iwconfig. And in the second column the 
raw "u8 rssi" from libertas' scan response:

