Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:55887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758122AbYCSTnc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2008 15:43:32 -0400
Subject: Re: [PATCH] libertas: store rssi as an int
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <200803191620.18554.hs4233@mail.mn-solutions.de>
References: <200803181515.15584.hs4233@mail.mn-solutions.de>
	 <1205938267.26119.33.camel@localhost.localdomain>
	 <200803191620.18554.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Wed, 19 Mar 2008 11:39:43 -0400
Message-Id: <1205941183.4169.26.camel@localhost.localdomain> (sfid-20080319_194446_521927_1135E4B2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-03-19 at 16:20 +0100, Holger Schurig wrote:
> > RSSI as defined in 802.11 as a positive 8-bit value; the
> > libertas firmware also reports the RSSI in scan results as a
> > u8.  So I'd suggest a u8 instead of an int; an int isn't the
> > right thing to do here.
> 
> "struct bss_descriptor" has nothing to do with hardware, 
> otherwise you would see __le32 there. Using an "u8" saves us 
> nothing, except we move all u8's at the end of the struct. But 
> this would give us unaligned u8's and some processors have 
> problems with that.

I still don't want an int used for a value that should never be
unsigned...  I don't particularly care what size it is as long as its
unsigned.  Otherwise, we should be calling it RSSI at all.  Either it's
unsigned+RSSI or signed+dBm, but in the signed+dBm case we'd have to
actually _convert_ it to dBm too.

Dan

