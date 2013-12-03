Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f47.google.com ([209.85.215.47]:64805 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257Ab3LCQVY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Dec 2013 11:21:24 -0500
Received: by mail-la0-f47.google.com with SMTP id ep20so9123249lab.6
        for <linux-wireless@vger.kernel.org>; Tue, 03 Dec 2013 08:21:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1386080659.4393.29.camel@jlt4.sipsolutions.net>
References: <1386060648-6020-1-git-send-email-janusz.dziedzic@tieto.com>
	<1386060648-6020-4-git-send-email-janusz.dziedzic@tieto.com>
	<1386080659.4393.29.camel@jlt4.sipsolutions.net>
Date: Tue, 3 Dec 2013 17:21:21 +0100
Message-ID: <CALhHN=q63LmZb7CvO=4sDWf70-O7_vc7T6jhU7gFQNtsH7PuDQ@mail.gmail.com> (sfid-20131203_172127_651567_A13EF95F)
Subject: Re: [PATCH 4/4] nl80211: add VHT support for set_bitrate_mask
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, j@w1.fi
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 3 December 2013 15:24, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2013-12-03 at 09:50 +0100, Janusz Dziedzic wrote:
>> Add VHT mcs support for nl80211_set_tx_bitrate_mask().
>
> Do we really need more fine-grained control than 0-7/8/9? Why do we need
> this at all? :)
>
We need this for test purpose. Need to test different MCS/NSS
configurations using our HW (mainly for VHT).
Our HW supports setting TX fixed_rate for legacy/HT/VHT.
So, we decided to use set_tx_bitrate_mask() as the best interface for
that in nl80211.
And after that we realize VHT implementation/change will be needed in
nl80211/iw also.
Because of that I send this VHT patch.
So, we need this :)

>> +#define NL80211_MAX_SUPP_VHT_RATES           80
>
> Where does 80 come from? That seems odd?
>
NSS_MAX (8) * MCS_MAX (10)

Eg.
9 - NSS=1, MCS=9
10 - NSS=2, MCS=0
11 - NSS=2, MCS=1
...

>> + * @NL80211_TXRATE_VHT_MCS: VHT (MCS) rates allowed for TX rate selection
>> + *   in an array of MCS numbers.
>
> VHT has no "MCS numbers", so this doesn't make much sense?
>
You mean description only or mcs mask for vht (like above)?

>>               if (mask.control[band].legacy == 0) {
>> -                     /* don't allow empty legacy rates if HT
>> +                     /* don't allow empty legacy rates if HT and VHT
>>                        * is not even supported. */
>
> probably should say "are not" now :)
>
yes you right :)

> johannes
>
