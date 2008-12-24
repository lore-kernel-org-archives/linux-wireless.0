Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f13.google.com ([209.85.217.13]:34217 "EHLO
	mail-gx0-f13.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbYLXRkl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Dec 2008 12:40:41 -0500
Received: by gxk6 with SMTP id 6so2637000gxk.13
        for <linux-wireless@vger.kernel.org>; Wed, 24 Dec 2008 09:40:40 -0800 (PST)
Message-ID: <43e72e890812240940oa599bdds7db3682bfbf95a49@mail.gmail.com> (sfid-20081224_184054_628824_2509FC7F)
Date: Wed, 24 Dec 2008 09:40:40 -0800
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Fabio Rossi" <rossi.f@inwind.it>
Subject: Re: p54: ad-hoc mode doesn't work
Cc: "Pavel Roskin" <proski@gnu.org>, linux-wireless@vger.kernel.org
In-Reply-To: <200812241828.49679.rossi.f@inwind.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <200812230132.21839.rossi.f@inwind.it> <1230072758.5692.2.camel@dv>
	 <200812241828.49679.rossi.f@inwind.it>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 24, 2008 at 9:28 AM, Fabio Rossi <rossi.f@inwind.it> wrote:
> It seems strange to me, on the other PC I'm using the ath5k driver with a PCI
> wireless NIC and the interface enters in ad-hoc mode without complaining
> (CRDA is not installed).
>
> I'll try to install also CRDA to see if something changes, maybe there is a
> difference between the ath5k and p54 drivers.

Most distributions are using >= 2.6.28 kernels with
CONFIG_WIRELESS_OLD_REGULATORY which means the US is the default
regulatory domain and its built statically into the kernel so the
values are used CRDA does not have to be queried. If CRDA is present
the regulatory domain is just updated with
CONFIG_WIRELESS_OLD_REGULATORY.

To find out the details of your channel configuration install iw and
then do: iw list

http://wireless.kernel.org/en/users/Documentation/iw

For example for my dual band card I get (after running iw reg set US
though) for the frequencies:

                Frequencies:
                        * 2412 MHz
                        * 2417 MHz
                        * 2422 MHz
                        * 2427 MHz
                        * 2432 MHz
                        * 2437 MHz
                        * 2442 MHz
                        * 2447 MHz
                        * 2452 MHz
                        * 2457 MHz
                        * 2462 MHz
                        * 2467 MHz (disabled)
                        * 2472 MHz (disabled)
                        * 2484 MHz (disabled)
                Frequencies:
                        * 5180 MHz
                        * 5200 MHz
                        * 5220 MHz
                        * 5240 MHz
                        * 5260 MHz (radar detection)
                        * 5280 MHz (radar detection)
                        * 5300 MHz (radar detection)
                        * 5320 MHz (radar detection)
                        * 5500 MHz (radar detection)
                        * 5520 MHz (radar detection)
                        * 5540 MHz (radar detection)
                        * 5560 MHz (radar detection)
                        * 5580 MHz (radar detection)
                        * 5600 MHz (radar detection)
                        * 5620 MHz (radar detection)
                        * 5640 MHz (radar detection)
                        * 5660 MHz (radar detection)
                        * 5680 MHz (radar detection)
                        * 5700 MHz (radar detection)
                        * 5745 MHz
                        * 5765 MHz
                        * 5785 MHz
                        * 5805 MHz
                        * 5825 MHz

  Luis
