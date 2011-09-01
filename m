Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f45.google.com ([209.85.216.45]:50256 "EHLO
	mail-qw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756192Ab1IARdH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Sep 2011 13:33:07 -0400
Received: by qwj8 with SMTP id 8so1497719qwj.4
        for <linux-wireless@vger.kernel.org>; Thu, 01 Sep 2011 10:33:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E5FBCA5.7020201@openwrt.org>
References: <1314833554-40721-1-git-send-email-nbd@openwrt.org>
 <1314833554-40721-2-git-send-email-nbd@openwrt.org> <1314833554-40721-3-git-send-email-nbd@openwrt.org>
 <CAB=NE6WXTs_wnoW0cdSNp=BrL=QnR=D2KNOcT6n4MOYOtE8sJQ@mail.gmail.com> <4E5FBCA5.7020201@openwrt.org>
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Date: Thu, 1 Sep 2011 10:32:46 -0700
Message-ID: <CAB=NE6Xtkk2hYMzVzcYUY3SR+Tk_D-ZfUM9tVFXP_+GXe-F4TA@mail.gmail.com> (sfid-20110901_193313_038543_FB10AAD4)
Subject: Re: [PATCH v11 3/4] ath9k: merge reset related functions
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	rmanohar@qca.qualcomm.com, shafi.wireless@gmail.com,
	vthiagar@qca.qualcomm.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 1, 2011 at 10:11 AM, Felix Fietkau <nbd@openwrt.org> wrote:
> On 2011-09-01 7:01 PM, Luis R. Rodriguez wrote:
>>
>> On Wed, Aug 31, 2011 at 4:32 PM, Felix Fietkau<nbd@openwrt.org>  wrote:
>>>
>>>  reduces unnecessary code duplication. Also takes the sc_pcu_lock within
>>>  ath_reset instead of callsites, which makes it possible to always cancel
>>>  all queued work items before the reset, possibly fixing a few race
>>>  conditions (work items vs reset) along with it.
>>>
>>>  Signed-off-by: Felix Fietkau<nbd@openwrt.org>
>>
>> This was a bit hard to review, if helpers are being added can they be
>> added without changing code around, and in some other patch make the
>> changes you describe?
>
> I don't think it can be easily split up, because the change to use the
> helper functions depends other things like the change to queue the reset
> work instead of calling ath_reset directly.

OK thanks, its just hard to review, I cannot really make much of it
but I trust you :)

  Luis
