Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:56417 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262Ab2LAEAy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Nov 2012 23:00:54 -0500
Received: by mail-we0-f174.google.com with SMTP id x10so350710wey.19
        for <linux-wireless@vger.kernel.org>; Fri, 30 Nov 2012 20:00:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1354042885-32688-4-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1354042885-32688-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	<1354042885-32688-4-git-send-email-siwu@hrz.tu-chemnitz.de>
Date: Fri, 30 Nov 2012 20:00:51 -0800
Message-ID: <CAJ-VmommX5JZMZtpmyOSzOZ1Y7YtdsizwpAFMzzCrQ3238RkEw@mail.gmail.com> (sfid-20121201_050058_389491_4E7826D2)
Subject: Re: [RFC 3/3] ath9k: add spectral scan feature
From: Adrian Chadd <adrian@freebsd.org>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net, ath9k-devel@lists.ath9k.org,
	rodrigue@qca.qualcomm.com, zefir.kurtisi@neratec.com,
	kgiori@qca.qualcomm.com, mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Not that I'm specifically getting into this in any deep way right now, but..

On 27 November 2012 11:01, Simon Wunderlich
<simon.wunderlich@s2003.tu-chemnitz.de> wrote:

[snip] - this should apply to AR9380 and later I think.

> +void ar9002_hw_spectral_scan(struct ath_hw *ah)
> +{
> +       struct ath_common *common = ath9k_hw_common(ah);
> +
> +       REG_SET_BIT(ah, AR_PHY_RADAR_0, AR_PHY_RADAR_0_FFT_ENA);
> +
> +       /* NOTE: this will generate a few samples ... lacking documentation,
> +        * I'm not really sure what these parameters mean.
> +        */
> +       REG_SET_BIT(ah, AR_PHY_SPECTRAL_SCAN, AR_PHY_SPECTRAL_SCAN_ENABLE);
> +       REG_SET_BIT(ah, AR_PHY_SPECTRAL_SCAN,
> +                   AR_PHY_SPECTRAL_SCAN_SHORT_REPEAT);
> +       REG_RMW_FIELD(ah, AR_PHY_SPECTRAL_SCAN,
> +                     AR_PHY_SPECTRAL_SCAN_COUNT, 8);
> +       REG_RMW_FIELD(ah, AR_PHY_SPECTRAL_SCAN,
> +                     AR_PHY_SPECTRAL_SCAN_PERIOD, 0xF);
> +       REG_RMW_FIELD(ah, AR_PHY_SPECTRAL_SCAN,
> +                     AR_PHY_SPECTRAL_SCAN_FFT_PERIOD, 0xFF);
> +
> +       /* Activate spectral scan */
> +       REG_SET_BIT(ah, AR_PHY_SPECTRAL_SCAN,
> +                   AR_PHY_SPECTRAL_SCAN_ACTIVE);
> +
> +       /* Poll for spectral scan complete */
> +       if (!ath9k_hw_wait(ah, AR_PHY_SPECTRAL_SCAN,
> +                          AR_PHY_SPECTRAL_SCAN_ACTIVE,
> +                          0, AH_WAIT_TIMEOUT)) {
> +               ath_err(common, "spectral scan wait failed\n");
> +               return;
> +       }
> +
> +       /* Disable spectral scan */
> +       REG_CLR_BIT(ah, AR_PHY_SPECTRAL_SCAN,
> +                   AR_PHY_SPECTRAL_SCAN_ENABLE);
> +}
> +

You shouldn't have to do this. There's two spectral scan modes (well, three) -

* when you're not decoding things, and you meet these parameters,
please send me some events (I think the patent mentions this);
* trigger _now_ and send me "X" events; then clear the spectral scan bit;
* trigger _now_ and just send me infinite events - on earlier chips
(AR9280 I think) the magic value may be 0; on the later values it may
be 255. Someone should experiment.

I suggest you separate out "configure/enable/disable" and "trigger" as options.

Grr, mumble mumble open source developers mumble mumble.. :-)

I suggest experimenting around with those particular parameters. You
should be able to coax out specific numbers of spectral scan events
when you set the COUNT parameter to something other than 8. But
polling that bit isn't needed. It should be asynchronous.

Good luck,



Adrian



Adrian
