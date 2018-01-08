Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39792 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933232AbeAHRGb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Jan 2018 12:06:31 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Jia-Ju Bai <baijiaju1990@gmail.com>, kstewart@linuxfoundation.org,
        johannes.berg@intel.com, tiwai@suse.de, gregkh@linuxfoundation.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrew.zaborowski@intel.com, b43-dev@lists.infradead.org,
        netdev@vger.kernel.org, colin.king@canonical.com
Subject: Re: b43: Replace mdelay with msleep in b43_radio_2057_init_post
References: <1514632107-14698-1-git-send-email-baijiaju1990@gmail.com>
        <20180108162128.6D37560B1D@smtp.codeaurora.org>
        <fc3e2558-c31f-289d-8413-33fef4f5ca64@lwfinger.net>
Date: Mon, 08 Jan 2018 19:06:24 +0200
In-Reply-To: <fc3e2558-c31f-289d-8413-33fef4f5ca64@lwfinger.net> (Larry
        Finger's message of "Mon, 8 Jan 2018 10:31:56 -0600")
Message-ID: <87shbg2sbz.fsf@kamboji.qca.qualcomm.com> (sfid-20180108_180851_466135_085BCD7B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

> On 01/08/2018 10:21 AM, Kalle Valo wrote:
>> Jia-Ju Bai <baijiaju1990@gmail.com> wrote:
>>
>>> b43_radio_2057_init_post is not called in an interrupt handler
>>> nor holding a spinlock.
>>> The function mdelay in it can be replaced with msleep, to reduce busy wait.
>>>
>>> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
>>
>> You submitted an identical patch a week earlier:
>>
>> https://patchwork.kernel.org/patch/10137671/
>>
>> How is this different? Also always add version number to the patch so that the
>> maintainers can follow the changes easily:
>>
>> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#patch_version_missing
>>
>> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#changelog_missing
>
> I had negative comments on one of those due to the possibility of
> msleep(2) extending as long as 20 msec. Until the author, or someone
> else, can test that this is OK, then the mdelay(2) can only be
> replaced with usleep_range(2000, 3000).
>
> NACK for both.

Ok, patches dropped.

-- 
Kalle Valo
