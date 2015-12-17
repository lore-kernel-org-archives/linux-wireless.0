Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:34803 "EHLO
	mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbbLQJop (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Dec 2015 04:44:45 -0500
Received: by mail-wm0-f50.google.com with SMTP id l126so15137134wml.1
        for <linux-wireless@vger.kernel.org>; Thu, 17 Dec 2015 01:44:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87zixh5rep.fsf@kamboji.qca.qualcomm.com>
References: <1448613438-5173-1-git-send-email-janusz.dziedzic@tieto.com>
	<1448613438-5173-11-git-send-email-janusz.dziedzic@tieto.com>
	<87zixh5rep.fsf@kamboji.qca.qualcomm.com>
Date: Thu, 17 Dec 2015 10:44:43 +0100
Message-ID: <CALhHN=rBpy_u=P4i7ouorz-Z7C-6zHs_uvfuKe5yFKrQQuZ=gA@mail.gmail.com> (sfid-20151217_104451_058722_3A8F5E62)
Subject: Re: [PATCH v2 11/13] ath9k: MCC add sta_ap_ratio module param
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Felix Fietkau <nbd@openwrt.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11 December 2015 at 09:19, Kalle Valo <kvalo@codeaurora.org> wrote:
> Janusz Dziedzic <janusz.dziedzic@tieto.com> writes:
>
>> In case of MCC we can setup STA/AP(GO) ratio.
>> Eg. setting sta_ap_ratio=80
>> STA will get 80% of time, while AP(GO) 20%.
>> Setup correct ctwindow.
>>
>> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
>
> Why? What's the use case?
>
By default beacon_int/2 is used in current implementation.
This patch was developed as a proof of concept in case we would like
to use MCC and need change this 50/50.
Eg, for some reason we need higher BW/ more air time for STA or AP -
depends on case.
For my case STA connection to Gateway was more important that clients
connected to an AP - so just used
70/30.

> And isn't there a better way to do this? Like using nl80211 (via
> wpasupplicant?) or debugfs?
>
I wasn't sure here, but maybe some prio param on the VIF could be used here?
Eg.
VIF1 - prio 50
VIF2 - prio 100

VIF1_time = 50 / (50 + 100) = 33%
VIF2_time = 100 / (50 + 100) = 66%

with some default prio eg. 100.
But for sure this is more work, and I am not sure someone else will need this?

BR
Janusz
> --
> Kalle Valo
