Return-Path: <SRS0=wUDZ=DN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B612C46466
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Oct 2020 04:10:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0ACE7208B6
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Oct 2020 04:10:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726022AbgJFEKo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Oct 2020 00:10:44 -0400
Received: from smtprelay0024.hostedemail.com ([216.40.44.24]:40432 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725874AbgJFEKo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Oct 2020 00:10:44 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id 393D91DF1;
        Tue,  6 Oct 2020 04:10:43 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: view38_5e06219271c3
X-Filterd-Recvd-Size: 2228
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf07.hostedemail.com (Postfix) with ESMTPA;
        Tue,  6 Oct 2020 04:10:41 +0000 (UTC)
Message-ID: <50eab5822b5c0557a5e7a8f5ab8ee42f5bdea0ec.camel@perches.com>
Subject: Re: [PATCH] rtlwifi: rtl8192se: remove duplicated
 legacy_httxpowerdiff
From:   Joe Perches <joe@perches.com>
To:     Chris Chiu <chiu@endlessos.org>, pkshih@realtek.com,
        kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 05 Oct 2020 21:10:40 -0700
In-Reply-To: <20201006035928.5566-1-chiu@endlessm.com>
References: <20201006035928.5566-1-chiu@endlessm.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2020-10-06 at 11:59 +0800, Chris Chiu wrote:
> From: Chris Chiu <chiu@endlessos.org>
> 
> The legacy_httxpowerdiff in rtl8192se is pretty much the same as
> the legacy_ht_txpowerdiff for other chips. Use the same name to
> keep the consistency.
> 
> Signed-off-by: Chris Chiu <chiu@endlessos.org>
> ---
>  drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c | 2 +-
>  drivers/net/wireless/realtek/rtlwifi/rtl8192se/rf.c | 2 +-
>  drivers/net/wireless/realtek/rtlwifi/wifi.h         | 1 -
>  3 files changed, 2 insertions(+), 3 deletions(-)

Then can't all the struct definitions that include legacy_ht_txpowerdiff
other than wifi.h delete it too?

$ git grep -P -n '\blegacy_ht_?txpower' -- '*.h'
drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.h:162:       u8 legacy_ht_txpowerdiff;
drivers/net/wireless/realtek/rtlwifi/rtl8192c/phy_common.h:155: u8 legacy_ht_txpowerdiff;
drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.h:140:       u8 legacy_ht_txpowerdiff;
drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.h:170:       u8 legacy_ht_txpowerdiff;
drivers/net/wireless/realtek/rtlwifi/wifi.h:1969:       u8 legacy_httxpowerdiff;        /* Legacy to HT rate power diff */
drivers/net/wireless/realtek/rtlwifi/wifi.h:1980:       u8 legacy_ht_txpowerdiff;       /*Legacy to HT rate power diff */



