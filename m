Return-Path: <SRS0=yxJm=R7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F95CC43381
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Mar 2019 23:16:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D929F2173C
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Mar 2019 23:16:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="ZqEb44fm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728543AbfC1XQu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 28 Mar 2019 19:16:50 -0400
Received: from [208.74.158.174] ([208.74.158.174]:37964 "EHLO
        mail3.candelatech.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1728470AbfC1XQt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Mar 2019 19:16:49 -0400
Received: from [192.168.100.195] (50-251-239-81-static.hfc.comcastbusiness.net [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id E17BC66969;
        Thu, 28 Mar 2019 16:16:48 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com E17BC66969
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1553815008;
        bh=wa1mQhBe7N/mTW+Y28fdcQKIO0Kxv0q3WUzAWnS2zOc=;
        h=Subject:From:To:References:Date:In-Reply-To:From;
        b=ZqEb44fm7fu2w00GeeWx9aCfzNJWvPCAz6vjWrNpRvQthAmkvUFXj1MR0IYlxIUSS
         imPupZTrtAHOaaQ474D8MQNnwPSeCHImHxycYnvOuvKa+lkq6L/4WMnmNstfp5ySmx
         kA2U+94zgVyY0MZcwhNzIYFsh+l/HBJa1cmTzxNw=
Subject: Re: Action frame sent as TID 6
From:   Ben Greear <greearb@candelatech.com>
To:     "hostap@lists.infradead.org" <hostap@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <ca8c5af0-207f-458b-3858-037417513323@candelatech.com>
Organization: Candela Technologies
Message-ID: <59fe44fb-5bc3-59b4-63a9-55f3738da59b@candelatech.com>
Date:   Thu, 28 Mar 2019 16:16:48 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <ca8c5af0-207f-458b-3858-037417513323@candelatech.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 3/28/19 2:36 PM, Ben Greear wrote:
> While debugging some issues with neighbor query action frames, I ran into
> an interesting set of issues.
> 
> For reasons I do not yet understand, sometimes wpa_supplicant has bss->freq == 0
> when associated, and so sending an action frame chooses to send a 'command'
> frame instead of an mlme frame, because it thinks we are doing off-channel tx.
> 
> When this happens, I end up seeing the action frame sent out on TID 6 in
> the ath10k firmware.  This fails to send for a variety of reasons.
> 
> When supplicant evidently has the proper bss->freq, then action frames
> go through the mlme code path, and then I see frames hit the ath10k
> firmware on the mgt tid as expected.
> 
> I can hack around this in several different places, but in hopes of doing
> this more correctly:  What exactly is supposed to configure the TID
> for off-channel TX?
> 
> Thanks,
> Ben
> 

Well, this was my bug after all, down in the firmware.

Based on previous debugging though, likely the supplicant offchan thing will
still need to be fixed so that we can send action frames to our AP
on radar channels.

I'm 4 bugs deep though, so stepping back up to bug 3 now that the TID
issue is resolved.

Enjoy,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

