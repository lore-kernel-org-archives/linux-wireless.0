Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:39526 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585Ab2LQSsi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Dec 2012 13:48:38 -0500
Received: by mail-wi0-f180.google.com with SMTP id hj13so2263213wib.1
        for <linux-wireless@vger.kernel.org>; Mon, 17 Dec 2012 10:48:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20121217132232.GA447@pandem0nium>
References: <1354811768-4414-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	<20121213140753.GA26868@pandem0nium>
	<50CA0F8B.3060905@openwrt.org>
	<20121213220651.GA30855@pandem0nium>
	<50CA5EE9.30606@openwrt.org>
	<CAJ-VmokcJUBZeOAyjaNefqgtEkdjGFhH3NQEXA38Xe_i2M+wYA@mail.gmail.com>
	<CAJ-Vmo=qWihSMZ3Jwb9NGU_uXSGYd-Nxya+oT0MQdoT6r0JZFw@mail.gmail.com>
	<20121217132232.GA447@pandem0nium>
Date: Mon, 17 Dec 2012 10:48:35 -0800
Message-ID: <CAJ-Vmonnc0gT-A2MwpHfctBTAbDDek+0BGZVgRyCWSM5wif9vw@mail.gmail.com> (sfid-20121217_194842_191374_3AE50106)
Subject: Re: [RFCv2] Add spectral scan support for Atheros AR92xx/AR93xx
From: Adrian Chadd <adrian@freebsd.org>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, johannes@sipsolutions.net,
	ath9k-devel@lists.ath9k.org, rodrigue@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, jonbither@gmail.com,
	jouni@qca.qualcomm.com, kgiori@qca.qualcomm.com,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

... did the original mail from me _make_ it to the ath9k list?



Adrian


On 17 December 2012 05:22, Simon Wunderlich
<simon.wunderlich@s2003.tu-chemnitz.de> wrote:
> Hello Adrian,
>
> thank you for posting this and the explanation!
>
> On Sat, Dec 15, 2012 at 08:06:47PM -0800, Adrian Chadd wrote:
>> The formats are as follows. Please note that if a pulse terminates
>> during an FFT, the final entry may be truncated. So yes, you may not
>> always get an integer multiple of the relevant frame length.
>
> OK - my data is mostly in the range of 55-58 bytes (see below), sometimes
> I got some longer packets, but I'm currently dropping them.
> The variation still puzzles me though.
>
>>
>> Note that you shift each of the readings by max_exp to get a total
>> reading. max_index and max_magnitude I think are just derived from the
>> existing dataset; they're just a shortcut for software so it doesn't
>> have to parse the whole frame looking for the peak.
>
> Ah ok, that makes sense. Thanks for the clarification. :)
>>
>> Static 20 mode:
>>
>> 0  bin -28 magnitude[7:0] = (|i| + |q|) >> max_exp
>> 1  bin -27 magnitude[7:0] = (|i| + |q|) >> max_exp
>> 2 - 53  …
>> 54  bin  26 magnitude[7:0] = (|i| + |q|) >> max_exp
>> 55  bin  27 magnitude[7:0] = (|i| + |q|) >> max_exp
>
> I've checked my data again: On my AR9280 in 2.4GHz, I get 55 or 57 bytes plus
> 7 "special bytes" (4 bytes meta info plus 3 bytes "radar trailer?"). In 5 GHz
> and on my AR9380 in both bands, it is always either 56 or 58 bytes. The number
> of bytes comes from rs_datalen from the rx_status struct as found in the patch
> sent earlier.
>
> So to summarise, what I currently get:
>  * 55-58 bytes of "data"
>  * 4 bytes of meta-information (as you provided)
>  * 3 bytes of "radar trailer" (bwinfo and such)
>
> The variation in the data puzzles me, I've already checked bit 4 in bwinfo
> as Felix suggested. Is there any other "header" to the DFS data? Or should I
> just skip the first few bytes and always use the last 55 bytes? At least from the
> distribution, all of these numbers look like normal data and not a bitfield.
> Ideas welcome. :)
>
> I've also noticed that the middle of the data (like data[28]) is usually higher
> than the rest - this might be the carrier, or something alike?
>
>> 56  [7:0]: all bins {max_magnitude[1:0], bitmap_weight[5:0]}
>> 57  [7:0]: all bins  max_magnitude[9:2]
>> 58  [7:0]: all bins {max_index[5:0], max_magnitude[11:10]}
>> 59  [3:0]: max_exp (shift amount to size max bin to 8-bit unsigned)
>>
>> Dynamic 20/40 mode:
>>
>> 0  bin -64 magnitude[7:0] = (|i| + |q|) >> max_exp  or  power (in dBm)
>> 1  bin -63 magnitude[7:0] = (|i| + |q|) >> max_exp  or  power (in dBm)
>> 2 - 125  …
>> 126  bin  62 magnitude[7:0] = (|i| + |q|) >> max_exp  or  power (in dBm)
>> 127  bin  63 magnitude[7:0] = (|i| + |q|) >> max_exp  or  power (in dBm)
>> 128  [7:0]: lower bins {max_magnitude[1:0], bitmap_weight[5:0]}
>> Baseband DFS 2 (Radar) Micro-Architecture
>> 129  [7:0]: lower bins  max_magnitude[9:2]
>> 130  [7:0]: lower bins {max_index[5:0], max_magnitude[11:10]}
>> 131  [7:0]: upper bins {max_magnitude[1:0], bitmap_weight[5:0]}
>> 132  [7:0]: upper bins  max_magnitude[9:2]
>> 133  [7:0]: upper bins {max_index[5:0], max_magnitude[11:10]}
>> 134  [3:0]: max_exp (shift amount to size max bin to 8-bit unsigned)
>
> Thanks again, also for posting the radar packet format! I'll play a little bit more
> with spectral for now ...
>
> Cheers,
>         Simon
>
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.10 (GNU/Linux)
>
> iEYEARECAAYFAlDPHJgACgkQrzg/fFk7axYhoQCgzBT/lTIObkmz7MoishNsDo5l
> yZ0AoIdp5kUjCglz32/HkyfeBmD49729
> =PXP+
> -----END PGP SIGNATURE-----
>
