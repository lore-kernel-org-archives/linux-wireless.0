Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:35264 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752177AbZHAWOg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Aug 2009 18:14:36 -0400
Message-ID: <4A74BE49.4090909@gmx.de>
Date: Sun, 02 Aug 2009 00:14:33 +0200
From: Joerg Albert <jal2@gmx.de>
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath5k: monitor mode needs channel change
References: <4A72113F.8000604@gmx.de>	 <b6c5339f0907301505yde9e457k4ddc87b1c9120a84@mail.gmail.com>	 <4A73394D.1070200@gmx.de> <b6c5339f0907311140o7e92a74eqf3ad095ac8412281@mail.gmail.com>
In-Reply-To: <b6c5339f0907311140o7e92a74eqf3ad095ac8412281@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/31/2009 08:40 PM, Bob Copeland wrote:

> Hmm, well, probably a ath5k_reset() in add_interface would do the
> trick.  Maybe there's some wrong assumption about when
> configure_filter() is called.

Adding ath5k_reset() to the end of ath5k_add_interface didn't help.

Seems like in the case of

ifconfig wlan0 down
iwconfig wlan0 mode monitor channel 1
ifconfig wlan0 up

ath5k_chan_set() is called by ath5k_config() with sc->curchan == chan
and it doesn't call ath5k_reset() - which I guess is needed
to activate the new hw rx_filter.
ath5k_config() gets parameter changed == 0xffffffff,
i.e. CONF_CHANGE_CHANNEL is flagged.

With the following

iwconfig wlan0 channel 2

ath_chan_set() gets called with
sc->curchan->center_freq != chan->center_freq and
ath5k_reset() is invoked.

Patch follows.

Regards,
Joerg.
