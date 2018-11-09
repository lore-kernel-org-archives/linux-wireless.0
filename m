Return-Path: <SRS0=rx5y=NU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BFEAC43441
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 13:42:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C5B02081C
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 13:42:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5C5B02081C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727951AbeKIXW4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 9 Nov 2018 18:22:56 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:33618 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727784AbeKIXW4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Nov 2018 18:22:56 -0500
Received: by mail-wm1-f66.google.com with SMTP id f19-v6so3822024wmb.0
        for <linux-wireless@vger.kernel.org>; Fri, 09 Nov 2018 05:42:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Scfanlu+SSx1CBJztpWs8yMAa9ANHDWf5b6EcwA0pgs=;
        b=kU99h/7iaprZwZz73GmYI/+CHFSMWGmWII81LGGjiMJM5oGN9VtV0xKiy7/7B8F9vz
         ff2soAQpIjDxpYaSiNYKoMa+MaDXkU/0YFxRpGzx6ANk3Sldlyt1HycT2SMiwBCF3FB/
         AoBpZc6dYElRDh3wF2Iz843g0X7sGoeXFY4iZRAeuxotniM2VF1yE9CTejAtePJD1WdM
         pqwmpIiODDqhcH8bBuQ7Ru8IXEKRs8Lll9RvEcXfJCpdn2wrtKcq8Rgsb5AXf4TKK5BZ
         7ICvbCBV1lynzBovGf9HXu6C4U6I4/i3thNAlovZuHKZdkLc/5FE8+Aeuq0kdKoZtAtA
         uq6w==
X-Gm-Message-State: AGRZ1gIyKicgi+OAfug8Fr/ndpzVinUWpS7psCShRwrvt/yGpBhNRC/P
        nXFzeAvIg+XZryXILVMgAYUtpw==
X-Google-Smtp-Source: AJdET5ck3PSZ5uQdDvPWZIdajszjAl0SCpTXoDIx/Ooco8SZ3GwcB+rCiclL0n4Z37CxgGM5t5sOug==
X-Received: by 2002:a1c:a5d6:: with SMTP id o205-v6mr4476700wme.89.1541770933172;
        Fri, 09 Nov 2018 05:42:13 -0800 (PST)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id b9sm6229046wrx.85.2018.11.09.05.42.12
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 09 Nov 2018 05:42:12 -0800 (PST)
Date:   Fri, 9 Nov 2018 14:42:08 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/5] mt76x02: correct set bssid for STA
Message-ID: <20181109134208.GB9453@localhost.localdomain>
References: <1541758814-2046-1-git-send-email-sgruszka@redhat.com>
 <1541758814-2046-2-git-send-email-sgruszka@redhat.com>
 <20181109110949.GD4174@localhost.localdomain>
 <d77ed144-f37a-0612-9c28-398704496aaa@nbd.name>
 <20181109125050.GH4174@localhost.localdomain>
 <20181109132639.GC8054@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181109132639.GC8054@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> On Fri, Nov 09, 2018 at 01:50:51PM +0100, Lorenzo Bianconi wrote:
> > > On 2018-11-09 12:09, Lorenzo Bianconi wrote:
> > > >> Use MT_MAC_APC_BSSID0_H_EN bit to indicatate we are
> > > >> setting BSSID for STA.
> > > >> 
> > > >> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> > > >> ---
> > > >>  drivers/net/wireless/mediatek/mt76/mt76x02_mac.c | 12 +++++++++---
> > > >>  1 file changed, 9 insertions(+), 3 deletions(-)
> > > >> 
> > > >> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
> > > >> index 59b336e34cb5..cfeae5586897 100644
> > > >> --- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
> > > >> +++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
> > > >> @@ -826,10 +826,16 @@ void mt76x02_mac_work(struct work_struct *work)
> > > >>  
> > > >>  void mt76x02_mac_set_bssid(struct mt76x02_dev *dev, u8 idx, const u8 *addr)
> > > >>  {
> > > >> +	u32 bssid_h = FIELD_PREP(MT_MAC_APC_BSSID_H_ADDR,
> > > >> +				 get_unaligned_le16(addr + 4));
> > > >> +	u32 bssid_l = get_unaligned_le32(addr);
> > > >> +
> > > >> +	if (idx > 7)
> > > >> +		bssid_h |= MT_MAC_APC_BSSID0_H_EN;
> > > > 
> > > > This bit is to enable APClient mode and it is valid just for register 0x1094
> > > > (MT_MAC_APC_BSSID_{L,h}(0)). Moreover IIRC APClient has been disabled because
> > > > it causes a performance degradation.
> > > The performance degradation was with MAC_ADDR_EXT, not AP-Client.
> > > This patch should be fine.
> > 
> > Ah, now I remember sorry, you are right :)
> > Anyway IIRC MT_MAC_APC_BSSID0_H_EN is just for AP_CLIENT_BSSID0 (at least for
> > 76x2), for others we need to use BIT(31) but just if APClient is disabled, right?
> > Moreover BSSID filter is currently disabled (BIT(3) in RX_FILTER_CFG).
> > 
> > # echo 0x1400 > /sys/kernel/debug/ieee80211/phy0/mt76/regidx
> > # cat /sys/kernel/debug/ieee80211/phy0/mt76/regval
> > 0x00017f97
> > 
> > Have you tried to enabled it?
> 
> I didn't try this yet, but I think it should be enabled to support
> mulit BSS and MAC address change. 

I agree we can use multi-BSS for mac filtering in AP mode but my gut feeling in
STA the hw uses the value in MT_MAC_ADDR_DW{0,1} for unicast packet filtering
(BIT(2) in RX_FILTER_CFG). Moreover I think there is a relation between
MT_MAC_ADDR_DW and BSSID values in multiAP mode.

Regards,
Lorenzo

> 
> However I still don't know how to set multiple bssid for STA,
> Use BIT(31) or BIT(16) as indicator or maybe 
> just write BSSID to MT_MAC_APC_BSSID_{H,L} and hardware will
> recognize this is not AP BSSID ?
> 
> Thanks
> Stanislaw
