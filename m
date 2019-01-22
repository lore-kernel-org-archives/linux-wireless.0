Return-Path: <SRS0=0pM2=P6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 274BBC282C3
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 16:21:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EADAB21726
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 16:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548174064;
	bh=OiF8SEdwDvmQixUXJGQiHbsxraGMdVz1ikZXY9obWhw=;
	h=Subject:To:Cc:References:From:Date:In-Reply-To:List-ID:From;
	b=lr3katqmZs30Rs/7NEJCpiIGZd1eIBgrY1mktghsGV88UN46ItrSfzC/8UiKo/opp
	 cohmcq5IfnEad9J1kpkjf1IyIw8xbL403n2GioFIhetiDhxfXjVIk6qvCMuc6Cqfu0
	 RGnVDB8ykG9fIfnh0jWR5/GX+39e3HSQEQXYkwK8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729074AbfAVQU6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 22 Jan 2019 11:20:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:48214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728669AbfAVQU5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Jan 2019 11:20:57 -0500
Received: from [10.84.151.24] (unknown [167.220.148.24])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C185D20870;
        Tue, 22 Jan 2019 16:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548174056;
        bh=OiF8SEdwDvmQixUXJGQiHbsxraGMdVz1ikZXY9obWhw=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=s9aLRquZSYEk6lV/U+5B0LjL8WHD93WdItwF/Z42kRpBS3iTREH2Uyp8MLGQqd81f
         wUdyuRHY+y8gSsXQse7dpLZFDrMVg+3SNNvVQk+gVWWv0kdRQXePCHF9DUvcuauHvD
         z/iei1MH9/AgfWsN6MC4EgKIy8e4UaKUG6qjkJ7k=
Subject: Re: [for next][PATCH] iwlwifi: Fix unmet dependency error for
 IWLWIFI_LEDS
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Luciano Coelho <luciano.coelho@intel.com>,
        linux-next@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190121233102.13705-1-okaya@kernel.org>
 <ef50896ee3ecc895c72a9fbdedca65ac6433fef2.camel@intel.com>
 <d00c99a7-423a-9a70-5f50-f95c5d044f85@kernel.org>
 <87munsmztb.fsf@kamboji.qca.qualcomm.com>
From:   Sinan Kaya <okaya@kernel.org>
Message-ID: <7baaaf76-7f96-cd1d-2a8d-e6c4342c10dd@kernel.org>
Date:   Tue, 22 Jan 2019 11:20:54 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <87munsmztb.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 1/22/2019 11:17 AM, Kalle Valo wrote:
> Sinan Kaya <okaya@kernel.org> writes:
> 
>> On 1/22/2019 5:15 AM, Luciano Coelho wrote:
>>> On Mon, 2019-01-21 at 23:31 +0000, Sinan Kaya wrote:
>>>> There is an unresolved dependency as follows:
>>>>
>>>> IWLWIFI_LEDS selects MAC80211_LEDS.
>>>> MAC80211_LEDS depends on MAC80211.
>>>>
>>>> It is possible to choose MAC80211_LEDS (y) but not choose MAC80211
>>>> (n)
>>>>
>>>> WARNING: unmet direct dependencies detected for MAC80211_LEDS
>>>>     Depends on [n]: NET [=y] && WIRELESS [=y] && MAC80211 [=n] &&
>>>> LEDS_CLASS [=y]
>>>>     Selected by [y]:
>>>>     - IWLWIFI_LEDS [=y] && NETDEVICES [=y] && WLAN [=y] &&
>>>> WLAN_VENDOR_INTEL [=y] && IWLWIFI [=y] && (LEDS_CLASS [=y]=y ||
>>>> LEDS_CLASS [=y]=IWLWIFI [=y])
>>>>
>>>> Move the MAC80211 dependency into IWLWIFI_LEDS so that we avoid this
>>>> configuration.
>>>>
>>>> Signed-off-by: Sinan Kaya <okaya@kernel.org>
>>>> ---
>>>
>>> Thanks for your patch! But we already have another patch to fix this
>>> issued queued for 5.0-rc4 (it's currently in wireless-drivers.git):
>>>
>>> https://patchwork.kernel.org/patch/10762079/
>>
>> Is it possible to queue this up soon? There is an effort to clean up
>> linux-next against randconfig failures and this issue showed up there.
> 
> It already should be in linux-next:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git/commit/?id=ec5aecc0b227f5509d25853537f989ca303e2be1
> 
> But it's not in Linus' tree, yet.
> 

Thanks, let me grab a recent linux-next tag.
