Return-Path: <SRS0=pQzZ=MS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 801D7ECDE44
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Oct 2018 20:17:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B79621473
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Oct 2018 20:17:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4B79621473
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=perches.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727841AbeJGDW0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 6 Oct 2018 23:22:26 -0400
Received: from smtprelay0077.hostedemail.com ([216.40.44.77]:44570 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726204AbeJGDW0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 6 Oct 2018 23:22:26 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay08.hostedemail.com (Postfix) with ESMTP id 97002182CED34;
        Sat,  6 Oct 2018 20:17:46 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: field96_9711a1a8a32b
X-Filterd-Recvd-Size: 2616
Received: from XPS-9350.home (unknown [47.151.153.53])
        (Authenticated sender: joe@perches.com)
        by omf14.hostedemail.com (Postfix) with ESMTPA;
        Sat,  6 Oct 2018 20:17:44 +0000 (UTC)
Message-ID: <4e376919169bad265dc02040ae02548d2ac6c503.camel@perches.com>
Subject: Re: [PATCH] rtlwifi: rtl8821ae: add in a missing break in switch
 statement
From:   Joe Perches <joe@perches.com>
To:     Larry Finger <Larry.Finger@lwfinger.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        Colin King <colin.king@canonical.com>
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Tsang-Shian Lin <thlin@realtek.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Sat, 06 Oct 2018 13:17:43 -0700
In-Reply-To: <a5113f03-7ac8-4be6-3d1c-5ba74639121e@lwfinger.net>
References: <20181006184246.29985-1-colin.king@canonical.com>
         <87r2h2euuy.fsf@kamboji.qca.qualcomm.com>
         <a5113f03-7ac8-4be6-3d1c-5ba74639121e@lwfinger.net>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.1-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sat, 2018-10-06 at 15:05 -0500, Larry Finger wrote:
> On 10/6/18 2:30 PM, Kalle Valo wrote:
> > Colin King <colin.king@canonical.com> writes:
> > 
> > > From: Colin Ian King <colin.king@canonical.com>
> > > 
> > > The switch case RATR_INX_WIRELESS_MC has a missing break, this seems
> > > to be unintentional as the setting of variable ret gets overwritten
> > > when the case falls through to the following RATR_INX_WIRELESS_AC_5N
> > > case.  Fix this by adding in the missing break.
> > > 
> > > Detected by CoverityScan, CID#1167237 ("Missing break in switch")
> > > 
> > > Fixes: 3c05bedb5fef ("Staging: rtl8812ae: Add Realtek 8821 PCI WIFI driver")
> > > Signed-off-by: Colin Ian King <colin.king@canonical.com>
> > > ---
> > >   drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c | 1 +
> > 
> > Is the fixes line correct? This patch is not for staging.
> 
> No, the correct fixes commit is 21e4b0726dc67 (" rtlwifi: rtl8821ae: Move driver  
> from staging to regular tree").
> 
> This driver was initially placed in staging as it was needed for a special 
> project, which is the commit that Colin used. As the patch subject states, the 
> driver was later moved to the regular wireless tree.
> 
> That break is required, thus ACKed-by: Larry Finger <Larry.Finger@lwfinger.net>

Why not remove this entirely and use the generic routine in
drivers/net/wireless/realtek/rtlwifi/base.c?

Is there a real difference?

