Return-Path: <SRS0=z7UY=PZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C28C5C43387
	for <linux-wireless@archiver.kernel.org>; Thu, 17 Jan 2019 19:59:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 91AD920851
	for <linux-wireless@archiver.kernel.org>; Thu, 17 Jan 2019 19:59:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729293AbfAQT7r (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 17 Jan 2019 14:59:47 -0500
Received: from smtprelay0098.hostedemail.com ([216.40.44.98]:56806 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728830AbfAQT7r (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Jan 2019 14:59:47 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay01.hostedemail.com (Postfix) with ESMTP id 5AC50100E86C0;
        Thu, 17 Jan 2019 19:59:45 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: rose26_1abcde36c9943
X-Filterd-Recvd-Size: 2663
Received: from XPS-9350.home (unknown [47.151.153.53])
        (Authenticated sender: joe@perches.com)
        by omf02.hostedemail.com (Postfix) with ESMTPA;
        Thu, 17 Jan 2019 19:59:43 +0000 (UTC)
Message-ID: <23fbcc92e52dea477ea16f02cced239f4afcba9a.camel@perches.com>
Subject: Re: [PATCH] rtlwifi: rtl818x: fix indentation issue
From:   Joe Perches <joe@perches.com>
To:     Larry Finger <Larry.Finger@lwfinger.net>,
        Colin King <colin.king@canonical.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ping-Ke Shih <pkshih@realtek.com>
Date:   Thu, 17 Jan 2019 11:59:42 -0800
In-Reply-To: <284e7ef0-5820-021b-7b0c-2fc754440fe8@lwfinger.net>
References: <20190117152859.6873-1-colin.king@canonical.com>
         <e68c7ae7b0a863742df0f4457368a3a529ed47e5.camel@perches.com>
         <284e7ef0-5820-021b-7b0c-2fc754440fe8@lwfinger.net>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.1-1build1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2019-01-17 at 13:33 -0600, Larry Finger wrote:
> On 1/17/19 1:29 PM, Joe Perches wrote:
> > On Thu, 2019-01-17 at 15:28 +0000, Colin King wrote:
> > > From: Colin Ian King <colin.king@canonical.com>
> > > 
> > > There is a statement that is indented too deeply. Fix this.
> > 
> > Thanks.
> > 
> > > diff --git a/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c b/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c
> > []
> > > @@ -803,7 +803,7 @@ static void rtl8180_config_cardbus(struct ieee80211_hw *dev)
> > >   		rtl818x_iowrite16(priv, FEMR_SE, 0xffff);
> > >   	} else {
> > >   		reg16 = rtl818x_ioread16(priv, &priv->map->FEMR);
> > > -			reg16 |= (1 << 15) | (1 << 14) | (1 << 4);
> > > +		reg16 |= (1 << 15) | (1 << 14) | (1 << 4);
> > >   		rtl818x_iowrite16(priv, &priv->map->FEMR, reg16);
> > >   	}
> > 
> > trivia:
> > 
> > It sure looks as if there could be some rather useful
> > conversions of magic bits to constants one day.
> 
> How much work is warranted for this driver for a device that is not likely in 
> use anywhere in the wild?

Hey Larry.

Perhaps none.  The part is from 2002 after all.

But if it really is unused, it might be better to remove
the whole driver and see if anyone notices.

> In addition, I'm not sure anyone knows what those bits 
> actually do, I certainly do not have a product sheet for that one.

It does look like this document
http://realtek.info/pdf/rtl8180.pdf
has a description on page 36.

6.33 FEMR: Function Event Mask Register


