Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE08EC43143
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 14:07:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B52D2208D9
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 14:07:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="NMnZn0so";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="EUR/7Pjf"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B52D2208D9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729498AbeJAUox (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Oct 2018 16:44:53 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:35240 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728979AbeJAUow (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Oct 2018 16:44:52 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 4B7C360C1B; Mon,  1 Oct 2018 14:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538402814;
        bh=V29D7v7DCeQ1J/4zDm3WhG07abymtaPWhnQYsXjIsJQ=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=NMnZn0so88yRp0wN08KlAUYbv7nB+wrULpEUDF7ZfTLssSium6+/QKkU0W8hIHTAJ
         fjlW+TsIIxn9gkC9WVjCsQNK47C3xQyTzhvbnrMJOpnrRC1tjMEDYyTOEX+TEyxNSj
         oubEIEC0Ejv5OiKWsqSdrDdufmWkkq0b0RTvMUz4=
Received: from potku.adurom.net (88-114-240-52.elisa-laajakaista.fi [88.114.240.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 680A06021C;
        Mon,  1 Oct 2018 14:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538402814;
        bh=V29D7v7DCeQ1J/4zDm3WhG07abymtaPWhnQYsXjIsJQ=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=EUR/7PjfvmMrEtYzEVX1HaBDLpIO8DWcof3wgHTDDOElmRQEHT50KsYIM+z8jHCqw
         PkWdQAy+TaBZ7ToiqEbVFLy1JFcn7rXw9gkZgw/eSt4lVbyO5sS1jYY6Sur5pcJl3S
         SpkLWrNcTbggCXd42cqShrwzgi/4N3vp4gdH018U=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 680A06021C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath9k: debug: remove set but not used variable
 'fops_dump_nfcal'
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180910031128.12164-1-yuehaibing@huawei.com>
References: <20180910031128.12164-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <ath9k-devel@qca.qualcomm.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <linux-wireless@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181001140654.4B7C360C1B@smtp.codeaurora.org>
Date:   Mon,  1 Oct 2018 14:06:54 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

YueHaibing <yuehaibing@huawei.com> wrote:

> 'fops_dump_nfcal' is not used since commit 4447d815fd0f ("ath: ath9k: use debugfs_create_devm_seqfile() helper for seq_file entries")
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

b8f3d1635103 ath9k: debug: remove set but not used variable 'fops_dump_nfcal'

-- 
https://patchwork.kernel.org/patch/10593539/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

