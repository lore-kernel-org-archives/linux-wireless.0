Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:44951 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754422AbZBXQRb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2009 11:17:31 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Jouni Malinen <jouni.malinen@atheros.com>
Subject: Re: [PATCH] ath9k: Add module parameter to disable hardware crypto
Date: Tue, 24 Feb 2009 17:15:49 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <20090224114201.GB21933@jm.kir.nu>
In-Reply-To: <20090224114201.GB21933@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200902241715.49803.mb@bu3sch.de> (sfid-20090224_171734_587234_14BEAC99)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 24 February 2009 12:42:01 Jouni Malinen wrote:
>  #define CHAN2G(_freq, _idx)  { \
> @@ -1587,7 +1591,7 @@ int ath_attach(u16 devid, struct ath_sof
>  		IEEE80211_HW_SUPPORTS_PS |
>  		IEEE80211_HW_PS_NULLFUNC_STACK;
>  
> -	if (AR_SREV_9160_10_OR_LATER(sc->sc_ah))
> +	if (AR_SREV_9160_10_OR_LATER(sc->sc_ah) || modparam_nohwcrypt)
>  		hw->flags |= IEEE80211_HW_MFP_CAPABLE;

Are you sure this is correct?
The hardware capability doesn't magically change by switching a modparam.
Either the HW is MFP capable or it isn't.

If hwcrypto is disabled (set_key returns error), mac80211 should be smart
enough to do crypto (including MFP) in software anyway.

-- 
Greetings, Michael.
