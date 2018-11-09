Return-Path: <SRS0=rx5y=NU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF747C43441
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 16:25:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F3BF20825
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 16:25:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7F3BF20825
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728351AbeKJCGk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 9 Nov 2018 21:06:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48810 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727845AbeKJCGj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Nov 2018 21:06:39 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C6B4AC04B2C6;
        Fri,  9 Nov 2018 16:25:22 +0000 (UTC)
Received: from localhost (unknown [10.43.2.84])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 40DF46B8CD;
        Fri,  9 Nov 2018 16:25:10 +0000 (UTC)
Date:   Fri, 9 Nov 2018 17:25:08 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/5] mt76x02: initalize mutli bss mode by default
Message-ID: <20181109162507.GA2124@redhat.com>
References: <1541758814-2046-1-git-send-email-sgruszka@redhat.com>
 <1541758814-2046-3-git-send-email-sgruszka@redhat.com>
 <20181109112651.GF4174@localhost.localdomain>
 <20181109131028.GA8054@redhat.com>
 <20181109133130.GA9453@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181109133130.GA9453@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Fri, 09 Nov 2018 16:25:22 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, Nov 09, 2018 at 02:31:31PM +0100, Lorenzo Bianconi wrote:
> > 
> > Anyway I think, to support MAC address change, we should not filter
> > based on MAC address, but maybe only on BSSID ? 
> > 
> > Thanks
> > Stanislaw
> 
> You can create the interface with a given mac address
> 
> # iw phy phy0 interface add wlp0s4u1 type managed addr 00:11:22:33:44:55

I realized I have ancient version of iw :-)

Ok, so to do not break that we can add it to common function like this:

+	if (vif->type == NL80211_IFTYPE_STATION) {
+		if (idx == 0)
+			mt76x02_mac_init_mbss(dev, vif->addr);
 		idx += 8;
+	}

Thanks
Stanislaw
 
