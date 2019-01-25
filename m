Return-Path: <SRS0=MEvv=QB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA2C1C282C0
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 09:48:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B09722082E
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 09:48:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728534AbfAYJsL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 25 Jan 2019 04:48:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48150 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728109AbfAYJsL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Jan 2019 04:48:11 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0BDCBA7FDE;
        Fri, 25 Jan 2019 09:48:11 +0000 (UTC)
Received: from localhost (unknown [10.43.2.219])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A07FA10021B1;
        Fri, 25 Jan 2019 09:48:07 +0000 (UTC)
Date:   Fri, 25 Jan 2019 10:47:58 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/7] mt76x02: use mask for vifs
Message-ID: <20190125094757.GA11700@redhat.com>
References: <1548344649-10404-1-git-send-email-sgruszka@redhat.com>
 <1548344649-10404-2-git-send-email-sgruszka@redhat.com>
 <20190124161235.GA10806@localhost.localdomain>
 <20190124162040.GA5136@redhat.com>
 <20190124163541.GB10806@localhost.localdomain>
 <20190124222040.GA2873@localhost.localdomain>
 <20190125082556.GA2180@redhat.com>
 <20190125090236.GA2761@p1372.fit.wifi.vutbr.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190125090236.GA2761@p1372.fit.wifi.vutbr.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Fri, 25 Jan 2019 09:48:11 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, Jan 25, 2019 at 10:02:38AM +0100, Lorenzo Bianconi wrote:
> > On Thu, Jan 24, 2019 at 11:20:42PM +0100, Lorenzo Bianconi wrote:
> > > > > > 
> > > > > > I guess this does not work if you add 2 vifs and then you remove the first one
> > > > > > (you will end up with a wrong configuration in MT_MAC_ADDR_DW{0,1}). I guess
> > > > > > the hw will not work well if MT_MAC_ADDR_DW{0,1} is not properly configured
> > > > 
> > > > Maybe I am missing something, but let's assume you add the interface vif0 with address
> > > > 00:11:22:33:44:55 (MT_MAC_ADDR_DW{0,1} will be set to 00:11:22:33:44:55) and
> > > > then you add vif1 with address 00:aa:bb:cc:dd:ee. If at some point you remove
> > > > vif0 MT_MAC_ADDR_DW{0,1} will not be properly reconfigured. The problem will
> > > > be more complex if you have more interfaces
> > 
> > Ok, so in remove_interface extra code can be added to implement that.

Something like this should address the issue you raised:

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index 3880caa0c64a..44b4af928a4e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -320,6 +320,15 @@ void mt76x02_sta_remove(struct mt76_dev *mdev, struct ieee80211_vif *vif,
 }
 EXPORT_SYMBOL_GPL(mt76x02_add_interface);
 
+static void mt76x02_setaddr_iterator(void *data, u8 *mac,
+                                     struct ieee80211_vif *vif)
+{
+	struct mt76x02_dev *dev = data;
+
+	if (!ether_addr_equal(dev->mt76.macaddr, vif->addr))
+                mt76x02_mac_setaddr(dev, vif->addr);
+}
+
 void mt76x02_remove_interface(struct ieee80211_hw *hw,
 			      struct ieee80211_vif *vif)
 {
@@ -328,6 +337,10 @@ void mt76x02_remove_interface(struct ieee80211_hw *hw,
 
 	mt76_txq_remove(&dev->mt76, vif->txq);
 	dev->vif_mask &= ~BIT(mvif->idx);
+
+	if (hweight16(dev->vif_mask) == 1)
+		ieee80211_iterate_interfaces(hw, 0, mt76x02_setaddr_iterator,
+					     dev);
 }
 EXPORT_SYMBOL_GPL(mt76x02_remove_interface);
