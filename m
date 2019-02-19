Return-Path: <SRS0=cMLu=Q2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8047EC4360F
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Feb 2019 15:13:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 508C120665
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Feb 2019 15:13:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="VB99Ed44";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ieysnEFE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727972AbfBSPNZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Feb 2019 10:13:25 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:40026 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726352AbfBSPNY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Feb 2019 10:13:24 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 7EF24607EF; Tue, 19 Feb 2019 15:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550589203;
        bh=X/B4+HjvyMS0+Icocb7ERP/t1KnhIFLtApZvaY4GlJU=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=VB99Ed441Nleln6c9ibvBcIO+Jsca5NvJmZxwo11WWpzVAYGgDMzv9IQXwX+XBeeK
         whBNJaai9c12dF6gYyKSi1jRBiZcdWrB5IV5K4/HLcdk627AE/gvgQZaSPlCrGY2k3
         4ETukGK9VhxYw8OhyGVAFjx8tHpDp9RhsOmTo78k=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B52036071A;
        Tue, 19 Feb 2019 15:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550589202;
        bh=X/B4+HjvyMS0+Icocb7ERP/t1KnhIFLtApZvaY4GlJU=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=ieysnEFEg2i3VMjxAjWSGyOcu0wdpoC2EUC7h2zMp+SGJ3MHdbpRV4Uo7YUYOYPCX
         nnVDHW/zq7gAP1bH7omwd/6Ly/x0werC0LbvBRYqa3rSxKQXl45JCAHxNKR9Hy7ZBU
         kZAyb6IarZYdh27G5dcZgKiIntqP3pu/LPIl3fGk=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B52036071A
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/3] libertas_tf: move hardware callbacks to a separate
 structure
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190210195217.18817-2-lkundrak@v3.sk>
References: <20190210195217.18817-2-lkundrak@v3.sk>
To:     Lubomir Rintel <lkundrak@v3.sk>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lubomir Rintel <lkundrak@v3.sk>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190219151323.7EF24607EF@smtp.codeaurora.org>
Date:   Tue, 19 Feb 2019 15:13:23 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Lubomir Rintel <lkundrak@v3.sk> wrote:

> We'll need to talk to the firmware to get a hardware address before
> device is registered with ieee80211 subsystem at the end of
> lbtf_add_card(). Hooking the callbacks after that is too late.
> 
> Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
> Reviewed-by: Steve deRosier <derosier@cal-sierra.com>

Failed to compile:

drivers/net/wireless/marvell/libertas_tf/main.c: In function 'lbtf_add_card':
drivers/net/wireless/marvell/libertas_tf/main.c:603:309: error: 'udev' undeclared (first use in this function); did you mean 'cdev'?
   lbtf_deb_usbd(&udev->dev, "Error programming the firmware\n");
                                                                                                                                                                                                                                                                                                                     ^   
                                                                                                                                                                                                                                                                                                                     cdev
drivers/net/wireless/marvell/libertas_tf/main.c:603:309: note: each undeclared identifier is reported only once for each function it appears in
make[5]: *** [drivers/net/wireless/marvell/libertas_tf/main.o] Error 1
make[5]: *** Waiting for unfinished jobs....
make[4]: *** [drivers/net/wireless/marvell/libertas_tf] Error 2
make[3]: *** [drivers/net/wireless/marvell] Error 2
make[3]: *** Waiting for unfinished jobs....
make[2]: *** [drivers/net/wireless] Error 2
make[1]: *** [drivers/net] Error 2
make[1]: *** Waiting for unfinished jobs....
make: *** [drivers] Error 2

3 patches set to Changes Requested.

10804885 [1/3] libertas_tf: move hardware callbacks to a separate structure
10804881 [2/3] libertas_tf: don't defer firmware loading until start()
10804883 [3/3] libertas_tf: get the MAC address before registering the device

-- 
https://patchwork.kernel.org/patch/10804885/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

