Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f170.google.com ([209.85.220.170]:40985 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbaACDCi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jan 2014 22:02:38 -0500
Received: by mail-vc0-f170.google.com with SMTP id la4so7717619vcb.1
        for <linux-wireless@vger.kernel.org>; Thu, 02 Jan 2014 19:02:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52C5D438.9050909@broadcom.com>
References: <52A040CE.5040706@schinagl.nl> <CAFXj5xjJ0DTa0Qo1avLboQF-e3TFv3aEr_jjkuZjinwuTzXykQ@mail.gmail.com>
 <52A09B5B.70800@schinagl.nl> <CAGRGNgWBgWqoPUdHSm2OXGb8r-ca5NX2z4_v0eG6oOMgJRd3HQ@mail.gmail.com>
 <52B17973.1000608@broadcom.com> <52B19F38.7060503@redhat.com>
 <52B1CA51.4010202@broadcom.com> <CAGb2v67cnP0yth0xxBKcaW_T2fF+4nP4r6h9NLqy5FV2x=hO=Q@mail.gmail.com>
 <CAGb2v67mmYnyPeOd4Wwp1zHs7EC_Gr+gEdaaMWeKP5z_Z_SVGA@mail.gmail.com>
 <CAGb2v66646-1Sye=Eb04_SoeCGBU064OePcxDi7th1fqU8XfBg@mail.gmail.com>
 <52BD68BA.3080304@broadcom.com> <CAGb2v67Q=q4vyOftb+BLhAYR-6d04dDP3+kY3b88U8_vCvAmgQ@mail.gmail.com>
 <52C570B6.30500@broadcom.com> <CAGb2v650WNnXqRY+PTwqjbo7pBPDvwHEfzvLM6HaLakZ4Nt1JA@mail.gmail.com>
 <52C5D438.9050909@broadcom.com>
From: Chen-Yu Tsai <wens@csie.org>
Date: Fri, 3 Jan 2014 11:02:17 +0800
Message-ID: <CAGb2v66rNFgZHEPC8LBW02NcAh1kR_5Yba6D-u9Vx8p0Hc46tg@mail.gmail.com> (sfid-20140103_040242_329853_F1DD49F7)
Subject: Re: [linux-sunxi] Firmware for Bluetooth (and wifi)
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-sunxi <linux-sunxi@googlegroups.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Julian Calaby <julian.calaby@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Olliver Schinagl <oliver+list@schinagl.nl>, benn@cubietech.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Fri, Jan 3, 2014 at 5:03 AM, Arend van Spriel <arend@broadcom.com> wrote:
> On 01/02/2014 06:09 PM, Chen-Yu Tsai wrote:
>> Hi,
>>
>> On Thu, Jan 2, 2014 at 9:59 PM, Arend van Spriel <arend@broadcom.com> wrote:
>> [snip]
>>> Hi Chen-Yu,
>>>
>>> I confirmed the patch is working with a revision 0 of the device. What
>>> chip revision does it give in your log (need to load brcmfmac with
>>> module parameter debug=4).
>>
>> Mine is revision 1. Managed mode confirmed working.
>
> Which firmware did you use. Can you provide 'hexdump -C' output
> (especially the last part).
>

I used fw_bcm40181a2.bin.

MD5 sum: ce95e81aa95f9dc1a32fb8acf691dbd8  fw_bcm40181a2.bin

Here's the last part of the dump.

root@cubietruck:/lib/firmware/brcm# hexdump -C brcmfmac43362-sdio.bin | tail
00035920  01 bd 32 08 01 00 34 33  33 36 32 61 32 2d 72 6f  |..2...43362a2-ro|
00035930  6d 6c 2f 73 64 69 6f 2d  67 2d 70 6e 6f 2d 70 6b  |ml/sdio-g-pno-pk|
00035940  74 66 69 6c 74 65 72 2d  6b 65 65 70 61 6c 69 76  |tfilter-keepaliv|
00035950  65 2d 77 61 70 69 2d 77  6d 65 2d 70 32 70 20 56  |e-wapi-wme-p2p V|
00035960  65 72 73 69 6f 6e 3a 20  35 2e 39 30 2e 31 39 35  |ersion: 5.90.195|
00035970  2e 38 39 20 43 52 43 3a  20 62 64 31 65 33 65 35  |.89 CRC: bd1e3e5|
00035980  61 20 44 61 74 65 3a 20  4d 6f 6e 20 32 30 31 33  |a Date: Mon 2013|
00035990  2d 30 34 2d 32 32 20 31  37 3a 32 34 3a 34 34 20  |-04-22 17:24:44 |
000359a0  43 53 54 7d 00                                    |CST}.|
000359a5


ChenYu

> Gr. AvS
>
>> Logs:
>> brcmfmac: F1 signature read @0x18000000=0x1591a962
>> brcmfmac: brcmf_sdio_chip_recognition chipid=0xa962 chiprev=1
>> brcmfmac: brcmf_sdio_chip_buscoresetup ccrev=39, pmurev=13, buscore
>> rev/type=10/0x829
>>
>>
>> ChenYu
>>
>
