Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E325AC433FE
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Apr 2022 05:14:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350076AbiDTFQn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Apr 2022 01:16:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232351AbiDTFQm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Apr 2022 01:16:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FD9533E3A;
        Tue, 19 Apr 2022 22:13:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9659B81244;
        Wed, 20 Apr 2022 05:13:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC9DFC385A0;
        Wed, 20 Apr 2022 05:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650431634;
        bh=Xl8xanXzGG/XbMPJDPUaNRxh8BraaLlRbxRew5ksBiw=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=MWRbUBz9aU0uUj7CU39+2wGmazTXtMvR03ApKZl5oW7EFAVuhS5jKf7sp03Q9r9S/
         JPPbgcGQiWfrN8OXQ9DsliVf5S5ZV/BvfTSU1BuKOqln8qdq/EypwAvgz1QwP8Xr4d
         yX1den7jqPZaRgiuM588z3n/dS4IvviSoB7ZmOWeNdMNQMnouRFfgPuz1lRohNclPl
         15SyuSrsu/1OtpHeV7kDRj4sX7XF31fygnHkVtAGWoX2CwcI/yQoRIkIEkC78tNz1Y
         rhjcIig2B7J0YCIuF8MPsm06kuInhm56U70+8sBEMyv0DdgArF6Ic73iWHs5WSYV3+
         9hSf3BfWl3+Tw==
From:   Kalle Valo <kvalo@kernel.org>
To:     Jani Nikula <jani.nikula@intel.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Lucas De Marchi <lucas.demarchi@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/1] add support for enum module parameters
References: <20220414123033.654198-1-jani.nikula@intel.com>
        <YlgfXxjefuxiXjtC@kroah.com> <87a6cneoco.fsf@intel.com>
Date:   Wed, 20 Apr 2022 08:13:47 +0300
In-Reply-To: <87a6cneoco.fsf@intel.com> (Jani Nikula's message of "Thu, 14 Apr
        2022 17:22:47 +0300")
Message-ID: <87sfq8qqus.fsf@tynnyri.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

+ linux-wireless, netdev

Jani Nikula <jani.nikula@intel.com> writes:

> On Thu, 14 Apr 2022, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>> On Thu, Apr 14, 2022 at 03:30:32PM +0300, Jani Nikula wrote:
>>> Hey, I've sent this before, ages ago, but haven't really followed
>>> through with it. I still think it would be useful for many scenarios
>>> where a plain number is a clumsy interface for a module param.
>>> 
>>> Thoughts?
>>
>> We should not be adding new module parameters anyway (they operate on
>> code, not data/devices), so what would this be used for?
>
> I think it's just easier to use names than random values, and this also
> gives you range check on the input.
>
> I also keep telling people not to add new module parameters, but it's
> not like they're going away anytime soon.
>
> If there's a solution to being able to pass device specific debug
> parameters at probe time, I'm all ears. At least i915 has a bunch of
> things which can't really be changed after probe, when debugfs for the
> device is around. Module parameters aren't ideal, but debugfs doesn't
> work for this.

Wireless drivers would also desperately need to pass device specific
parameters at (or before) probe time. And not only debug parameters but
also configuration parameters, for example firmware memory allocations
schemes (optimise for features vs number of clients etc) and whatnot.

Any ideas how to implement that? Is there any prior work for anything
like this? This is pretty hard limiting usability of upstream wireless
drivers and I really want to find a proper solution.


-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
