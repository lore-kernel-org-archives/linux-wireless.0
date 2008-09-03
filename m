Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:52608 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531AbYICOK2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2008 10:10:28 -0400
Received: by fg-out-1718.google.com with SMTP id 19so162010fgg.17
        for <linux-wireless@vger.kernel.org>; Wed, 03 Sep 2008 07:10:27 -0700 (PDT)
Message-ID: <1ba2fa240809030710h64574f9ch8951f122b341e678@mail.gmail.com> (sfid-20080903_161033_832614_A8FC2B58)
Date: Wed, 3 Sep 2008 17:10:26 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Marcel Holtmann" <holtmann@linux.intel.com>
Subject: Re: [PATCH 4/9] iwlwifi: generic init calibrations framework
Cc: "David Miller" <davem@davemloft.net>, yi.zhu@intel.com,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	emmanuel.grumbach@intel.com
In-Reply-To: <1220450355.6714.26.camel@californication>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1220411930-15216-3-git-send-email-yi.zhu@intel.com>
	 <1220411930-15216-4-git-send-email-yi.zhu@intel.com>
	 <1220411930-15216-5-git-send-email-yi.zhu@intel.com>
	 <20080902.203634.127434142.davem@davemloft.net>
	 <1220429411.6714.17.camel@californication>
	 <1ba2fa240809030223m56ce47aqf9f41fab7d3453ca@mail.gmail.com>
	 <1220450355.6714.26.camel@californication>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 3, 2008 at 4:59 PM, Marcel Holtmann
<holtmann@linux.intel.com> wrote:
> Hi Tomas,
>
>> >> > This patch fixes a critical bug that only the last calibration result
>> >> > was applied. On reception of one calibration result all the calibration
>> >> > results were freed therefore only last was applied. The patch fixes this
>> >> > problem by introducing a generic init calibration framework which allows
>> >> > variable number of init calibrations and allows addition new HW.
>> >> >
>> >> > Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
>> >> > Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
>> >> > Signed-off-by: Zhu Yi <yi.zhu@intel.com>
>> >>
>> >> This is borderline, I would rather hold off on such a sizable change
>> >> for 2.6.27 as I'll have a hard time justifying it.
>> >
>> > do you see any way for fixing (or improving) this with the current code
>> > and hold the whole framework change off until the next merge window.
>> >
>> > Maybe instead of iwl_free_calib_results(priv); just freeing them
>> > individually in their case statements.
>> > You know the hardware better than I do, but that should just work
>> > (judging from the code).
>>
>> In general it's possible, but we've already tested this fix. Because
>> this is sensitive, even if the code looks okay I cannot approve it
>> until we run the whole validation cycle and measurements in the lab so
>> it will take some time. Last time we broke it code also looked good :)
>
> if I understood Dave correctly, then we either come up with a temporary
> fix that is small and simple (even if it is not a long term solution) or
> no fix for this issue is going into 2.6.27 at all. The fix that I have
> in mind removes one line and adds 6 new ones.
>
> And of course it needs to be tested, but that should be true for
> everything that goes into the kernel. I can write the temporary patch
> for it, but you guys are the experts with this hardware. So I leave it
> up to you.

Writing the fix is not the problem, just to get the cycles from the testing.
Tomas
