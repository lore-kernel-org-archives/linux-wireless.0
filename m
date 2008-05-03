Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:6898 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754763AbYECQuw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 May 2008 12:50:52 -0400
Received: by fg-out-1718.google.com with SMTP id 19so1359250fgg.17
        for <linux-wireless@vger.kernel.org>; Sat, 03 May 2008 09:50:48 -0700 (PDT)
To: Mattias Nissler <mattias.nissler@gmx.de>
Subject: Re: Please pull 'upstream' branch of rt2x00
Date: Sat, 3 May 2008 18:56:23 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Scott White <nwi_sub@hotmail.com>,
	linux-wireless@vger.kernel.org
References: <BAY113-W31BC1B2DB0F0597B99310784DA0@phx.gbl> <1209828478.3673.2.camel@johannes.berg> <1209829121.27386.1.camel@localhost>
In-Reply-To: <1209829121.27386.1.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200805031856.24136.IvDoorn@gmail.com> (sfid-20080503_185024_994851_E429F1EC)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 03 May 2008, Mattias Nissler wrote:
> On Sat, 2008-05-03 at 17:27 +0200, Johannes Berg wrote:
> > > Hmm, perhaps we need some way the driver can inform the rate selection
> > > module about statistics. I mean the hardware does measure the number
> > > of failed TX frames, and the number of retries, but it doesn't set them
> > > in the descriptor but in the hardware.
> > 
> > Yes we should have this.
> 
> New rate control algorithm probably. Or even better: Split what is
> currently the rate control algorithm into an link quality estimation
> part (failed frames percentage and such) and the actual rate control
> that interprets that value and acts accordingly.

Hmm, splitting that up would be nice, especially when the driver
will have access to those failed frame percentages directly.
rt2x00 currently keeps track of these statistics to perform link tuning,
I wouldn't be surprised if other drivers also keep similar statistics for
the same reason.

Ivo
