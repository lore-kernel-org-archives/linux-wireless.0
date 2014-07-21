Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:41754 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754217AbaGUKPg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2014 06:15:36 -0400
Received: by mail-wi0-f178.google.com with SMTP id hi2so3761235wib.17
        for <linux-wireless@vger.kernel.org>; Mon, 21 Jul 2014 03:15:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201407211159.26103.sw@simonwunderlich.de>
References: <1405689992-8538-1-git-send-email-sw@simonwunderlich.de>
	<1405689992-8538-3-git-send-email-sw@simonwunderlich.de>
	<CA+BoTQmrn0ddGe=p_d9+vCpMUMQ6dKhL+DmZ76OicacmxoYVMA@mail.gmail.com>
	<201407211159.26103.sw@simonwunderlich.de>
Date: Mon, 21 Jul 2014 12:15:34 +0200
Message-ID: <CA+BoTQnCLDJYzGDLA-zHcaddY-cyuC48dMwTnoHJP+KYG2tN_Q@mail.gmail.com> (sfid-20140721_121540_063534_C20AABE8)
Subject: Re: [PATCH 2/2] ath10k: add spectral scan feature
From: Michal Kazior <michal.kazior@tieto.com>
To: Simon Wunderlich <sw@simonwunderlich.de>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	"Giori, Kathy" <kgiori@qca.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Sven Eckelmann <sven@narfation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 21 July 2014 11:59, Simon Wunderlich <sw@simonwunderlich.de> wrote:
> Hey Michal,
>
> thanks for the review! I agree to most points and will fixed them in the next
> revision, for the rest I'm putting comments below:
>
> [...]
>> > +       nf_list1 = __le32_to_cpu(event->hdr.nf_list_1);
>> > +       nf_list2 = __le32_to_cpu(event->hdr.nf_list_2);
>> > +       chain_idx = MS(reg0, SEARCH_FFT_REPORT_REG0_FFT_CHN_IDX);
>> > +       switch (chain_idx) {
>> > +       case 0:
>> > +               fft_sample->noise = __cpu_to_be16(nf_list1 & 0xffffu);
>>
>> Are you sure you want to & nf_list1 itself *before* the byte swap? You
>> probably won't see a difference with an intel host system which is
>> little-endian just like the target device.
>
> That is intended as written: with le32_to_cpu() above we get the data into
> host order to process it, then we get the 16-bit noise values according to the
> chain index, and finally convert it to big endian as this is our exchange
> format to userspace - as you can see, we do the same for the other 16bit
> members of fft_sample as well.

Ah, I guess I should put on my glasses now. I parsed that line as
_to_cpu(). Sorry :-)


> [...]
>> > +       arvif = ath10k_get_spectral_vdev(ar);
>> > +       if (!arvif)
>> > +               return -ENODEV;
>> > +       vdev_id = arvif->vdev_id;
>> > +
>> > +       if (ar->spectral_mode == SPECTRAL_DISABLED)
>> > +               return 0;
>> > +
>> > +       res = ath10k_wmi_vdev_spectral_enable(ar, vdev_id,
>> > +
>> > WMI_SPECTRAL_TRIGGER_CMD_CLEAR, +
>> >      WMI_SPECTRAL_ENABLE_CMD_ENABLE); +       if (res < 0)
>> > +               return res;
>> > +
>> > +       res = ath10k_wmi_vdev_spectral_enable(ar, vdev_id,
>> > +
>> > WMI_SPECTRAL_TRIGGER_CMD_TRIGGER, +
>> >        WMI_SPECTRAL_ENABLE_CMD_ENABLE); +       if (res < 0)
>> > +               return res;
>> > +
>> > +       return 0;
>> > +}
>> > +static int ath10k_spectral_scan_config(struct ath10k *ar,
>> > +                                      enum ath10k_spectral_mode mode)
>> > +{
>> > +       struct wmi_vdev_spectral_conf_arg arg;
>> > +       struct ath10k_vif *arvif;
>> > +       int vdev_id, count, res = 0;
>> > +
>>
>> Ditto. lockdep_assert_held().
>
> Actually both functions are calling ath10k_get_spectral_vdev() which already
> has that assert, but it doesn't hurt to put it here as well. Will do. :)

True but those functions (scan_config, scan_trigger) also access
conf_mutex protected data themselves directly. If
ath10k_get_spectral_vdev() was to be changed to not require conf_mutex
you'd have to remember to move lockdep_assert_held() up the call
stack.


>> Did you test this against a firmware crash while spectral scan is
>> enabled? ar->spectral_mode will be left as-is when restart is
>> performed but no spectral scan will be actually configured. You either
>> need to restart spectral scan (better from user perspective) or clear
>> out the old mode (easier to code, but bad from user perspective
>> because suddenly spectral scan would be stopped implicitly by device
>> crash).
>
> No, I didn't test that against a firmware crash yet ...

There's 'simulate_fw_crash' in debugfs. I suggest 'hard' method.
'soft' works only with fw 636 now. Watch out for possible host lockups
though.


> Restarting spectral
> would probably a good idea in endless mode, but not if "count" has been set.

Hmm good point, but then what if you have count=20 and fw crashes in
the middle of performing the spectral scan run (e.g. at iteration 10)?

But then this is just a debug interface (or is it?). I don't know if
it's worth it going to great lengths to provide a super smooth user
experience.


Michał
