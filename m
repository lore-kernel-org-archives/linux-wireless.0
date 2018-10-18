Return-Path: <SRS0=Zpd3=M6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 581D6C5ACCC
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Oct 2018 09:21:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 278722145D
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Oct 2018 09:21:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 278722145D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727455AbeJRRV6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 18 Oct 2018 13:21:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45390 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727360AbeJRRV6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Oct 2018 13:21:58 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E0A9380462;
        Thu, 18 Oct 2018 09:21:51 +0000 (UTC)
Received: from localhost (unknown [10.43.2.63])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 84E885DD92;
        Thu, 18 Oct 2018 09:21:48 +0000 (UTC)
Date:   Thu, 18 Oct 2018 11:21:47 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mt76x0: antenna select corrections
Message-ID: <20181018092146.GC2190@redhat.com>
References: <1539850059-11886-1-git-send-email-sgruszka@redhat.com>
 <20181018091335.GB4938@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181018091335.GB4938@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Thu, 18 Oct 2018 09:21:51 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Oct 18, 2018 at 11:13:36AM +0200, Lorenzo Bianconi wrote:
> >  static void mt76x0_phy_ant_select(struct mt76x02_dev *dev)
> >  {
> > -	struct ieee80211_channel *chan = dev->mt76.chandef.chan;
> > -
> > -	/* single antenna mode */
> > -	if (chan->band == NL80211_BAND_2GHZ) {
> > -		mt76_rmw(dev, MT_COEXCFG3,
> > -			 BIT(5) | BIT(4) | BIT(3) | BIT(2), BIT(1));
> > -		mt76_rmw(dev, MT_WLAN_FUN_CTRL, BIT(5), BIT(6));
> > +	u16 ee_ant = mt76x02_eeprom_get(dev, MT_EE_ANTENNA);
> > +	u16 nic_conf2 = mt76x02_eeprom_get(dev, MT_EE_NIC_CONF_2);
> > +	u32 wlan, coex3, cmb;
> > +	bool ant_div;
> > +
> > +	wlan = mt76_rr(dev, MT_WLAN_FUN_CTRL);
> > +	cmb = mt76_rr(dev, MT_CMB_CTRL);
> > +	coex3 = mt76_rr(dev, MT_COEXCFG3);
> > +
> > +	cmb   &= ~(BIT(15) | BIT(12));
> 
> I guess should be BIT(14) here (at least for single antenna mode)

Yes , I will fix it.

> > +	coex3 &= ~GENMASK(5, 1);
> 
> according to vendor sdk BIT(1) should not cleared if device supports 5GHz band
> (signle antenna mode)

It is set below for that case:

> > +		if (dev->mt76.cap.has_5ghz) {
> > +			coex3 |= BIT(3) | BIT(4);
> > +		} else {
> > +			wlan |= BIT(6);
> > +			coex3 |= BIT(1);
> > +		}


Thanks
Stanislaw
