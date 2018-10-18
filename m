Return-Path: <SRS0=Zpd3=M6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C40FCC5ACCC
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Oct 2018 09:45:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9604F208E4
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Oct 2018 09:45:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9604F208E4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727980AbeJRRpg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 18 Oct 2018 13:45:36 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43447 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727363AbeJRRpg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Oct 2018 13:45:36 -0400
Received: by mail-wr1-f66.google.com with SMTP id n1-v6so32901853wrt.10
        for <linux-wireless@vger.kernel.org>; Thu, 18 Oct 2018 02:45:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=QqUWq/4zrkbnXIdj8gAJD1MFDy06RJMIzNYb8Gj9sn8=;
        b=T0teyyLrqeaZcoir1866FJXkEdgeXRQVDcDTXM1TVYJABd13NAqHBX0ZBpUWz1ka+O
         y7haCIcRS5sLewg151xW37LsrrbEz+NhYvId0T4CPXaDqCcbXfchDOfy28iVcZNEjBzw
         ThloKmeCO5rdmybJEv8SsyD/0RY4zWElqkanNQ5sMABpWm+SqG6OpFwF+qSRO+ZwdLN1
         s32l0a1GxAdLdPB6WlQJOWQ4ToWAQoQ3JjE7FogiWBwngffOY1C6ldfXrMoP8C20zsE/
         zTqB+LW/ggJ6KXQATpkTXfrFEvtY113rfoutPNlEjldbS5kjnINwq30H4iqzgqI/rgat
         Gerw==
X-Gm-Message-State: ABuFfoiOadlN2Oh6eXKu+TP1s7Gmkeq+L9SyuGxeYwn15CcEOVRXK13i
        ZNHTiZF0VXwJPojEl2C9xjuCnw==
X-Google-Smtp-Source: ACcGV61QXnpznZAimsMUB7rZ00Er1gvyRH6APWIiX09yRNhQjL+4n4YQKNTJH7K0EQ1cGtyBQzt6qw==
X-Received: by 2002:a5d:610c:: with SMTP id v12-v6mr27887166wrt.308.1539855923662;
        Thu, 18 Oct 2018 02:45:23 -0700 (PDT)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id l4-v6sm21302166wrb.92.2018.10.18.02.45.22
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 18 Oct 2018 02:45:23 -0700 (PDT)
Date:   Thu, 18 Oct 2018 11:45:20 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mt76x0: antenna select corrections
Message-ID: <20181018094519.GD4938@localhost.localdomain>
References: <1539850059-11886-1-git-send-email-sgruszka@redhat.com>
 <20181018091335.GB4938@localhost.localdomain>
 <20181018092146.GC2190@redhat.com>
 <20181018092819.GC4938@localhost.localdomain>
 <20181018094055.GA6294@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181018094055.GA6294@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> On Thu, Oct 18, 2018 at 11:28:19AM +0200, Lorenzo Bianconi wrote:
> > > On Thu, Oct 18, 2018 at 11:13:36AM +0200, Lorenzo Bianconi wrote:
> > > > >  static void mt76x0_phy_ant_select(struct mt76x02_dev *dev)
> > > > >  {
> > > > > -	struct ieee80211_channel *chan = dev->mt76.chandef.chan;
> > > > > -
> > > > > -	/* single antenna mode */
> > > > > -	if (chan->band == NL80211_BAND_2GHZ) {
> > > > > -		mt76_rmw(dev, MT_COEXCFG3,
> > > > > -			 BIT(5) | BIT(4) | BIT(3) | BIT(2), BIT(1));
> > > > > -		mt76_rmw(dev, MT_WLAN_FUN_CTRL, BIT(5), BIT(6));
> > > > > +	u16 ee_ant = mt76x02_eeprom_get(dev, MT_EE_ANTENNA);
> > > > > +	u16 nic_conf2 = mt76x02_eeprom_get(dev, MT_EE_NIC_CONF_2);
> > > > > +	u32 wlan, coex3, cmb;
> > > > > +	bool ant_div;
> > > > > +
> > > > > +	wlan = mt76_rr(dev, MT_WLAN_FUN_CTRL);
> > > > > +	cmb = mt76_rr(dev, MT_CMB_CTRL);
> > > > > +	coex3 = mt76_rr(dev, MT_COEXCFG3);
> > > > > +
> > > > > +	cmb   &= ~(BIT(15) | BIT(12));
> > > > 
> > > > I guess should be BIT(14) here (at least for single antenna mode)
> > > 
> > > Yes , I will fix it.
> > > 
> > > > > +	coex3 &= ~GENMASK(5, 1);
> > > > 
> > > > according to vendor sdk BIT(1) should not cleared if device supports 5GHz band
> > > > (signle antenna mode)
> > > 
> > > It is set below for that case:
> > 
> > it is set just if the device does not support 5GHz band but it is cleared in
> > the other case (and sdk driver does not clear it in that case, do not know if
> > it does a real difference)
> 
> On GPL realeased driver for MT7610U ( mt7610u_wifi_sta_v3002_dpo_2013091 )
> it's like this:
> 
>         CoexCfg3 &= ~(BIT5 | BIT4 | BIT3 | BIT2 | BIT1);

here I have:

	CoexCfg3 &= ~(BIT5 | BIT4 | BIT3 | BIT2);

> 
> 	<snip>
> 
>         {
>                 if (WMODE_CAP_5G(pAd->CommonCfg.PhyMode))
>                 {
>                         CoexCfg3 |= (BIT3 | BIT4); /* 0x4C[3]=1, 0x4C[4]=1 */
>                 }
>                 else
>                 {
>                         WlanFunCtrl |= BIT6; /* 0x80[6]=1 */
>                         CoexCfg3 |= BIT1; /* 0x4C[1]=1 */
>                 }
>                 DBGPRINT(RT_DEBUG_ERROR, ("%s - Single antenna mode\n", __FUNCTION__));
>         }
> 
> Which I belive is reflected in my patch in this parts:
> 

correct :)

> 	coex3 &= ~GENMASK(5, 1);
> 
> 	<snip>
> 
> 	if (dev->mt76.cap.has_5ghz) {
> 		coex3 |= BIT(3) | BIT(4);
> 	} else {
> 		wlan |= BIT(6);
> 		coex3 |= BIT(1);
> 	}
> 
> Does your SDK do something diffrent ?
> 
> Thanks
> Stanislaw
