Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.168]:18653 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774AbYECO4s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 May 2008 10:56:48 -0400
Received: by ug-out-1314.google.com with SMTP id h3so312928ugf.16
        for <linux-wireless@vger.kernel.org>; Sat, 03 May 2008 07:56:46 -0700 (PDT)
To: Mattias Nissler <mattias.nissler@gmx.de>
Subject: Re: Please pull 'upstream' branch of rt2x00
Date: Sat, 3 May 2008 17:02:20 +0200
Cc: Scott White <nwi_sub@hotmail.com>, linux-wireless@vger.kernel.org
References: <BAY113-W31BC1B2DB0F0597B99310784DA0@phx.gbl> <200805031158.43072.IvDoorn@gmail.com> <1209809936.10921.9.camel@localhost>
In-Reply-To: <1209809936.10921.9.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200805031702.20416.IvDoorn@gmail.com> (sfid-20080503_165631_067313_B10C7019)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > > For rt73? IIRC the rate selection algo does not work at all for that
> > > device, because we cannot report failed frames. Or have you done
> > > anything about that I might have missed, Ivo? If not, the rate is
> > > probably fixed at 54Mbit anyway.
> > 
> > Well I didn't do anything new, but this line will report rt2x00lib that the
> > frame was succesfully send or failed to send:
> > 	txdesc.status = !urb->status ? TX_SUCCESS : TX_FAIL_RETRY;
> > What is missing is the retry count, since that is something that
> > the USB drivers cannot report. (Unless I grab the max retry count
> > as configured by mac80211 as the number of retries on failure)
> 
> Well, I have just put my rt73 into a metal box. Many frames do fail,
> only very few get through pinging my AP. The rate control still keeps
> the rate at 54Mbit/s :-) So it seems neither excessive_retries nor the
> retry_count in the tx_status struct is set at all.

Hmm, perhaps we need some way the driver can inform the rate selection
module about statistics. I mean the hardware does measure the number
of failed TX frames, and the number of retries, but it doesn't set them
in the descriptor but in the hardware.

Ivo
