Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.188]:35838 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbYICJXu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2008 05:23:50 -0400
Received: by fk-out-0910.google.com with SMTP id 18so2137660fkq.5
        for <linux-wireless@vger.kernel.org>; Wed, 03 Sep 2008 02:23:48 -0700 (PDT)
Message-ID: <1ba2fa240809030223m56ce47aqf9f41fab7d3453ca@mail.gmail.com> (sfid-20080903_112355_739239_63D4237F)
Date: Wed, 3 Sep 2008 12:23:48 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Marcel Holtmann" <holtmann@linux.intel.com>
Subject: Re: [PATCH 4/9] iwlwifi: generic init calibrations framework
Cc: "David Miller" <davem@davemloft.net>, yi.zhu@intel.com,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	emmanuel.grumbach@intel.com
In-Reply-To: <1220429411.6714.17.camel@californication>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1220411930-15216-3-git-send-email-yi.zhu@intel.com>
	 <1220411930-15216-4-git-send-email-yi.zhu@intel.com>
	 <1220411930-15216-5-git-send-email-yi.zhu@intel.com>
	 <20080902.203634.127434142.davem@davemloft.net>
	 <1220429411.6714.17.camel@californication>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 3, 2008 at 11:10 AM, Marcel Holtmann
<holtmann@linux.intel.com> wrote:
> Hi Tomas,
>
>> > This patch fixes a critical bug that only the last calibration result
>> > was applied. On reception of one calibration result all the calibration
>> > results were freed therefore only last was applied. The patch fixes this
>> > problem by introducing a generic init calibration framework which allows
>> > variable number of init calibrations and allows addition new HW.
>> >
>> > Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
>> > Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
>> > Signed-off-by: Zhu Yi <yi.zhu@intel.com>
>>
>> This is borderline, I would rather hold off on such a sizable change
>> for 2.6.27 as I'll have a hard time justifying it.
>
> do you see any way for fixing (or improving) this with the current code
> and hold the whole framework change off until the next merge window.
>
> Maybe instead of iwl_free_calib_results(priv); just freeing them
> individually in their case statements.
> You know the hardware better than I do, but that should just work
> (judging from the code).
>
> Regards
>
> Marcel

In general it's possible, but we've already tested this fix. Because
this is sensitive, even if the code looks okay I cannot approve it
until we run the whole validation cycle and measurements in the lab so
it will take some time. Last time we broke it code also looked good :)
Tomas
