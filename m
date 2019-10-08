Return-Path: <SRS0=jiki=YB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F4D5ECE58E
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Oct 2019 14:25:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E6F9320673
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Oct 2019 14:25:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="LpFlYgD3";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ay2/dFsG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725987AbfJHOZC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 8 Oct 2019 10:25:02 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:48066 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725795AbfJHOZC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Oct 2019 10:25:02 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 7873160767; Tue,  8 Oct 2019 14:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1570544701;
        bh=I2INBlXYMChgwc8/RBJLLPzDkUDaxbatBFHeY0+sfpU=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=LpFlYgD3kSnT33qyHKzOiIvsPulrl6fnmy60IpFtfmirOSDTPGoEH+14VBAs8DSpk
         qBPeebnXNgqzmmurOrsoYbAez0YhUJwBMZaynli/psmpPj1XP7nhblfhm7Aurnth1T
         rfq3Vuxo2lMGs7EuLKTRiEHFZXlaAfnIalp9E9O4=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DAEE66030E;
        Tue,  8 Oct 2019 14:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1570544700;
        bh=I2INBlXYMChgwc8/RBJLLPzDkUDaxbatBFHeY0+sfpU=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=ay2/dFsGpa4//xVaVO3KLkLsd16fYQ4TV4KbV4RNxutTV4jmb/xi+1KzzvzAahL/V
         W4am0PvpAlCvqa+HYKN2TS2UUKIfFTjOLFDGAePbMlGywTYuQ37g213w7Zz24PxftT
         A2XMZSDH82aiPem6VLEh4c6DkuAevT52uW3jDzgg=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org DAEE66030E
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     "zhengbin \(A\)" <zhengbin13@huawei.com>
Cc:     <yhchuang@realtek.com>, <pkshih@realtek.com>,
        <davem@davemloft.net>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH] rtw88: 8822c: Remove set but not used variable 'corr_val'
References: <1570180736-133907-1-git-send-email-zhengbin13@huawei.com>
        <08492ba6-eaf6-8c72-74fe-f49e0a95639e@huawei.com>
Date:   Tue, 08 Oct 2019 17:24:56 +0300
In-Reply-To: <08492ba6-eaf6-8c72-74fe-f49e0a95639e@huawei.com> (zhengbin's
        message of "Tue, 8 Oct 2019 17:33:51 +0800")
Message-ID: <87d0f771s7.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

(PLEASE don't top post, fixing that manually)

"zhengbin (A)" <zhengbin13@huawei.com> writes:

>
> On 2019/10/4 17:18, zhengbin wrote:
>> Fixes gcc '-Wunused-but-set-variable' warning:
>>
>> drivers/net/wireless/realtek/rtw88/rtw8822c.c: In function rtw8822c_dpk_dc_corr_check:
>> drivers/net/wireless/realtek/rtw88/rtw8822c.c:2166:5: warning: variable corr_val set but not used [-Wunused-but-set-variable]
>>
>> It is not used since commit 5227c2ee453d ("rtw88:
>> 8822c: add SW DPK support")
>>
>> Reported-by: Hulk Robot <hulkci@huawei.com>
>> Signed-off-by: zhengbin <zhengbin13@huawei.com>
>
> Sorry for the noise, please ignore this

Why? What was wrong in the patch?

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
