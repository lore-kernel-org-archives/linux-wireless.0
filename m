Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:53473 "EHLO
	mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754436AbaGUJnM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2014 05:43:12 -0400
From: Simon Wunderlich <sw@simonwunderlich.de>
To: "Yeoh Chun-Yeow" <yeohchunyeow@gmail.com>
Subject: Re: [PATCH 2/2] ath10k: add spectral scan feature
Date: Mon, 21 Jul 2014 11:43:04 +0200
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	mathias.kretschmer@fokus.fraunhofer.de, kgiori@qca.qualcomm.com,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	sven@narfation.org
References: <1405689992-8538-1-git-send-email-sw@simonwunderlich.de> <1405689992-8538-3-git-send-email-sw@simonwunderlich.de> <CAEFj986Vruig8wCP+RLS_gQf8utAirmTDCKwmMGyfj7B2vH9pw@mail.gmail.com>
In-Reply-To: <CAEFj986Vruig8wCP+RLS_gQf8utAirmTDCKwmMGyfj7B2vH9pw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201407211143.04868.sw@simonwunderlich.de> (sfid-20140721_114320_156825_713D68AA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On Fri, Jul 18, 2014 at 9:26 PM, Simon Wunderlich <sw@simonwunderlich.de> 
wrote:
> > Adds the spectral scan feature for ath10k. The spectral scan is triggered
> > by configuring a mode through a debugfs control file. Samples can be
> > gathered via another relay debugfs file.
> > 
> > Essentially, to try it out:
> > 
> > ip link dev wlan0 set up
> 
> It should be "ip link set dev wlan0 up", right?

Whoops, yeah, that's right, I'll change that in the next iteration.
> 
> I have tried to capture the samples on ath10k and open it using fft_eval.
> 
> But found the following errors in my samples "invalid bin length 63".
> 
> I will send the samples in separate email.

Thanks for the output! Could it be that you are using the old RFC patch with 
the new fft-eval? I've added another byte (max_exp), so the header became 
longer. Please try again with the latest patch (from this thread), if that is 
the case. Otherwise we have to find out whats wrong ... The sample_len as used 
in fft_eval (tlv-header + data) should be 93 with that version.

Thanks!
    Simon
