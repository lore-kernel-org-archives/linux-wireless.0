Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f45.google.com ([209.85.214.45]:47238 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab3IXHTv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Sep 2013 03:19:51 -0400
Received: by mail-bk0-f45.google.com with SMTP id mx11so1520796bkb.18
        for <linux-wireless@vger.kernel.org>; Tue, 24 Sep 2013 00:19:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87mwn2bu0i.fsf@kamboji.qca.qualcomm.com>
References: <1379335757-15180-1-git-send-email-michal.kazior@tieto.com>
	<87mwn2bu0i.fsf@kamboji.qca.qualcomm.com>
Date: Tue, 24 Sep 2013 09:19:50 +0200
Message-ID: <CA+BoTQnxqgz_90+Q8_FhM6PZh8CEW12dOA+ZGqHeYjK=Bbu9wA@mail.gmail.com> (sfid-20130924_091959_475407_81354FAF)
Subject: Re: [RFC 0/4] ath10k: improve RX performance
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath10k@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 24 September 2013 08:42, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> This patchset gives clear RX performance
>> improvement on AP135. Throughput is at least
>> doubled (300mbps -> 600mbps, UDP RX, 2x2).
>>
>> Patches depend on my RFC patch "mac80211: support
>> reporting A-MSDU subframes individually".
>
> Preferably I can apply these changes only after the mac80211 patch goes
> to net-next (to avoid unnecessary rebasing). Is there a way to
> workaround the need for the mac80211 patch in ath10k so that we could
> apply these patches ASAP? And once the mac80211 patch is commited we
> could just remove the workaround in ath10k.

The workaround could be to clear the retransmission flag when
reporting A-MSDU frames individually.


Michał.
