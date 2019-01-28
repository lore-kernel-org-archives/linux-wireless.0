Return-Path: <SRS0=aQ0V=QE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1674CC282C8
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 11:20:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E1145214DA
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 11:20:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726693AbfA1LUR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Jan 2019 06:20:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45924 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726415AbfA1LUR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Jan 2019 06:20:17 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 55E0B2CE968;
        Mon, 28 Jan 2019 11:20:17 +0000 (UTC)
Received: from localhost (unknown [10.43.2.219])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D212510A185B;
        Mon, 28 Jan 2019 11:20:16 +0000 (UTC)
Date:   Mon, 28 Jan 2019 12:16:02 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/7] mt76x02: use mask for vifs
Message-ID: <20190128111601.GA6002@redhat.com>
References: <20190124162040.GA5136@redhat.com>
 <20190124163541.GB10806@localhost.localdomain>
 <20190124222040.GA2873@localhost.localdomain>
 <20190125082556.GA2180@redhat.com>
 <20190125090236.GA2761@p1372.fit.wifi.vutbr.cz>
 <20190125094757.GA11700@redhat.com>
 <20190125102545.GA27731@p1372.fit.wifi.vutbr.cz>
 <20190125124148.GB4079@redhat.com>
 <fd79b85d-5b73-aa77-f17a-00ff182ee94c@nbd.name>
 <20190128090201.GB4132@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190128090201.GB4132@redhat.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Mon, 28 Jan 2019 11:20:17 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Jan 28, 2019 at 10:02:01AM +0100, Stanislaw Gruszka wrote:
> On Mon, Jan 28, 2019 at 09:41:45AM +0100, Felix Fietkau wrote:
> > >> Moreover I am a little worried about tpt regressions with this patch.
> > >> Are you sure that if you use complete different mac addresses on a multivif scenario
> > >> you can get the same tpt on all the interfaces? Could you please provide some
> > >> tpt results?
> > > 
> > > How exactly posted patch can cause tpt regression ?
> > > 
> > > Posted patch just add possibility to configure HW MAC address
> > > by this:
> > > 
> > > iw dev wlan0 del
> > > iw phy phy0 interface add wlan0 type managed addr 00:11:22:33:44:55
> > > 
> > > what is feature of mt76x2u. Patch just extend that possibly to other
> > > mt76x02 devices and allow to remove custom mt76x2u add_interfacea
> > > callback.
> > The main part that could cause issues is that you're changing the way
> > that the vif index is calculated. Without the patch, it's calculated
> > from the MAC address in a way consistent with what the hardware expects.
> > With the patch, it's just allocated from a mask.
> > The vif index ends up being passed down to the hardware as a BSS index
> > WCID attribute in mt76x02_mac_wcid_setup.
> > We would have to run some tests with multiple AP interfaces, bringing up
> > secondary interfaces in a different order to see if there are any
> > regressions there if the BSS index no longer matches the MAC address
> > based index.
> 
> Ok, that objection make sense.  I'll check that.

I'm not sure if I'm doing something wrong or current code is
wrong. But when I configure multi bssid's is hostapd.conf like this:

02:aa:bb:cc:dd:e0
06:aa:bb:cc:dd:e0
0a:aa:bb:cc:dd:e0

hostapd fail with "Too many bits in the BSSID mask" error . To make hostapd
work, I have configure bssid's like this:

02:aa:bb:cc:dd:e0
02:aa:bb:cc:dd:e4
02:aa:bb:cc:dd:e8

But this ends up with the same index in mt76 for diffrent vif's. Seems like
calculating of the index should be fixed by:

        if (vif->addr[0] & BIT(1))
                idx = 1 + (((dev->mt76.macaddr[5] ^ vif->addr[5]) >> 2) & 7);

Regards
Stanislaw
