Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E74CCCA47B
	for <linux-wireless@archiver.kernel.org>; Wed,  8 Jun 2022 08:53:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbiFHIxk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 8 Jun 2022 04:53:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232252AbiFHIws (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Jun 2022 04:52:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E32A82A1D6C
        for <linux-wireless@vger.kernel.org>; Wed,  8 Jun 2022 01:11:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 659E6B81B34
        for <linux-wireless@vger.kernel.org>; Wed,  8 Jun 2022 08:11:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 949C6C34116;
        Wed,  8 Jun 2022 08:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654675868;
        bh=yRUAw4QpAEMZhXXAU33UtTPfm/fafli/8z+ZeGOJqV0=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=tMfKFwScB/Yi27nYvtCbRdDYSfZzE/Y3OxMNmq1dGphyvRmFkOi8H/Mlnm6f9VEND
         M2ABtMR9hq08ZvkPkEmiTqXxCTx7nPOaPt3kY6ksg48DCPBQhbY+GVTbFMgiBXchMU
         bCZI5Gkc6ef8IZ1CLrxci8KNC1fzOCvXfDW9NZGYAHO3BY5Lv5A3ms3GXO5QvfClWN
         8S02A5qgPyGwupAQQH9d7ogaA761iqEXN2eKPtwTZOLv3BtcWGlyZSDHGyxfo93ylA
         C+3KuAhVtaHogpQkgZuNsg+XTz9dwsLpzjVGvWV1h8osJBdEzXIqjDVrCR9SOaye79
         7h9o8QykBVWbA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [v2] wifi: rtw89: support MULTI_BSSID and correct BSSID mask of
 H2C
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220530112743.106857-1-pkshih@realtek.com>
References: <20220530112743.106857-1-pkshih@realtek.com>
To:     Ping-Ke Shih <pkshih@realtek.com>
Cc:     <linux-wireless@vger.kernel.org>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165467586536.10728.12490476035698474540.kvalo@kernel.org>
Date:   Wed,  8 Jun 2022 08:11:07 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Ping-Ke Shih <pkshih@realtek.com> wrote:

> The BSSID mask of H2C is used to match BSSID of receiving packets.
> Normally, we set six bits BSSID mask to exactly match BSSID of packets
> sent by target AP. After we support multiple BSSID, it could connect a
> nontransmitted BSSID, so we can only match first five bytes of BSSID.
> That means we could possibly receive other AP's packets if only the last
> byte of BSSID is different from target AP.
> 
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

Patch applied to wireless-next.git, thanks.

85393ca610de wifi: rtw89: support MULTI_BSSID and correct BSSID mask of H2C

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220530112743.106857-1-pkshih@realtek.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

