Return-Path: <SRS0=rx5y=NU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80C09C43441
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 12:51:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 51A0F2081C
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 12:51:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 51A0F2081C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727755AbeKIWbg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 9 Nov 2018 17:31:36 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33057 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727667AbeKIWbg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Nov 2018 17:31:36 -0500
Received: by mail-wr1-f67.google.com with SMTP id u9-v6so1798493wrr.0
        for <linux-wireless@vger.kernel.org>; Fri, 09 Nov 2018 04:51:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=EqNouc3POz8mxaX1FW3/E0WKLBE2y/U0YJBOv3fd3Vg=;
        b=FccAidRlafpHXxdvW7qlt95SHtE3txR6cFgYbKaFIwKPCtSWzdFx+JyVAyFn8fsKRs
         v7f6oB2O3D5jwskOP1Bi4/FwGsQLHbYe8Zn+O6T8xZuR9RrSICSNSuJXcPPDT7PSBrEd
         UwsEjqeWobA+0wpVm2MyPR72BbqEKmMJZq6UfV/x0oRmwQGHMml/BTLnPOoznH9s2CFf
         Ot5UiuSm8C/PqKTwfaXkYFjUT5gaVxQe6xyTjxnVtMqExNEjqFaMLMivC7yTaI6OA8sR
         gv14Jdkz/6Y4CxTCZLzjncv/JVYEJoLkLwL8yL8zY3DdiS4fMETnT9JnOGFyxVbFBRM7
         P2QA==
X-Gm-Message-State: AGRZ1gIaR77IRA1afM5XqCCPHRLQX2ZNWW5opxHFrttQLrcg9CECNxlp
        iXxdTTG6co/a+aCltPakF4snlw==
X-Google-Smtp-Source: AJdET5e5xcOhPc2XhjyuxcyNv390gAs8UA76ScKfYEWTbYvnAYQRYl0Obd6SD63wURvBMhAYtZ+F3w==
X-Received: by 2002:adf:9441:: with SMTP id 59-v6mr7631824wrq.305.1541767865872;
        Fri, 09 Nov 2018 04:51:05 -0800 (PST)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id t69-v6sm1365157wmt.5.2018.11.09.04.51.04
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 09 Nov 2018 04:51:05 -0800 (PST)
Date:   Fri, 9 Nov 2018 13:50:51 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Stanislaw Gruszka <sgruszka@redhat.com>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/5] mt76x02: correct set bssid for STA
Message-ID: <20181109125050.GH4174@localhost.localdomain>
References: <1541758814-2046-1-git-send-email-sgruszka@redhat.com>
 <1541758814-2046-2-git-send-email-sgruszka@redhat.com>
 <20181109110949.GD4174@localhost.localdomain>
 <d77ed144-f37a-0612-9c28-398704496aaa@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d77ed144-f37a-0612-9c28-398704496aaa@nbd.name>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> On 2018-11-09 12:09, Lorenzo Bianconi wrote:
> >> Use MT_MAC_APC_BSSID0_H_EN bit to indicatate we are
> >> setting BSSID for STA.
> >> 
> >> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> >> ---
> >>  drivers/net/wireless/mediatek/mt76/mt76x02_mac.c | 12 +++++++++---
> >>  1 file changed, 9 insertions(+), 3 deletions(-)
> >> 
> >> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
> >> index 59b336e34cb5..cfeae5586897 100644
> >> --- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
> >> +++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
> >> @@ -826,10 +826,16 @@ void mt76x02_mac_work(struct work_struct *work)
> >>  
> >>  void mt76x02_mac_set_bssid(struct mt76x02_dev *dev, u8 idx, const u8 *addr)
> >>  {
> >> +	u32 bssid_h = FIELD_PREP(MT_MAC_APC_BSSID_H_ADDR,
> >> +				 get_unaligned_le16(addr + 4));
> >> +	u32 bssid_l = get_unaligned_le32(addr);
> >> +
> >> +	if (idx > 7)
> >> +		bssid_h |= MT_MAC_APC_BSSID0_H_EN;
> > 
> > This bit is to enable APClient mode and it is valid just for register 0x1094
> > (MT_MAC_APC_BSSID_{L,h}(0)). Moreover IIRC APClient has been disabled because
> > it causes a performance degradation.
> The performance degradation was with MAC_ADDR_EXT, not AP-Client.
> This patch should be fine.

Ah, now I remember sorry, you are right :)
Anyway IIRC MT_MAC_APC_BSSID0_H_EN is just for AP_CLIENT_BSSID0 (at least for
76x2), for others we need to use BIT(31) but just if APClient is disabled, right?
Moreover BSSID filter is currently disabled (BIT(3) in RX_FILTER_CFG).

# echo 0x1400 > /sys/kernel/debug/ieee80211/phy0/mt76/regidx
# cat /sys/kernel/debug/ieee80211/phy0/mt76/regval
0x00017f97

Have you tried to enabled it?

Regards,
Lorenzo

> 
> - Felix
