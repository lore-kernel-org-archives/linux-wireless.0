Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:64505 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072AbZIUTOu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Sep 2009 15:14:50 -0400
Received: by fxm18 with SMTP id 18so286264fxm.17
        for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2009 12:14:52 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Andre K <andrekdeen@gmail.com>
Subject: Re: p54spi: dbm_antsignal value, is it RSSI or dbm?
Date: Mon, 21 Sep 2009 21:04:28 +0200
Cc: linux-wireless@vger.kernel.org
References: <76516bfc0909211119i4362ca35k13fc1f87857fb393@mail.gmail.com>
In-Reply-To: <76516bfc0909211119i4362ca35k13fc1f87857fb393@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200909212104.28665.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 21 September 2009 20:19:35 Andre K wrote:
> Hi all,
> 
> I've been using the new p54spi driver on a couple of n800s. Some specifics:
> Kernel : 2.6.29-omap1
> Wireless-compat: compat-wireless-2009-08-22
> OS: Maemo
> Options:  disabled CONFIG_RFKILL_BACKPORT_LEDS because it didn't compile
> 
> The driver loads and functions normally. However, the values for the
> dbm_antsignal (from RadioTap header), are they RSSI or dbm? Initially
> I thought they were dbm since tcpdump showed negative values, which
> makes sense:
> 
> Tcpdump:
> 14:08:25.312988 4469382526us tsft 2.0 Mb/s 2437 MHz (0x00a0) -49dB
> signal -41dB noise antenna 0 [0x0000000e] Acknowledgment RA:00:1d:e0:3d:5a:53 (oui Unknown)
heh, noise is higher than the signal.

> 14:08:25.313903 4469383345us tsft 1.0 Mb/s 2437 MHz (0x00a0) 4dB
> signal -41dB noise antenna 0 [0x0000000e] 04:c2:08:00:07:07 (oui
> Unknown) Unknown SSAP 0x0a >
> 
> Which shows up the first positive dbm value. Next I set up another
> n800 to broadcast ping packets (using hping3, since busybox's ping
> doesn't allow broadcast).
>
> 14:12:22.066192 13296010370us tsft 1.0 Mb/s 2437 MHz (0x00a0) 87dB
> signal -62dB noise antenna 0 [0x0000000e] IP 192.168.10.11 >
> 192.168.10.255: ICMP echo request, id 6662, seq 40704, length 8
> 14:12:22.092376 13296036864us tsft 18.0 Mb/s 2437 MHz (0x00c0) 82dB
> signal -62dB noise antenna 0 [0x0000000e] IP 192.168.10.11 >
> 192.168.10.255: ICMP echo request, id 6662, seq 40960, length 8
> 14:12:22.094787 13296037678us tsft 1.0 Mb/s 2437 MHz (0x00a0) 112dB
> signal -62dB noise antenna 0 [0x0000000e] IP 192.168.10.11 >
> 192.168.10.255: ICMP echo request, id 6662, seq 40960, length 8
> 
> I get strange dbm values, in the range of 50 - 100dbm, which doesn't
> make much sense.
> 
> Does anyone have an idea what value is being returned and if there is
> an error in the dbm calculation?
>

no, this has been on the TODO list for some time now.

(drivers/net/wireless/p54/txrx.c)
static int p54_rssi_to_dbm(struct p54_common *priv, int rssi)
{
        int band = priv->hw->conf.channel->band;

        if (priv->rxhw != 5)
                return ((rssi * priv->rssical_db[band].mul) / 64 +
                         priv->rssical_db[band].add) / 4;
        else
                /*
                 * TODO: find the correct formula
                 */
                return ((rssi * priv->rssical_db[band].mul) / 64 +
                         priv->rssical_db[band].add) / 4;
}

the .mul & .add values can be retrieved from the p54spi_eeprom.h blob.

0x09, 0x00, 0xad, 0xde,         /* PDR_RSSI_LINEAR_APPROXIMATION_CUSTOM */
        0x0a, 0x01, 0x72, 0xfe, 0x1a, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,

=> translates into: (best viewed with a fixed-width font)
.mul           = 0x010a = 416 (base 10)
.add           = 0xfe72 = -398
.longbow_unkn1 = 0x001a = 26
.longbow_unkn2 = 0x0000 = 0

---

stlc45xx has a completely different phy/rf (longbow - rxhw = 5) and
the specs are not a part of the freely available fw iface documentation.

here's the relevant quote from a Nokia official: "
> If this is so, what's so secret about the values that it needs a
> binary-only tool and hidden storage area? Is there legal issues with
> it (related to the radio device regulations)?

Yes, this is because regulatory requirements. So thank FCC and ETSI
for all this. This causes much grief for all wireless vendors, for
example Intel had to do major changes in iwl3945 firmware for their
mac80211 driver. "
(ref: http://www.mail-archive.com/stlc45xx-devel@garage.maemo.org/msg00021.html )

---

if you need real dBm reading for signal and noise, you have
to some "reverse engineering" on your own or find someone else
with the hardware and some spare time to burn.

Regards,
	Chr
