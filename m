Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:22955 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935909AbYCFU4O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Mar 2008 15:56:14 -0500
Received: by nf-out-0910.google.com with SMTP id g13so46096nfb.21
        for <linux-wireless@vger.kernel.org>; Thu, 06 Mar 2008 12:55:53 -0800 (PST)
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [RFC] RCPI support in radiotap and in our wireless subsystems
Date: Thu, 6 Mar 2008 21:55:17 +0100
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	radiotap@mail.ojctech.com,
	"Ivan Seskar" <Seskar@winlab.rutgers.edu>,
	"Haris Kremo" <harisk@winlab.rutgers.edu>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Simon Barber" <simon@devicescape.com>,
	"Dan Williams" <dcbw@redhat.com>,
	"Luis Carlos Cobo" <luisca@cozybit.com>,
	"Javier Cardona" <javier@cozybit.com>,
	"Sam Leffler" <sam@errno.com>, "Jean Tourrilhes" <jt@hpl.hp.com>,
	"Stefano Brivio" <stefano.brivio@polimi.it>,
	"Johannes Berg" <johannes@sipsolutions.net>
References: <43e72e890803061238u50847f1fs587627c5fac028d6@mail.gmail.com>
In-Reply-To: <43e72e890803061238u50847f1fs587627c5fac028d6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200803062155.19725.IvDoorn@gmail.com> (sfid-20080306_205624_607486_E69A88CD)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi.

> ---
> 
> For ipw2200:
> 
> s8 antsignal = frame->rssi_dbm - IPW_RSSI_TO_DBM;
> 
> and IPW_RSSI_TO_DBM is set to 112.
> 
> Is antsignal above the "measure by the PHY sublayer of the received RF
> power in the channel measured over the entire received frame"?

For completeness, the rt2x00 & RSSI:

rt2400pci, rt2500pci, rt2500usb:
Same as ipw2200 only the IPW_RSSI_TO_DBM varies from 100 to 120 (as
hardcoded value in the register) to a unsigned char value read from
the EEPROM. The legacy drivers _suggest_ this is the rssi...

rt61pci, rt73usb:
The device reports an agc value, this is used as basis for a vague calculation
to determine the RSSI_TO_DBM offset based on LNA and current operating band.
Here too, the legacy driver suggests this is the rssi...

Ivo
