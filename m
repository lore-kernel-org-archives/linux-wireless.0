Return-Path: <SRS0=0pM2=P6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7F36C282C3
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 16:12:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F17520870
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 16:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548173536;
	bh=KnB5cV++pJZKQEBly+Zj0FeE/8hcEZxRzWsSpOJs4ys=;
	h=Subject:To:Cc:References:From:Date:In-Reply-To:List-ID:From;
	b=xt2AS5PfboDsSuXi09rIFVkPWM7n5Usf4Co9ntEN8QGin7rsz7G31y6kGDn54J3mU
	 1476yzqqY7xDRwaOGny18H2tlxXlFd0I8I69n6ucTKYSUjVFPVtTz/JTX2sqQ3Wjly
	 YAoJtH0ZScfha/Cvj25xMaJQuog0euKIuy6mrEj0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729116AbfAVQMJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 22 Jan 2019 11:12:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:44690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728669AbfAVQMJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Jan 2019 11:12:09 -0500
Received: from [10.84.151.24] (unknown [167.220.149.24])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D2D5320823;
        Tue, 22 Jan 2019 16:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548173528;
        bh=KnB5cV++pJZKQEBly+Zj0FeE/8hcEZxRzWsSpOJs4ys=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=ZqRM43DHBe9zO7Zns/KBQk5q+HqZ0hkT8BxfbZYtbZetdgtQ5iO/P0V4k4HiAjQtk
         Hre92d+TEOiS0HVc0qnm6ICyx+lGzlxuJGnIxGWNxeqWVuORjvftuM/LraYklKobWC
         nDtEZZaYHt+qiwg7Esw+/60aLVFli1KYC6DWFxGk=
Subject: Re: [for next][PATCH] iwlwifi: Fix unmet dependency error for
 IWLWIFI_LEDS
To:     Luciano Coelho <luciano.coelho@intel.com>,
        linux-next@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:INTEL WIRELESS WIFI LINK (iwlwifi)" 
        <linux-wireless@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20190121233102.13705-1-okaya@kernel.org>
 <ef50896ee3ecc895c72a9fbdedca65ac6433fef2.camel@intel.com>
From:   Sinan Kaya <okaya@kernel.org>
Message-ID: <d00c99a7-423a-9a70-5f50-f95c5d044f85@kernel.org>
Date:   Tue, 22 Jan 2019 11:12:06 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <ef50896ee3ecc895c72a9fbdedca65ac6433fef2.camel@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 1/22/2019 5:15 AM, Luciano Coelho wrote:
> On Mon, 2019-01-21 at 23:31 +0000, Sinan Kaya wrote:
>> There is an unresolved dependency as follows:
>>
>> IWLWIFI_LEDS selects MAC80211_LEDS.
>> MAC80211_LEDS depends on MAC80211.
>>
>> It is possible to choose MAC80211_LEDS (y) but not choose MAC80211
>> (n)
>>
>> WARNING: unmet direct dependencies detected for MAC80211_LEDS
>>    Depends on [n]: NET [=y] && WIRELESS [=y] && MAC80211 [=n] &&
>> LEDS_CLASS [=y]
>>    Selected by [y]:
>>    - IWLWIFI_LEDS [=y] && NETDEVICES [=y] && WLAN [=y] &&
>> WLAN_VENDOR_INTEL [=y] && IWLWIFI [=y] && (LEDS_CLASS [=y]=y ||
>> LEDS_CLASS [=y]=IWLWIFI [=y])
>>
>> Move the MAC80211 dependency into IWLWIFI_LEDS so that we avoid this
>> configuration.
>>
>> Signed-off-by: Sinan Kaya <okaya@kernel.org>
>> ---
> 
> Thanks for your patch! But we already have another patch to fix this
> issued queued for 5.0-rc4 (it's currently in wireless-drivers.git):
> 
> https://patchwork.kernel.org/patch/10762079/

Is it possible to queue this up soon? There is an effort to clean up
linux-next against randconfig failures and this issue showed up there.

> 
> --
> Cheers,
> Luca.
> 
> 

