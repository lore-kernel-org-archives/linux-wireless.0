Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:34102 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756032AbeAIBg7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Jan 2018 20:36:59 -0500
Subject: Re: b43: Replace mdelay with msleep in b43_radio_2057_init_post
To: Larry Finger <Larry.Finger@lwfinger.net>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: kstewart@linuxfoundation.org, johannes.berg@intel.com,
        tiwai@suse.de, gregkh@linuxfoundation.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrew.zaborowski@intel.com, b43-dev@lists.infradead.org,
        netdev@vger.kernel.org, colin.king@canonical.com
References: <1514632107-14698-1-git-send-email-baijiaju1990@gmail.com>
 <20180108162128.6D37560B1D@smtp.codeaurora.org>
 <fc3e2558-c31f-289d-8413-33fef4f5ca64@lwfinger.net>
From: Jia-Ju Bai <baijiaju1990@gmail.com>
Message-ID: <050fa2c3-0ead-66c9-085a-e8c4578512eb@gmail.com> (sfid-20180109_024114_531781_A5B6B4FA)
Date: Tue, 9 Jan 2018 09:36:38 +0800
MIME-Version: 1.0
In-Reply-To: <fc3e2558-c31f-289d-8413-33fef4f5ca64@lwfinger.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 2018/1/9 0:31, Larry Finger wrote:
> On 01/08/2018 10:21 AM, Kalle Valo wrote:
>> Jia-Ju Bai <baijiaju1990@gmail.com> wrote:
>>
>>> b43_radio_2057_init_post is not called in an interrupt handler
>>> nor holding a spinlock.
>>> The function mdelay in it can be replaced with msleep, to reduce 
>>> busy wait.
>>>
>>> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
>>
>> You submitted an identical patch a week earlier:
>>
>> https://patchwork.kernel.org/patch/10137671/
>>
>> How is this different? Also always add version number to the patch so 
>> that the
>> maintainers can follow the changes easily:
>>
>> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#patch_version_missing 
>>
>>
>> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#changelog_missing 
>>
>
> I had negative comments on one of those due to the possibility of 
> msleep(2) extending as long as 20 msec. Until the author, or someone 
> else, can test that this is OK, then the mdelay(2) can only be 
> replaced with usleep_range(2000, 3000).
>
> NACK for both.
>
> Larry
>

Sorry for my mistake.
I have sent a patch v2 using usleep_range(2000, 3000), and you can have 
a look :)


Thanks,
Jia-Ju Bai
