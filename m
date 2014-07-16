Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from narfation.org ([79.140.41.39]:47966 "EHLO v3-1039.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755689AbaGPIdI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jul 2014 04:33:08 -0400
From: Sven Eckelmann <sven@narfation.org>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: Simon Wunderlich <sw@simonwunderlich.de>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Giori, Kathy" <kgiori@qca.qualcomm.com>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Subject: Re: [RFC 0/2] ath10k spectral scan support
Date: Wed, 16 Jul 2014 10:25:23 +0200
Message-ID: <4111404.UJkIUxkzQm@bentobox> (sfid-20140716_103329_825020_31934BBC)
In-Reply-To: <CA+BoTQmNJuwYpSiXqF8OUuXQULLSdUW+PO4Sz5oNKyaduHMKPg@mail.gmail.com>
References: <1405441966-32681-1-git-send-email-sw@simonwunderlich.de> <CA+BoTQmNJuwYpSiXqF8OUuXQULLSdUW+PO4Sz5oNKyaduHMKPg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 16 July 2014 08:24:58 Michal Kazior wrote:
> >  * So far, we always get 64 bins of fft data in the samples, even if we
> >  
> >    are in HT40 or VHT80 mode. That doesn't seem right, as there should
> >    be more bins for wider channels (e.g. 128 or 256 bins). Is there any
> >    parameter to change in the configuration to get the output from
> >    multiple channels / higher bandwidth?
> 
> Hmm.. I suspect this may be because you use scan command. Scanning
> uses channel list which is programmed with legacy modes a and g
> (implying 20Mhz). Perhaps that's the limiting factor now. Using other
> (wider) modes breaks scan from what I remember but it might be worth
> checking out if it impacts fft bin sizes.

I did the HT80 and HT40 stuff on a single channel in the spectral "background" 
mode. They reports from the firmware (10.1) still only had 64 bins. The HT80 
stuff wasn't tested with the "main" firmware because it refused to switch to 
HT80 mode as AP/Sta.

Kind regards,
	Sven
