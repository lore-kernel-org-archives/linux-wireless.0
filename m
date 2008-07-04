Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.179]:14817 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbYGDLIC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jul 2008 07:08:02 -0400
Received: by ik-out-1112.google.com with SMTP id c28so559681ika.5
        for <linux-wireless@vger.kernel.org>; Fri, 04 Jul 2008 04:08:01 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: rt61 and TSF reporting?
Date: Fri, 4 Jul 2008 13:14:05 +0200
Cc: linux-wireless <linux-wireless@vger.kernel.org>
References: <1214907990.7763.40.camel@johannes.berg> <200807041302.44288.IvDoorn@gmail.com> <1215169362.19862.2.camel@johannes.berg>
In-Reply-To: <1215169362.19862.2.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200807041314.05908.IvDoorn@gmail.com> (sfid-20080704_130807_779153_1BBEECE4)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 04 July 2008, Johannes Berg wrote:
> 
> > I just received an answer from Ralink about this issue,
> 
> Cool.
> 
> > 1.       For 11b/g based chips rt2500, rt2570, rt61, rt73 doesn't implement this.
> 
> Oh, too bad.
> 
> > 2.       For 11n based chips, there is one MAC register have to enable to have this feature.
> > 	  But, Word 2 of RXWI will put the timestamp and the RSSI will put to Word 3.
> > 	 The original Word 3 SNR will disappear and replace by RSSI.
> 
> Nice.
> 
> > As for the timestamps in 2400 and rt2800, they are both in 32bits, so I am not sure how
> > reliable they will be for IBSS.
> 
> Well 32-bits is plenty if you can also read the TSF to extend it to 64,
> b43 only gets 16 by the firmware and we just extend it on packet RX.

Ok, I'll update rt2x00 so rt2400pci can already start reporting the timestamp,
I assume the timestamp reporting is more important then reporting the SNR,
because apparenly for rt2800 we can only get one of those. :S

Ivo
