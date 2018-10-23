Return-Path: <SRS0=ht5v=ND=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 188E1C67863
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Oct 2018 19:33:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD37220651
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Oct 2018 19:33:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DD37220651
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=perches.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728929AbeJXD6O (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 23 Oct 2018 23:58:14 -0400
Received: from smtprelay0056.hostedemail.com ([216.40.44.56]:44235 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728813AbeJXD6O (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Oct 2018 23:58:14 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id A82C1181D3417;
        Tue, 23 Oct 2018 19:33:26 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: burst07_1dddc9ae52951
X-Filterd-Recvd-Size: 1714
Received: from XPS-9350.home (unknown [47.151.153.53])
        (Authenticated sender: joe@perches.com)
        by omf02.hostedemail.com (Postfix) with ESMTPA;
        Tue, 23 Oct 2018 19:33:25 +0000 (UTC)
Message-ID: <19b16ca89b5cde607338513638d4ef8e3a3d2802.camel@perches.com>
Subject: Re: [PATCH v2] rtlwifi: remove set but not used variable
 'radiob_array_table' and 'radiob_arraylen'
From:   Joe Perches <joe@perches.com>
To:     zhong jiang <zhongjiang@huawei.com>, kvalo@codeaurora.org
Cc:     davem@davemloft.net, pkshih@realtek.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 23 Oct 2018 12:33:23 -0700
In-Reply-To: <1540283282-9772-1-git-send-email-zhongjiang@huawei.com>
References: <1540283282-9772-1-git-send-email-zhongjiang@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.1-1build1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2018-10-23 at 16:28 +0800, zhong jiang wrote:
> radiob_array_table' and 'radiob_arraylen' are not used after setting its value.
> It is safe to remove the unused variable. Meanwhile, radio B radio should be
> removed as well. because it will no longer be referenced.

The patch subject is a bit off and too generic here.

This is specific to rtl8723ae and not rtlwifi so it is
probably better for the subject to be something like:

[PATCH] rtl8723ae: Remove set but not used variables and #defines

> Signed-off-by: zhong jiang <zhongjiang@huawei.com>
> ---
>  drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.c   | 5 +----
>  drivers/net/wireless/realtek/rtlwifi/rtl8723ae/table.c | 4 ----
>  drivers/net/wireless/realtek/rtlwifi/rtl8723ae/table.h | 2 --

