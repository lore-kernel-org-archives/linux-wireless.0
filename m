Return-Path: <SRS0=Z1rL=YC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2043C4360C
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Oct 2019 00:17:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 80E1C20873
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Oct 2019 00:17:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729950AbfJIARn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 8 Oct 2019 20:17:43 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:42206 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727051AbfJIARn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Oct 2019 20:17:43 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 9E12ABA33B87CEBD8A5B;
        Wed,  9 Oct 2019 08:17:41 +0800 (CST)
Received: from [127.0.0.1] (10.184.213.217) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.439.0; Wed, 9 Oct 2019
 08:17:39 +0800
Subject: Re: [PATCH] rtw88: 8822c: Remove set but not used variable 'corr_val'
To:     Kalle Valo <kvalo@codeaurora.org>
CC:     <yhchuang@realtek.com>, <pkshih@realtek.com>,
        <davem@davemloft.net>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>
References: <1570180736-133907-1-git-send-email-zhengbin13@huawei.com>
 <08492ba6-eaf6-8c72-74fe-f49e0a95639e@huawei.com>
 <87d0f771s7.fsf@kamboji.qca.qualcomm.com>
From:   "zhengbin (A)" <zhengbin13@huawei.com>
Message-ID: <4441d56d-b7d0-00dc-2d54-93ca02db6f67@huawei.com>
Date:   Wed, 9 Oct 2019 08:17:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <87d0f771s7.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.184.213.217]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2019/10/8 22:24, Kalle Valo wrote:

> (PLEASE don't top post, fixing that manually)
>
> "zhengbin (A)" <zhengbin13@huawei.com> writes:
>
>> On 2019/10/4 17:18, zhengbin wrote:
>>> Fixes gcc '-Wunused-but-set-variable' warning:
>>>
>>> drivers/net/wireless/realtek/rtw88/rtw8822c.c: In function rtw8822c_dpk_dc_corr_check:
>>> drivers/net/wireless/realtek/rtw88/rtw8822c.c:2166:5: warning: variable corr_val set but not used [-Wunused-but-set-variable]
>>>
>>> It is not used since commit 5227c2ee453d ("rtw88:
>>> 8822c: add SW DPK support")
>>>
>>> Reported-by: Hulk Robot <hulkci@huawei.com>
>>> Signed-off-by: zhengbin <zhengbin13@huawei.com>
>> Sorry for the noise, please ignore this
> Why? What was wrong in the patch?

I am not sure whether we can just remove

corr_val = (u8)rtw_read32_mask(rtwdev, REG_STAT_RPT, GENMASK(15, 8))?

rtw_read32_mask

  rtw_read32

    ops->read32

 

Thank you for your remind of do not top post.

BTW:  patchset 'net/rtlwifi: remove some unused variables' & patch 'rtlwifi: rtl8192ee: Remove set but not used variable 'err''

are acked-by Ping-Ke Shih, can you help deal with it?

>

