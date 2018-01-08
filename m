Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f194.google.com ([74.125.82.194]:41854 "EHLO
        mail-ot0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932182AbeAHQb6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Jan 2018 11:31:58 -0500
Subject: Re: b43: Replace mdelay with msleep in b43_radio_2057_init_post
To: Kalle Valo <kvalo@codeaurora.org>,
        Jia-Ju Bai <baijiaju1990@gmail.com>
Cc: kstewart@linuxfoundation.org, johannes.berg@intel.com,
        tiwai@suse.de, gregkh@linuxfoundation.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrew.zaborowski@intel.com, b43-dev@lists.infradead.org,
        netdev@vger.kernel.org, colin.king@canonical.com
References: <1514632107-14698-1-git-send-email-baijiaju1990@gmail.com>
 <20180108162128.6D37560B1D@smtp.codeaurora.org>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <fc3e2558-c31f-289d-8413-33fef4f5ca64@lwfinger.net> (sfid-20180108_173349_154584_DD407EF1)
Date: Mon, 8 Jan 2018 10:31:56 -0600
MIME-Version: 1.0
In-Reply-To: <20180108162128.6D37560B1D@smtp.codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/08/2018 10:21 AM, Kalle Valo wrote:
> Jia-Ju Bai <baijiaju1990@gmail.com> wrote:
> 
>> b43_radio_2057_init_post is not called in an interrupt handler
>> nor holding a spinlock.
>> The function mdelay in it can be replaced with msleep, to reduce busy wait.
>>
>> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
> 
> You submitted an identical patch a week earlier:
> 
> https://patchwork.kernel.org/patch/10137671/
> 
> How is this different? Also always add version number to the patch so that the
> maintainers can follow the changes easily:
> 
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#patch_version_missing
> 
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#changelog_missing

I had negative comments on one of those due to the possibility of msleep(2) 
extending as long as 20 msec. Until the author, or someone else, can test that 
this is OK, then the mdelay(2) can only be replaced with usleep_range(2000, 3000).

NACK for both.

Larry
