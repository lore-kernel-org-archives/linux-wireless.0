Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.29]:54345 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbZFIS0K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2009 14:26:10 -0400
Received: by yw-out-2324.google.com with SMTP id 5so100687ywb.1
        for <linux-wireless@vger.kernel.org>; Tue, 09 Jun 2009 11:26:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1244561607-6304-1-git-send-email-tobias.doerffel@gmail.com>
References: <20090607150755.GA19635@hash.localnet>
	 <1244561607-6304-1-git-send-email-tobias.doerffel@gmail.com>
Date: Tue, 9 Jun 2009 14:26:12 -0400
Message-ID: <b6c5339f0906091126k573b8725hf623367abcdcdf1f@mail.gmail.com>
Subject: Re: [PATCH] ath5k: added cfg80211 based rfkill support
From: Bob Copeland <me@bobcopeland.com>
To: Tobias Doerffel <tobias.doerffel@gmail.com>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 9, 2009 at 11:33 AM, Tobias
Doerffel<tobias.doerffel@gmail.com> wrote:

> +config ATH5K_RFKILL
> +       bool "Atheros 5xxx rfkill support"
> +       depends on ATH5K
> +       default y
> +       ---help---
> +         Include support for enabling/disabling WiFi via rfkill switch
> +         with Atheros 5xxx cards
> +

We can still drop this.

> +       /* enable interrupt for rfkill switch */
> +       if (AR5K_EEPROM_HDR_RFKILL(ah->ah_capabilities.cap_eeprom.ee_header)) {
> +               ath5k_rfkill_set_intr(sc, true);
> +       }

Coding style...

> +       if (AR5K_EEPROM_HDR_RFKILL(ah->ah_capabilities.cap_eeprom.ee_header)) {
> +               ath5k_rfkill_set_intr(sc, false);
> +       }

Ditto..

> +       /* enable RFKILL when stopping HW so Wifi LED is turned off */
> +       ath5k_rfkill_enable(sc);

Odd, but ok :)

This looks really close and the remaining changes are pretty small.  If
you want, I can take care of the above and resubmit it with your s-o-b
so you don't have to go through another respin.

-- 
Bob Copeland %% www.bobcopeland.com
