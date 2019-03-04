Return-Path: <SRS0=K+dv=RH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 419A5C43381
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Mar 2019 11:04:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0DA2F20815
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Mar 2019 11:04:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbfCDLEd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 4 Mar 2019 06:04:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50956 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726098AbfCDLEc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Mar 2019 06:04:32 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AFDF430821E0;
        Mon,  4 Mar 2019 11:04:32 +0000 (UTC)
Received: from localhost (unknown [10.43.2.92])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 55FF61A912;
        Mon,  4 Mar 2019 11:04:30 +0000 (UTC)
Date:   Mon, 4 Mar 2019 12:04:28 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 11/11] mt76x02: enable AP mode for USB
Message-ID: <20190304110427.GA2008@redhat.com>
References: <1551692896-7062-1-git-send-email-sgruszka@redhat.com>
 <1551692896-7062-12-git-send-email-sgruszka@redhat.com>
 <20190304105506.GB3073@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190304105506.GB3073@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Mon, 04 Mar 2019 11:04:32 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Mar 04, 2019 at 11:55:07AM +0100, Lorenzo Bianconi wrote:
> > Enable AP mode. For now without multi-vif support, this will require
> > more testing and investigation.
> > 
> > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> > ---
> >  drivers/net/wireless/mediatek/mt76/mt76x02_util.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
> > index 38997076cb03..99c729f6701d 100644
> > --- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
> > +++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
> > @@ -142,6 +142,7 @@ void mt76x02_init_device(struct mt76x02_dev *dev)
> >  
> >  	wiphy->interface_modes =
> >  		BIT(NL80211_IFTYPE_STATION) |
> > +		BIT(NL80211_IFTYPE_AP) |
> >  #ifdef CONFIG_MAC80211_MESH
> >  		BIT(NL80211_IFTYPE_MESH_POINT) |
> 
> I think we need to disable DFS channels for the moment (for mt76x{0,2}u) since
> dfs is not supported yet

How this should be done ? Is sufficient to check IEEE80211_CHAN_RADAR
and mt76_is_usb() on set channel end return -EINVAL error ? Or different
way ?

Stanislaw


