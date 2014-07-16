Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:48146 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933056AbaGPGZB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jul 2014 02:25:01 -0400
Received: by mail-we0-f181.google.com with SMTP id q59so377337wes.26
        for <linux-wireless@vger.kernel.org>; Tue, 15 Jul 2014 23:24:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1405441966-32681-1-git-send-email-sw@simonwunderlich.de>
References: <1405441966-32681-1-git-send-email-sw@simonwunderlich.de>
Date: Wed, 16 Jul 2014 08:24:58 +0200
Message-ID: <CA+BoTQmNJuwYpSiXqF8OUuXQULLSdUW+PO4Sz5oNKyaduHMKPg@mail.gmail.com> (sfid-20140716_082505_650240_79F8FBD8)
Subject: Re: [RFC 0/2] ath10k spectral scan support
From: Michal Kazior <michal.kazior@tieto.com>
To: Simon Wunderlich <sw@simonwunderlich.de>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Giori, Kathy" <kgiori@qca.qualcomm.com>, sven@narfation.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 15 July 2014 18:32, Simon Wunderlich <sw@simonwunderlich.de> wrote:
> This is the first patchset iteration for review to implement the ath10k
> spectral scan feature. The patchset is still experimental, but we were
> able to detect our analogue 5.8 GHz TV repeater in the sample data. :)

Awesome!


[...]
>  * So far, we always get 64 bins of fft data in the samples, even if we
>    are in HT40 or VHT80 mode. That doesn't seem right, as there should
>    be more bins for wider channels (e.g. 128 or 256 bins). Is there any
>    parameter to change in the configuration to get the output from
>    multiple channels / higher bandwidth?

Hmm.. I suspect this may be because you use scan command. Scanning
uses channel list which is programmed with legacy modes a and g
(implying 20Mhz). Perhaps that's the limiting factor now. Using other
(wider) modes breaks scan from what I remember but it might be worth
checking out if it impacts fft bin sizes.


Michał
