Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.csie.ntu.edu.tw ([140.112.30.61]:49591 "EHLO
	smtp.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304AbbHDBcW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2015 21:32:22 -0400
Received: from mail-ig0-f178.google.com (mail-ig0-f178.google.com [209.85.213.178])
	(Authenticated sender: b93043)
	by smtp.csie.ntu.edu.tw (Postfix) with ESMTPSA id 6678D23893
	for <linux-wireless@vger.kernel.org>; Tue,  4 Aug 2015 09:32:19 +0800 (CST)
Received: by igk11 with SMTP id 11so83478952igk.1
        for <linux-wireless@vger.kernel.org>; Mon, 03 Aug 2015 18:32:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150803183422.GD21180@ubuntu-hedt>
References: <1437622380-4154-1-git-send-email-wens@csie.org>
 <1437622380-4154-5-git-send-email-wens@csie.org> <20150803183422.GD21180@ubuntu-hedt>
From: Chen-Yu Tsai <wens@csie.org>
Date: Tue, 4 Aug 2015 09:31:58 +0800
Message-ID: <CAGb2v650TmbAtkvK8YWQvzcoxkgB21=Lr6LXZ4uOZe9OGzqSpw@mail.gmail.com> (sfid-20150804_033229_995784_1B430886)
Subject: Re: [PATCH v2 4/5] wireless-regdb: Update 5GHz rules for US
To: Seth Forshee <seth.forshee@canonical.com>
Cc: Chen-Yu Tsai <wens@csie.org>,
	wireless-regdb <wireless-regdb@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 4, 2015 at 2:34 AM, Seth Forshee <seth.forshee@canonical.com> wrote:
> On Thu, Jul 23, 2015 at 11:32:59AM +0800, Chen-Yu Tsai wrote:
>> The FCC increased the maximum conducted transmission power for the
>> U-NII-1 (5150 ~ 5250 MHz) band to 30 dBm or 1 W for master devices
>> and 24 dBm or 250 mW for mobile/portable devices.
>>
>> Effective 6/2/2014.
>>
>> See FCC KDB 905462 D06.
>>
>> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
>> ---
>>  db.txt | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/db.txt b/db.txt
>> index cadd52c..29ba4b6 100644
>> --- a/db.txt
>> +++ b/db.txt
>> @@ -1160,7 +1160,7 @@ country UG: DFS-FCC
>>
>>  country US: DFS-FCC
>>       (2402 - 2472 @ 40), (30)
>> -     (5170 - 5250 @ 80), (17), AUTO-BW
>> +     (5170 - 5250 @ 80), (30), AUTO-BW
>
> The 30 dB limit is for devices in master mode, for clients the limit
> seems to be 250 mW (about 24 dB). Given the TPC requirement for U-NII
> devices the most it could be bumped up to is 21 dB, unless there's some
> other reason I don't know about to keep it at 17 dB.

I suppose we have no way to differentiate between master mode and clients?
I'll drop it down to 24 dBm and add a comment above it.

As for 17 dB, that was the original limit prior to the bump, as seen in
the FCC KDB attachment "905462 D05 802.11 Channel Plans Old Rules v01".

ChenYu
