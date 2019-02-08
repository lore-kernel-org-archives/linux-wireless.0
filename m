Return-Path: <SRS0=Ms0V=QP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EC6CC169C4
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 17:57:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D7373218AC
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 17:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1549648665;
	bh=m/56QnUxsGuswsrkVElOMaSRXcAST4745jd+uEwQfC0=;
	h=Subject:To:Cc:References:From:Date:In-Reply-To:List-ID:From;
	b=EtqpwQrFud22UkYq6ZsW1zuPQEVJP/4fNP/OuWlhKsBYMVupJ/eDHFnVLSLFjpTes
	 3hFQd+yiYmuLNCN28OCVAHcSbeG1WUmoD2LG3gWuMs8WFUO2hNj9QY8uJ8iG3Y+RJV
	 GjOb6wNP5I7wbN29QJqQuKV2QeopZYC4FSbpdcvk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728229AbfBHR5k (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Feb 2019 12:57:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:37124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728045AbfBHR5j (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Feb 2019 12:57:39 -0500
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6DC6520855;
        Fri,  8 Feb 2019 17:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1549648658;
        bh=m/56QnUxsGuswsrkVElOMaSRXcAST4745jd+uEwQfC0=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=gxxZZvdhE7Y/Mu4f7/3l8Tr/ItS8PS7GXEUInutdvx1kYlMjNPtjk+jKznQo5VbMD
         UDBySntldkNijNnaefr/kiugD8LeUErtBJKVgcJyGHezg9hsC1LaO6Wy0RcMkjvNng
         IB6fA2PWvTrFvLlPpJSybsFEffHNVwkceTF+4S48=
Subject: Re: [PATCH 0/3] firmware_loader: few selftest fixes
To:     "Luis R. Rodriguez" <mcgrof@kernel.org>, gregkh@linuxfoundation.org
Cc:     akpm@linux-foundation.org, josh@joshtriplett.org,
        rishabhb@codeaurora.org, kubakici@wp.pl, maco@android.com,
        andy.gross@linaro.org, david.brown@linaro.org,
        bjorn.andersson@linaro.org, linux-wireless@vger.kernel.org,
        keescook@chromium.org, mfuzzey@parkeon.com,
        zohar@linux.vnet.ibm.com, dhowells@redhat.com,
        pali.rohar@gmail.com, tiwai@suse.de, arend.vanspriel@broadcom.com,
        zajec5@gmail.com, nbroeking@me.com, markivx@codeaurora.org,
        broonie@kernel.org, dmitry.torokhov@gmail.com, dwmw2@infradead.org,
        torvalds@linux-foundation.org, Abhay_Salunke@dell.com,
        jewalt@lgsinnovations.com, cantabile.desu@gmail.com, ast@fb.com,
        andresx7@gmail.com, dan.rue@linaro.org, brendanhiggins@google.com,
        yzaikin@google.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, shuah <shuah@kernel.org>
References: <20190207190602.502-1-mcgrof@kernel.org>
From:   shuah <shuah@kernel.org>
Message-ID: <18f2e46e-8171-58e2-41d0-c4272fb9b00d@kernel.org>
Date:   Fri, 8 Feb 2019 10:57:35 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190207190602.502-1-mcgrof@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2/7/19 12:05 PM, Luis R. Rodriguez wrote:
> From: Luis Chamberlain <mcgrof@kernel.org>
> 
> Greg,
> 
> I've found that Dan's patches really broke firmware testing. I've
> identified a proper fix for the issue he found, its the last patch. This
> series reverts his two patches which break testing, and fixes the issue
> he was running into. I leave it to him as exercise to add a busybox bash
> quirk for the bash issue he found with diff.
> 
> His patches are merged on v5.0-rc1 as such these should go to Linus
> tree as well. They are regressions on v5.0-rc1. Please let me know if
> there are any questions.
> 
>    Luis
> 
> Luis Chamberlain (3):
>    Revert "selftests: firmware: add CONFIG_FW_LOADER_USER_HELPER_FALLBACK
>      to config"
>    Revert "selftests: firmware: remove use of non-standard diff -Z
>      option"
>    selftests: firmware: fix verify_reqs() return value
> 
>   tools/testing/selftests/firmware/config           | 1 -
>   tools/testing/selftests/firmware/fw_filesystem.sh | 9 ++++++---
>   tools/testing/selftests/firmware/fw_lib.sh        | 2 +-
>   3 files changed, 7 insertions(+), 5 deletions(-)
> 

Luis: Thanks for finding and fixing the problems. My apologies
for pulling the problem patch in by mistake in the first place. :(

Greg! Do you plan to take these through firmware or do you want
me to get these in through kselftest tree. Either way is fine.

Acked-by: Shuah Khan <shuah@kernel.org>

thanks,
-- Shuah
