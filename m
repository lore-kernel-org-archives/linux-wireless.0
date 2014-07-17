Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:41828 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604AbaGQFeI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jul 2014 01:34:08 -0400
Received: by mail-wi0-f175.google.com with SMTP id ho1so7256027wib.14
        for <linux-wireless@vger.kernel.org>; Wed, 16 Jul 2014 22:34:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <3551054.tVFpeBPdYt@bentobox>
References: <1405441966-32681-1-git-send-email-sw@simonwunderlich.de>
	<1405441966-32681-3-git-send-email-sw@simonwunderlich.de>
	<CA+BoTQm1i2UoTtPBf7Z3QLQDBs_1uXwdG8gYOkP556+a7AqcpQ@mail.gmail.com>
	<3551054.tVFpeBPdYt@bentobox>
Date: Thu, 17 Jul 2014 07:34:05 +0200
Message-ID: <CA+BoTQkmG2t1HkF=C6BZC18XjJzuwF3EpxEh-tiNct_BnyP62A@mail.gmail.com> (sfid-20140717_073413_513029_964E7561)
Subject: Re: [RFC 2/2] ath10k: add spectral scan feature
From: Michal Kazior <michal.kazior@tieto.com>
To: Sven Eckelmann <sven@narfation.org>
Cc: Simon Wunderlich <sw@simonwunderlich.de>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Giori, Kathy" <kgiori@qca.qualcomm.com>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 16 July 2014 16:35, Sven Eckelmann <sven@narfation.org> wrote:
> On Wednesday 16 July 2014 11:30:12 Michal Kazior wrote:
[...]
>>
>> What happens when an interface is removed without spectral scan being
>> stopped?
>
> This is a question for the QCA firmware guys.

Not really. My problems is this:
 - have 2 interfaces (vdev 0 and vdev 1)
 - start spectral (using vdev 0 which happens to be the first one)
 - remove 1 interface (vdev 0)

Now spectral scan on vdev 0 is not stopped and if you request to stop
it you effectively call spectral commands with vdev 1 (the other
interface which is the only one left). Yuck. I don't even want to know
how firmware (or different versions and branches of it) handle this
clumsiness.


>> > +int ath10k_spectral_scan_config(struct ath10k *ar, enum spectral_mode
>> > mode) +{
>> > +       int count, ret;
>>
>> We tend to use `res` in ath10k.
>
> Thanks, will be changed. But actually, I found a lot of ret stuff in the
> ath10k code.

Ah, sorry. You're right. I had a brain fart. `ret` is good.


[...]
>> > +       __be16 freq1;
>> > +       __be16 freq2;
>> > +       __be16 noise;
>> > +       __be16 max_magnitude;
>> > +       __be16 total_gain_db;
>> > +       __be16 base_pwr_db;
>> > +       __be64 tsf;
>> > +       s8 max_index;
>> > +       u8 rssi;
>> > +       u8 relpwr_db;
>> > +       u8 avgpwr_db;
>> > +
>> > +       u8 data[SPECTRAL_ATH10K_HT20_NUM_BINS];
>>
>> And as pointed out the size/count of bins is most likely not
>> bandwidth-dependant. It's just a matter of resolution configured with
>> fft_size + bin_scale. Maybe this should be a variable-sized array?
>
> Ok, bin_scale didn't make a difference in my tests (I've just repeated them).
> But 2 ** (fft_size - 1) seems to be relevant. We have to change the format
> accordingly.
>
> But currently we don't see any change in the bandwidth (20MHz/40MHz) for the
> different bin numbers. This has to be checked later in detail.

Yes. Apparently number of bins does *not* change with bandwidth but in
that case I'm guessing bin data does refer to the given bandwidth
which implies different bandwidths end up with different bin data
*resolution*.


Michał
