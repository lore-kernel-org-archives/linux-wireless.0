Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f172.google.com ([209.85.214.172]:35424 "EHLO
	mail-iw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085Ab0LGXSx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 18:18:53 -0500
Received: by iwn40 with SMTP id 40so553868iwn.3
        for <linux-wireless@vger.kernel.org>; Tue, 07 Dec 2010 15:18:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20101207194646.GG2700@tuxdriver.com>
References: <19701.62091.644444.121284@gargle.gargle.HOWL> <20101202193024.GC2358@tuxdriver.com>
 <19704.23185.565826.890275@gargle.gargle.HOWL> <AANLkTinPLPoAHxauaXj8Sj=zjyHQPyxO0ku342ersZQ4@mail.gmail.com>
 <19709.45926.38551.25130@gargle.gargle.HOWL> <20101207194646.GG2700@tuxdriver.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 7 Dec 2010 15:18:32 -0800
Message-ID: <AANLkTinOgOT0XzeknrL4T4y17tNdjSK8HrB5WYcg-d9M@mail.gmail.com>
Subject: Re: [PATCH 2/2] ath9k_htc: Fix suspend/resume
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Sujith <m.sujith@gmail.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 7, 2010 at 11:46 AM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Tue, Dec 07, 2010 at 09:39:10AM +0530, Sujith wrote:
>> Luis R. Rodriguez wrote:
>> > Just curious, if you revert this patch and apply the ones I just
>> > posted, does it fix it, or is this patch required either way?
>>
>> Well, I don't see this patch in -testing, -next-2.6 or -2.6.
>> Maybe Linville overlooked this patch.
>
> Obviously I didn't overlook it, or I wouldn't have asked about whether
> or not it should go to 2.6.37...
>
>> Applying 4/5 and 5/5 from your series seems to fix the issue though.
>> I am able to suspend/resume without hiccups with UB95.
>
> But now this begs the question of whether this should be applied at all?

As I reviewed with Johannes the driver must ensure the device remains
idle after we get the last stop() call. So this patch seems fine, I'd
even consider removing the check for the if (!(hif_dev->flags &
HIF_USB_START)) and also call  ath9k_htc_suspend(hif_dev->htc_handle);
upon resume to ensure it is kept in full sleep then as well.

  Luis
