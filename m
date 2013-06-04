Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f53.google.com ([209.85.214.53]:42573 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830Ab3FDTnM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jun 2013 15:43:12 -0400
Received: by mail-bk0-f53.google.com with SMTP id mx10so398601bkb.40
        for <linux-wireless@vger.kernel.org>; Tue, 04 Jun 2013 12:43:11 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: "C.B. Wang" <wtwangcb@gmail.com>
Subject: Re: carl9170:5/10 MHz Channel Support on carl9170
Date: Tue, 4 Jun 2013 21:43:06 +0200
Cc: linux-wireless@vger.kernel.org
References: <CAB-Tk70FmmfZOaJnWOubcOrP3MyXebTtrY936_4NROmf_76EZw@mail.gmail.com>
In-Reply-To: <CAB-Tk70FmmfZOaJnWOubcOrP3MyXebTtrY936_4NROmf_76EZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201306042143.06998.chunkeey@googlemail.com> (sfid-20130604_214315_715421_EAFB73ED)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, June 04, 2013 03:20:26 PM C.B. Wang wrote:
> I want to know if the ar9170 chip support 5/10 mhz channels.
Maybe. if you care about it, you'll have to look for clues in
the original vendor driver (otus - was part of the kernel's staging/
directory for < 2.6.39?) and the original vendor firmware 
(ar9170fw - you can find a git-tree @ git.sipsolutions.com).

Anyway, if you need a definitive "yes" or "no", you should
ask Qualcomm Atheros directly. As I can only tell something
about the MAC [which does have a 802.11j Mode. It can be
enabled by setting bit 3 in AR9170_MAC_REG_POWER_STATE_CTRL.]
However, I don't have any information about the PHY/FEM/RF
and BB.
  
> The datasheet says it supports 802.11j, but the carl9170 
> driver does not provide support.
Again, talk to Qualcomm Atheros to find out what needs to be
done in order to support it.

> Also the radio chip ar9104 has tuning range from 2.3-2.5ghz and
> 4.9-6.1ghz,but the driver does not provide any support for these
> super channels.
Some AR9170 devices do indeed support the 4.9 GHz channels
(out of the box). e.g.: 
	Frequencies:
	 * 4920 MHz [-16] (18.0 dBm)
	 * 4940 MHz [-12] (18.0 dBm)
	 * 4960 MHz [-8] (18.0 dBm)
	 * 4980 MHz [-4] (18.0 dBm)
	 * 5040 MHz [8] (18.0 dBm)
	 * 5060 MHz [12] (18.0 dBm)
	 * 5080 MHz [16] (18.0 dBm)

However, the device needs to be calibrated for the frequencies
to use them legally (the Japanese Market). Look in your kernel
logs when the driver is loaded; There should be something like
this:

> ath: EEPROM regdomain: 0x8xyz
> ath: EEPROM indicates we should expect a country code
> ath: doing EEPROM country->regdmn map search
> ath: Country alpha2 being used: JP <--- JaPan

If your country code is not "JP", then you'll have to talk to
the manufacturer.

Regards,
	Chr
