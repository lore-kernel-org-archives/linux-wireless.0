Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A48C2C433FE
	for <linux-wireless@archiver.kernel.org>; Fri, 21 Oct 2022 10:50:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230273AbiJUKud (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 21 Oct 2022 06:50:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbiJUKt6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Oct 2022 06:49:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 051F05B9F0
        for <linux-wireless@vger.kernel.org>; Fri, 21 Oct 2022 03:49:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 249E4B8093B
        for <linux-wireless@vger.kernel.org>; Fri, 21 Oct 2022 10:49:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BEE5C433D7;
        Fri, 21 Oct 2022 10:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666349388;
        bh=UdpcZIggkYuFkG4wEbYKZ6EO11hn1g6zfjeX6Xlq0j4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Ni+oJ/SuficEU8L3ey1MSFpjTJZIOhX/CBymIFqhbmKrYqV6JroMVAeQurURNsufo
         eh0VruL5A13jysiLPHQtRJByBuDeRksdURMjQ8L4HKtvkWQ9heRVuGLA7122Wo1Sd5
         kF9MOD13HhILLk7CSlAs17zYhPjfnVq+vevbUCzvT1JfSuQ2Djl7mkyqf56BZb8Hap
         iZZI+e1pGL3WpGeoBsQX3PKavucknBEd01hlXvVzJBUShtI5y3HghNAq8YfXd8Aw37
         yFS25gLrBoQpelETp/MvuERQCm7/WzUJleT1/8ZQT/77RDOeEcSCkJ34Fk2KE/ykKv
         C6mDpXA3f+1gw==
From:   Kalle Valo <kvalo@kernel.org>
To:     Bitterblue Smith <rtl8821cerfe2@gmail.com>
Cc:     kernel test robot <lkp@intel.com>, llvm@lists.linux.dev,
        kbuild-all@lists.01.org,
        Linux Memory Management List <linux-mm@kvack.org>,
        linux-wireless@vger.kernel.org
Subject: Re: [linux-next:master 637/2652] drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8188f.c:432:7: warning: variable 'hw_ctrl_s1' is used uninitialized whenever 'if' condition is false
References: <202210211531.zEaM6hBM-lkp@intel.com> <87edv1lhad.fsf@kernel.org>
        <3d047bb4-276c-026a-e292-f0a1f011b9f4@gmail.com>
Date:   Fri, 21 Oct 2022 13:49:42 +0300
In-Reply-To: <3d047bb4-276c-026a-e292-f0a1f011b9f4@gmail.com> (Bitterblue
        Smith's message of "Fri, 21 Oct 2022 13:44:38 +0300")
Message-ID: <875ygdlad5.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Bitterblue Smith <rtl8821cerfe2@gmail.com> writes:

> On 21/10/2022 11:20, Kalle Valo wrote:
>
>> + linux-wireless
>> 
>> kernel test robot <lkp@intel.com> writes:
>> 
>>> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
>>> head:   4d48f589d294ddc5e01d3b0dc7cecc55324c05ca
>>> commit: c888183b21f36a247bb166ca9365705611bea847 [637/2652] wifi: rtl8xxxu: Support new chip RTL8188FU
>>> config: i386-allyesconfig
>>> compiler: clang version 14.0.6 (https://github.com/llvm/llvm-project f28c006a5895fc0e329fe15fead81e37457cb1d1)
>>> reproduce (this is a W=1 build):
>>>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>>>         chmod +x ~/bin/make.cross
>>>         # https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/?id=c888183b21f36a247bb166ca9365705611bea847
>>>         git remote add linux-next https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
>>>         git fetch --no-tags linux-next master
>>>         git checkout c888183b21f36a247bb166ca9365705611bea847
>>>         # save the config file
>>>         mkdir build_dir && cp config build_dir/.config
>>>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash drivers/gpu/drm/i915/ drivers/net/wireless/ath/ath11k/ drivers/net/wireless/realtek/rtl8xxxu/
>>>
>>> If you fix the issue, kindly add following tag where applicable
>>> | Reported-by: kernel test robot <lkp@intel.com>
>>>
>>> All warnings (new ones prefixed by >>):
>>>
>>>>> drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8188f.c:432:7: warning: variable 'hw_ctrl_s1' is used uninitialized whenever 'if' condition is false [-Wsometimes-uninitialized]
>>>                    if (hw_ctrl) {
>>>                        ^~~~~~~
>>>    drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8188f.c:440:7: note: uninitialized use occurs here
>>>                    if (hw_ctrl_s1 || sw_ctrl_s1) {
>>>                        ^~~~~~~~~~
>>>    drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8188f.c:432:3: note: remove the 'if' if its condition is always true
>>>                    if (hw_ctrl) {
>>>                    ^~~~~~~~~~~~~
>>>    drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8188f.c:415:45: note: initialize the variable 'hw_ctrl_s1' to silence this warning
>>>            bool do_notch, hw_ctrl, sw_ctrl, hw_ctrl_s1, sw_ctrl_s1;
>>>                                                       ^
>>>                                                        = 0
>>>    1 warning generated.
>> 
>> Bitterblue, could you submit a patch to fix this, please?
>
> There is one from Colin Ian King:
> https://lore.kernel.org/linux-wireless/20221020135709.1549086-1-colin.i.king@gmail.com/

Thanks, I'll take that later today, before I send the pull request to
net-next.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
