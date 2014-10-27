Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:59870 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920AbaJ0OS5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Oct 2014 10:18:57 -0400
Received: by mail-wg0-f50.google.com with SMTP id z12so3273683wgg.9
        for <linux-wireless@vger.kernel.org>; Mon, 27 Oct 2014 07:18:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <544E21D4.9020401@neratec.com>
References: <CAOtFK_Ue0xjEaYY3qm0n2Tj=Hnu1dbphupmdZmiouVuGLnktoA@mail.gmail.com>
 <544E21D4.9020401@neratec.com>
From: Adrien Decostre <ad.decostre@gmail.com>
Date: Mon, 27 Oct 2014 15:18:16 +0100
Message-ID: <CAOtFK_XWgBxPNy77XVDc1XbYUkdPSd-Q9wmREN2iL6A8bzFDoQ@mail.gmail.com> (sfid-20141027_151924_657796_E97994C6)
Subject: Re: Questions regarding ath9k and new EN 300 328 regulation
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Zefir,

Thanks a lot for your answer. This helps me a lot.
If I correctly understand, the ability of ath9k to detect all pulses
may also depend of the platform performances. So on an embedded
platform with limited performances, we may observe more pulses losses
than on a more powerful platform. Is this a right statement?

What about the CONFIG_ATH9K_DFS_CERTIFIED build options? Do we need it
to enable the detection of 0.5usec. pulses?

Thanks in advance for your answer.

Best regards

Adrien

On Mon, Oct 27, 2014 at 11:43 AM, Zefir Kurtisi
<zefir.kurtisi@neratec.com> wrote:
> On 10/24/2014 05:23 PM, Adrien Decostre wrote:
>>
>> I am looking for information about the compliancy of the ath9k driver
>> to the EN 300 328 ETSI regulation.
>>
>> Would someone know if ath9k has already been tested for this regulation?
>>
>> Is it needed to enable any specific flag in ath9k to guarantee
>> compliancy to the adaptivity tests described in EN 300 328?
>>
>>
> The pattern detector currently used in ath was initially developed for ath9k when
> EN 300.328 v1.5.1 was released. It passed the ETSI certification in a German lab
> and the source code (besides moving it up in the tree to be also available for
> 10k) was basically not touched ever since.
>
> I did not track all the DFS requirement changes up to the latest v1.9.1 draft, but
> afaik the sole difference relevant for the detector is the reduction of the
> shortest pulses width in the test pattern specification from 0.7 to 0.5us. With
> that, the chance of the current implementation to pass a v1.8 certification
> depends on ath9k's ability to detect the shorter pulses. I did some initial
> measurements years ago to get a rough picture, which showed that the ath9k is
> losing like 30% of the 0.5us pulses (as compared to .7us).
>
> With the patches you referred, YMMV - you would need to perform thorough
> statistical analyses to get an estimate on whether it would pass.
>
> As for the adaptivity tests, they are not part of DFS (see note in 4.9.1) and
> maybe would best fit within the ACS module
> (http://wireless.kernel.org/en/users/Documentation/acs). The current DFS support
> available in ath9k is limited to bare radar detection, which is enabled through
> CONFIG_CFG80211_CERTIFICATION_ONUS.
>
>
> Cheers,
> Zefir
