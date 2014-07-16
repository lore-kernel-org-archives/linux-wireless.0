Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:43275 "EHLO
	mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760814AbaGPIiN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jul 2014 04:38:13 -0400
From: Simon Wunderlich <sw@simonwunderlich.de>
To: Sven Eckelmann <sven@narfation.org>
Subject: Re: [RFC 0/2] ath10k spectral scan support
Date: Wed, 16 Jul 2014 10:38:09 +0200
Cc: Michal Kazior <michal.kazior@tieto.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	"Giori, Kathy" <kgiori@qca.qualcomm.com>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
References: <1405441966-32681-1-git-send-email-sw@simonwunderlich.de> <CA+BoTQmNJuwYpSiXqF8OUuXQULLSdUW+PO4Sz5oNKyaduHMKPg@mail.gmail.com> <4111404.UJkIUxkzQm@bentobox>
In-Reply-To: <4111404.UJkIUxkzQm@bentobox>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201407161038.10130.sw@simonwunderlich.de> (sfid-20140716_103819_760373_7660271C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> On Wednesday 16 July 2014 08:24:58 Michal Kazior wrote:
> > >  * So far, we always get 64 bins of fft data in the samples, even if we
> > >  
> > >    are in HT40 or VHT80 mode. That doesn't seem right, as there should
> > >    be more bins for wider channels (e.g. 128 or 256 bins). Is there any
> > >    parameter to change in the configuration to get the output from
> > >    multiple channels / higher bandwidth?
> > 
> > Hmm.. I suspect this may be because you use scan command. Scanning
> > uses channel list which is programmed with legacy modes a and g
> > (implying 20Mhz). Perhaps that's the limiting factor now. Using other
> > (wider) modes breaks scan from what I remember but it might be worth
> > checking out if it impacts fft bin sizes.
> 
> I did the HT80 and HT40 stuff on a single channel in the spectral
> "background" mode. They reports from the firmware (10.1) still only had 64
> bins. The HT80 stuff wasn't tested with the "main" firmware because it
> refused to switch to HT80 mode as AP/Sta.

Just to clarify this a little more, we tried AP (running hostapd) as well a 
STA in 40 and 80 MHz modes. We always got 64 bins returned.

Cheers,
    Simon
