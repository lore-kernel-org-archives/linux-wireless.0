Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41995 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717Ab0KBPG2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Nov 2010 11:06:28 -0400
Received: by bwz11 with SMTP id 11so5617518bwz.19
        for <linux-wireless@vger.kernel.org>; Tue, 02 Nov 2010 08:06:27 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Ivo Van Doorn <ivdoorn@gmail.com>
Subject: Re: [regression]AP with hostapd 0.7.3 can't receive packets beyond authentication (2.6.36, rt73usb)
Date: Tue, 2 Nov 2010 16:05:36 +0100
Cc: Johannes Stezenbach <js@sig21.net>, Lee <lee-in-berlin@web.de>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	linux-wireless@vger.kernel.org
References: <4CC0D0F6.4080507@web.de> <20101102144625.GA32002@sig21.net> <AANLkTikYDHBSVuMEnUsR7WpPPo8rK0+OBm_Rd-H0znHT@mail.gmail.com>
In-Reply-To: <AANLkTikYDHBSVuMEnUsR7WpPPo8rK0+OBm_Rd-H0znHT@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201011021605.37137.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Am Dienstag 02 November 2010 schrieb Ivo Van Doorn:
> > After studying the code some more, I'm confused by the
> > comment for this code in rt2x00mac_add_interface():
> >
> >         * The BSSID address must only be configured in AP mode,
> >         * however we should not send an empty BSSID address for
> >         * STA interfaces at this time, since this can cause
> >         * invalid behavior in the device.

Configuring the BSSID register in AP mode was added because rt2800 devices
need it in AP mode for hw crypto.

As I stated earlier it seems that older devices (<rt2800?) need the exact
opposite. In order to fix that issue we could work around this problem by
moving the BSSID register setting (in AP mode) into rt2800 and revert rt2x00lib
back to not setting it at all (only upon association).

> > On the contrary I think the BSSID needs to be configured for STA mode
> > since it acts as a receive filter for broadcase/multicast frames.
> > The 802.11 standard says in 7.2.2 Data frames:
> >
> >        A STA uses the contents of the Address 1 field to perform address
> >        matching for receive decisions. In cases where the Address 1 field
> >        contains a group address, the BSSID also is validated to ensure that
> >        the broadcast or multicast originated from a STA in the BSS of which
> >        the receiving STA is a member.
> >
> > The ralinktech.com drivers seem to set the BSSID for STA mode and IBSS mode.
> 
> True, but the comment in rt2x00 says:
>  'empty BSSID address' and 'at this time'
> 
> The legacy drivers from Ralink configure the BSSID, same as rt2x00 driver do,
> when we start the association procedure. This complies with the 802.11 standard
> for filtering the data frames.

Yep, Ivo is correct.

Helmut
