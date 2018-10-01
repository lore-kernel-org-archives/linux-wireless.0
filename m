Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F3D6C43143
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 10:07:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 698842084C
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 10:07:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 698842084C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729067AbeJAQoC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Oct 2018 12:44:02 -0400
Received: from mail-wm1-f46.google.com ([209.85.128.46]:39072 "EHLO
        mail-wm1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728791AbeJAQoB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Oct 2018 12:44:01 -0400
Received: by mail-wm1-f46.google.com with SMTP id q8-v6so8106241wmq.4
        for <linux-wireless@vger.kernel.org>; Mon, 01 Oct 2018 03:07:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=SVRGqnvTAgOahDfrIlZ3+cU2XNbIITzprTVXajYfDjw=;
        b=Hrn8b6+GA1uF4jIMjglr4wUMewrPPIr3b4k0hJvHsshn0IZgTNB4902Lm0yfMwPyMu
         gPCARt9MzeRhbic/Xmrxpx2L7ZH6nRV+yBi9K59QX/SMhK9lJ4qk4vmL+276Ehugit8/
         RIWHUFk9ej25HRG0JKhQPtB6hwF+XVYbtfd1ohr5Byl6IOiP+hmKlwhjgDGFP0DkwD5N
         7AD0CwPzOvacZR5zCXDUw07UVNtroLRfCO75AmsLgy+TiZrysIAqyG8pi92BpnReMALJ
         HwdtBKqtIu6pXuuvgL47GAV3riM5k2N3qyzdDBzl6USczo80SZsNREKBGGWQc9C3C6xH
         8ulA==
X-Gm-Message-State: ABuFfogZFPqhecCLXBplKWpbgQ/4zFPaPG1oqqoWN4NywTdvvYHUsBMv
        eVnJ43NYmAhKGdvphXR3tELzhQ==
X-Google-Smtp-Source: ACcGV615mC9KI1dNbXpIUNszU8naGdyBXM4ZJtg+xFgvsXGxNSnTMtP40jcuF+rNw/7+MSyFPQSSsQ==
X-Received: by 2002:a1c:d00c:: with SMTP id h12-v6mr8053217wmg.107.1538388419223;
        Mon, 01 Oct 2018 03:06:59 -0700 (PDT)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id z21-v6sm7472662wmi.29.2018.10.01.03.06.58
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 01 Oct 2018 03:06:59 -0700 (PDT)
Date:   Mon, 1 Oct 2018 12:06:56 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     nbd@nbd.name, linux-wireless@vger.kernel.org
Subject: Re: [RFC 4/5] mt76: move mt76x02_mac_write_txwi in mt76x02-lib module
Message-ID: <20181001100656.GC3055@localhost.localdomain>
References: <20180929174456.995-5-lorenzo.bianconi@redhat.com>
 <20181001054838.GC22206@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181001054838.GC22206@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> On Sat, Sep 29, 2018 at 07:44:55PM +0200, Lorenzo Bianconi wrote:
> > +	if (dev->drv->get_tx_txpwr_adj) {
> > +		txpwr_adj = dev->drv->get_tx_txpwr_adj(dev, dev->txpower_conf,
> > +						       max_txpwr_adj);
> > +		txwi->ctl2 = FIELD_PREP(MT_TX_PWR_ADJ, txpwr_adj);
> > +	}
> > +
> > +	if (is_mt76x2(dev) && mt76_rev(dev) >= MT76XX_REV_E4)
> > +		txwi->txstream = 0x13;
> > +	else if (is_mt76x2(dev) && mt76_rev(dev) >= MT76XX_REV_E3 &&
> > +		 !(txwi->rate & cpu_to_le16(rate_ht_mask)))
> > +		txwi->txstream = 0x93;
> 
> All above looks mt76x2 specific, maybe would be beter to place this in 
> in setup_txwi() calback i.e:
> 
> 	if (dev->drv->setup_txwi)
> 		drv->drv->setup_txwi(...)
> 
> or maybe you plan to implement get_tx_txpwr_adj() for mt76x0 as well,
> is this feature supported by the MT76x0 chips ?

For the moment tpc is supported just for mt76x2 chipsets but tx power subfield
is present in mt76x0_txwi as well. Moreover merging mt76x2_dev and mt76x0_dev
in mt76x02_dev allows us to move mt76x2_get_tx_txpwr_adj() in mt76x02-lib
module, remove get_tx_txpwr_adj callback and just make tpc disabled for mt76x0
for the moment.
As suggested by Felix, we can take into account chainmask for txstream
configuration and remove is_mt76x2() check.
Agree?

Regards,
Lorenzo

> 
> Thanks
> Stanislaw
