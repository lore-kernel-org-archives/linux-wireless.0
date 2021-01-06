Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EB34C4332B
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Jan 2021 16:21:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0076C23130
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Jan 2021 16:21:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727450AbhAFQV0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 6 Jan 2021 11:21:26 -0500
Received: from smtprelay0167.hostedemail.com ([216.40.44.167]:53420 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727290AbhAFQVZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Jan 2021 11:21:25 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id 796781802EF0B;
        Wed,  6 Jan 2021 16:20:44 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: word71_1a13b70274e3
X-Filterd-Recvd-Size: 2436
Received: from [192.168.1.159] (unknown [47.151.137.21])
        (Authenticated sender: joe@perches.com)
        by omf03.hostedemail.com (Postfix) with ESMTPA;
        Wed,  6 Jan 2021 16:20:42 +0000 (UTC)
Message-ID: <ed87ad8d74cd93c9459551ca6cc7ef523adefa7e.camel@perches.com>
Subject: Re: [PATCH] drivers: net: wireless: realtek: Fix the word
 association defautly de-faulty
From:   Joe Perches <joe@perches.com>
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>
Cc:     pkshih@realtek.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org, Larry.Finger@lwfinger.net, zhengbin13@huawei.com,
        baijiaju1990@gmail.com, christophe.jaillet@wanadoo.fr,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 06 Jan 2021 08:20:40 -0800
In-Reply-To: <X/W4r1rmMCnKQAQZ@Gentoo>
References: <20210105101738.13072-1-unixbhaskar@gmail.com>
         <35a634c1-3672-b757-101e-9b8f3c0163a7@infradead.org>
         <X/W4r1rmMCnKQAQZ@Gentoo>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2021-01-06 at 18:48 +0530, Bhaskar Chowdhury wrote:
> Good point Randy, there were several driver file witch have "defautly" in it
> and I tried to correct that.Only that spell made it a "de-faulty" as dic
> suggested . But I think it should be "by default" as you said.

What tool suggested 'de-faulty' with a dash between de and faulty"

I don't believe it was codespell.

$ codespell drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c
drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c:61: cacluated ==> calculated
drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c:190: cacluated ==> calculated
drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c:435: managment ==> management
drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c:817: defautly ==> defaultly

Nor checkpatch:

$ ./scripts/checkpatch.pl -f --terse --nosummary --types=typo_spelling drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c
drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c:61: CHECK: 'cacluated' may be misspelled - perhaps 'calculated'?
drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c:190: CHECK: 'cacluated' may be misspelled - perhaps 'calculated'?
drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c:435: CHECK: 'managment' may be misspelled - perhaps 'management'?


