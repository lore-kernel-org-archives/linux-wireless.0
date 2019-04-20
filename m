Return-Path: <SRS0=vWlE=SW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E66AC282E3
	for <linux-wireless@archiver.kernel.org>; Sat, 20 Apr 2019 15:51:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 68BA82087F
	for <linux-wireless@archiver.kernel.org>; Sat, 20 Apr 2019 15:51:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728151AbfDTPvR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 20 Apr 2019 11:51:17 -0400
Received: from mail5.windriver.com ([192.103.53.11]:33658 "EHLO mail5.wrs.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725920AbfDTPvQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 20 Apr 2019 11:51:16 -0400
Received: from ALA-HCB.corp.ad.wrs.com (ala-hcb.corp.ad.wrs.com [147.11.189.41])
        by mail5.wrs.com (8.15.2/8.15.2) with ESMTPS id x3KFobfx030816
        (version=TLSv1 cipher=AES128-SHA bits=128 verify=FAIL);
        Sat, 20 Apr 2019 08:50:48 -0700
Received: from yow-pgortmak-d1.corp.ad.wrs.com (128.224.56.57) by
 ALA-HCB.corp.ad.wrs.com (147.11.189.41) with Microsoft SMTP Server id
 14.3.439.0; Sat, 20 Apr 2019 08:50:09 -0700
Received: by yow-pgortmak-d1.corp.ad.wrs.com (Postfix, from userid 1000)        id
 2CC9A2E03FD; Sat, 20 Apr 2019 11:50:09 -0400 (EDT)
Date:   Sat, 20 Apr 2019 11:50:09 -0400
From:   Paul Gortmaker <paul.gortmaker@windriver.com>
To:     Larry Finger <Larry.Finger@lwfinger.net>
CC:     <linux-next@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>
Subject: [linux-next] rtlwifi commit contains a patch reject file
Message-ID: <20190420155008.GM23044@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

I'm kind of surprised sfr doesn't have a bot to complain when it sees
a foo.c.rej or foo.c.orig in a commit...

Paul.
---

$ git show --stat ddab2eee794
commit ddab2eee7949f94b8ecdc5c84ae238826142d35d
Author: Larry Finger <Larry.Finger@lwfinger.net>
Date:   Thu Apr 4 13:29:31 2019 -0500

    rtlwifi: Convert the wake_match variable to local
    
    In five of the drivers, the contents of bits 29-31 of one of the RX
    descriptors is used to set bits in a variable that is used to save the
    wakeup condition for output in a debugging statement. The resulting
    variable is not used anywhere else even though it is stored in a struct
    and could be available in other routines. This variable is changed to be
    local.
    
    Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
    Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c     | 15 ++++++++-------
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c.rej | 10 ++++++++++
 drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c     | 13 +++++++------
 drivers/net/wireless/realtek/rtlwifi/rtl8723be/trx.c     | 14 +++++++-------
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.c     | 14 +++++++-------
 drivers/net/wireless/realtek/rtlwifi/wifi.h              |  1 -
 6 files changed, 39 insertions(+), 28 deletions(-)

 ---

$ git describe --contains ddab2eee794
next-20190415~86^2~1

$ git show next-20190415~86
commit e4aee692121581ee2b29812f0db701769ef3f571
Merge: 61405eeb69ab bdfc4027de15
Author: Stephen Rothwell <sfr@canb.auug.org.au>
Date:   Mon Apr 15 12:08:21 2019 +1000

    Merge remote-tracking branch 'wireless-drivers-next/master'
