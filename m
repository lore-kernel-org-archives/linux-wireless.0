Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f103.google.com ([209.85.216.103]:39292 "EHLO
	mail-px0-f103.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620AbZEVSgA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 May 2009 14:36:00 -0400
Received: by pxi1 with SMTP id 1so1477303pxi.33
        for <linux-wireless@vger.kernel.org>; Fri, 22 May 2009 11:36:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <40f31dec0905220646r4dd2fb0ag1e683ae95aab810b@mail.gmail.com>
References: <KK1J00$BAC7E4518757B17D1805E790669D6D1D@libero.it>
	<40f31dec0905220646r4dd2fb0ag1e683ae95aab810b@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 22 May 2009 11:35:42 -0700
Message-ID: <43e72e890905221135v2520c9f1o5c41eb30f4de8913@mail.gmail.com>
Subject: Re: mac80211: TDMA approach feasible?
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: ffileppo <ffileppo@libero.it>, "kalle.valo" <kalle.valo@iki.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Green <Michael.Green@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 22, 2009 at 6:46 AM, Nick Kossifidis <mickflemm@gmail.com> wrote:
> 2009/5/22 ffileppo <ffileppo@libero.it>:
>>
>>> > I was wondering if with mac80211 is now possible (and what effort is
>>> > needed) to implement a TDMA approach. In particular I would like to:
>>> > override 802.11 MPDU frame format, eliminate RTS/CTS exchange,
>>> > eliminate automatic ACK and retransmission, eliminate virtual carrier
>>> > sense (NAV), control PHY clear channel assessment and control
>>> > transmission backoff.
>>>
>>> Most of this is usually implemented in firmware, so you need access to
>>> firmware sources.
>>>
>>
>> Hi,
>> thanks for your answer.
>>
>> If these features are implemented in firmware, it should be possible to modify them if using for example Ath5k (which is a completely FOSS Linux driver) Right? Could you give me any directions?
>>
>> Talking about the TDMA implementation I was wondering if it is possible to achieve a time granularity of 1?s using commercial-of-the-shelf wifi cards (e.g. atheros ones).
>>
>> I would appreciate any ideas or thoughts on this matter.
>>
>> Thank you,
>>
>> Francesco
>>
>
> Check out freebsd they have TDMA support for the ath driver as far as
> i know. It would be cool if we could port it on linux ;-)

And if such support comes around, it would make sense as a separate
driver. You would need also need a way to ensure proper regulatory
compliance.

http://wireless.kernel.org/en/developers/Regulatory

CRDA was designed to be flexible for any wireless technology.

  Luis
