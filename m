Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:44455 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761234AbaGRK0f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jul 2014 06:26:35 -0400
Received: by mail-la0-f45.google.com with SMTP id ty20so2706610lab.18
        for <linux-wireless@vger.kernel.org>; Fri, 18 Jul 2014 03:26:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1405441966-32681-1-git-send-email-sw@simonwunderlich.de>
References: <1405441966-32681-1-git-send-email-sw@simonwunderlich.de>
Date: Fri, 18 Jul 2014 12:26:33 +0200
Message-ID: <CALhHN=q_EapV6wTpicByf_Ga+qfpFe0edAsdufLSkwLRmhm2-Q@mail.gmail.com> (sfid-20140718_122639_383646_015D0591)
Subject: Re: [RFC 0/2] ath10k spectral scan support
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: Simon Wunderlich <sw@simonwunderlich.de>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	sven@narfation.org, mathias.kretschmer@fokus.fraunhofer.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 15 July 2014 18:32, Simon Wunderlich <sw@simonwunderlich.de> wrote:
> This is the first patchset iteration for review to implement the ath10k
> spectral scan feature. The patchset is still experimental, but we were
> able to detect our analogue 5.8 GHz TV repeater in the sample data. :)
>
> As for ath9k, a proof of concept data plotter has been implemented, and
> is currently available for ath10k in its own branch of FFT_eval [1].
>
Tested this with fft_eval, seems works quite good.
There is small problem with scan timeout, when spectral scan activated
and channels with high load checked, I often hit scan timeout.
Seems we should increase scan timeout in ath10k_start_scan() when
spectral activated.

BR
Janusz
