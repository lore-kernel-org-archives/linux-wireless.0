Return-Path: <SRS0=aQ0V=QE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72AD6C282C8
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 08:35:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D22E20881
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 08:35:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbfA1IfE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Jan 2019 03:35:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56302 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726772AbfA1IfE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Jan 2019 03:35:04 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C6FF8C0D0863;
        Mon, 28 Jan 2019 08:35:03 +0000 (UTC)
Received: from localhost (unknown [10.43.2.219])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 68DE26EE46;
        Mon, 28 Jan 2019 08:35:02 +0000 (UTC)
Date:   Mon, 28 Jan 2019 09:30:43 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 6/7] mt76: beaconing fixes for USB
Message-ID: <20190128083041.GA4132@redhat.com>
References: <1548344649-10404-1-git-send-email-sgruszka@redhat.com>
 <1548344649-10404-7-git-send-email-sgruszka@redhat.com>
 <20190124225048.GD2873@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190124225048.GD2873@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Mon, 28 Jan 2019 08:35:03 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Jan 24, 2019 at 11:50:49PM +0100, Lorenzo Bianconi wrote:
> >  	if (changed & BSS_CHANGED_BEACON_ENABLED) {
> > -		tasklet_disable(&dev->pre_tbtt_tasklet);
> > +		skb = NULL;
> > +		if (info->enable_beacon && mt76_is_usb(dev))
> > +			skb = ieee80211_beacon_get(hw, vif);
> 
> What about moving this in mt76x02_mac_set_beacon_enable(), I guess the code
> will be more readable. Moreover you can move skb pointer declaration in
> if (changed & BSS_CHANGED_BEACON_ENABLED) block

Ok, make sense.

Regarding your other remarks, I do not see utility to address them.

Thanks
Stanislaw
