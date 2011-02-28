Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:44803 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734Ab1B1RVV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Feb 2011 12:21:21 -0500
Received: by iwn34 with SMTP id 34so3275404iwn.19
        for <linux-wireless@vger.kernel.org>; Mon, 28 Feb 2011 09:21:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTikTNavD44e_bMO7Q8C5X73qwVHdjnVCiOUO1xCr@mail.gmail.com>
References: <1298874054-3803-1-git-send-email-vnatarajan@atheros.com>
 <20110228142243.GB25724@kroah.com> <AANLkTi=upDdu1_QH7rvhc6QS0+hDSGtXf2AQ920C1u1U@mail.gmail.com>
 <AANLkTinF6rnvB15AiLnQyHV8O4hZuEsU9C2C-hpbTGNR@mail.gmail.com> <AANLkTikTNavD44e_bMO7Q8C5X73qwVHdjnVCiOUO1xCr@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 28 Feb 2011 09:21:01 -0800
Message-ID: <AANLkTikxfjcStGND0SAqgCA+sZBEa0Xo_mf-ZGpsQrks@mail.gmail.com>
Subject: Re: [stable] [stable 2.6.37][PATCH] ath9k: Fix ath9k to allow CPU to
 enter C3 state.
To: Vivek Natarajan <vivek.natraj@gmail.com>
Cc: Greg KH <greg@kroah.com>,
	Mohammed Shafi Shajakhan <mshajakhan@atheros.com>,
	linux-wireless@vger.kernel.org, stable@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 28, 2011 at 9:20 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Mon, Feb 28, 2011 at 8:52 AM, Vivek Natarajan <vivek.natraj@gmail.com> wrote:
>> On Mon, Feb 28, 2011 at 8:18 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>>> On Mon, Feb 28, 2011 at 6:22 AM, Greg KH <greg@kroah.com> wrote:
>>>> On Mon, Feb 28, 2011 at 11:50:53AM +0530, Vivek Natarajan wrote:
>>>>> The default qos value of 55 causes higher power consumption
>>>>> and the battery drains out quickly. So, remove the pm_qos request
>>>>> in the driver and the throughout issue in the Intel Pinetrail
>>>>> platforms in which the DMA latency is seen can be fixed with
>>>>> the following script:
>>>>> http://www.kernel.org/pub/linux/kernel/people/mcgrof/scripts/cpudmalatency.c
>>>>> http://johannes.sipsolutions.net/files/netlatency.c.txt
>>>>>
>>>>> More details can be found in the following bugzilla link:
>>>>> https://bugzilla.kernel.org/show_bug.cgi?id=27532
>>>>>
>>>>> Cc: stable@kernel.org
>>>>> Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
>>>>> Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
>>>>
>>>> Why did you send me 3 copies of this patch, when I don't need any copies
>>>> of it?
>>>>
>>>> Totally confused,
>>>
>>> Vivek, please only ask John to send this to David as stable so it can
>>> get into 2.6.38-rc, then once there you can refer the sha1sum from
>>> Linus' tree and justify propagating into the stable series.
>>>
>> I had sent separate patches for v2.6.37 and for v2.6.38 since the
>> patch could not be applied directly to previous versions. So, should I
>> send this rebased patch for v2.6.37 only after it makes it into
>> v2.6.38?
>
> Affirmative. You cannot propagate stable patches unless they are
> already in Linus' tree.

See:

http://wireless.kernel.org/en/users/Documentation/Fix_Propagation

  Luis
