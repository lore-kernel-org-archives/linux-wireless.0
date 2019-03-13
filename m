Return-Path: <SRS0=EMXR=RQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33E4FC43381
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Mar 2019 15:50:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0CCE6206BA
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Mar 2019 15:50:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbfCMPuh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 13 Mar 2019 11:50:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49234 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725868AbfCMPuh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Mar 2019 11:50:37 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C24843060FDA;
        Wed, 13 Mar 2019 15:50:36 +0000 (UTC)
Received: from localhost (unknown [10.43.2.106])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 55AEF5C231;
        Wed, 13 Mar 2019 15:50:36 +0000 (UTC)
Date:   Wed, 13 Mar 2019 16:50:34 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Tom Psyborg <pozega.tomislav@gmail.com>
Cc:     linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
        daniel@makrotopia.org
Subject: Re: [PATCH 2/2] rt2x00: enable experimental MFP with HW crypt
Message-ID: <20190313155028.GB5302@redhat.com>
References: <1552417902-11040-1-git-send-email-pozega.tomislav@gmail.com>
 <1552417902-11040-2-git-send-email-pozega.tomislav@gmail.com>
 <20190313091252.GB2663@redhat.com>
 <CAKR_QV+sFc6J97f5dtW9OtxGoEj5udB=fY5qAb3_QgF4jfqEVA@mail.gmail.com>
 <20190313130910.GD2003@redhat.com>
 <CAKR_QVLB9k0bGiRW9ON3PeQR1ZoMfWbrXg3W+Bg4N4G+9pAsZg@mail.gmail.com>
 <20190313140607.GE2003@redhat.com>
 <CAKR_QV+gEJEE2+hwfE1wsF5mdEZVDGtNskivcpFUutGEbwKyKg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKR_QV+gEJEE2+hwfE1wsF5mdEZVDGtNskivcpFUutGEbwKyKg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Wed, 13 Mar 2019 15:50:36 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Mar 13, 2019 at 03:41:50PM +0100, Tom Psyborg wrote:
> >> > It's just matter of sending already encrypted frames. All chipsets
> >> > handle that.
> >> >
> >> > Stanislaw
> >> >
> >>
> >> The question is how well all chipsets handle that. I've seen some lags
> >> too with MFP enabled connection. While being about 40-50% lower,
> >> throughput would still occasionally drop to very low values, like
> >> 800Kbps.
> >
> > The only reason I can image that might have impact on throughput
> > in this case is limited CPU power since encryption is done in
> > software. Would be good to compare with PA2 with nohwcrypte, if
> > there are similar lags. However MFP can require more CPU power.
> >
> > Stanislaw
> >
> 
> nohwcrypt=y mfp=require: there was no throughput drop, no lag,
> measured about 80-85Mbps but the connection frozen after a minute or
> two. might be related to rekeying.
>
> CPU power cannot be the problem since I run it on laptop (2x2.20GHz)

It can be CPU power on AP, ath10k and ath9k also use software
encryption for MFP.

> hwcrypt enabled results are low, some lag but connection remained stable:

There should be no difference between enabling MFP with nohwcrypt and
without nohwcrypt, we will just return -EOPNOTSUPP at different point
from rt2x00mac_set_key:

        if (!rt2x00_has_cap_hw_crypto(rt2x00dev))
                return -EOPNOTSUPP;
<snip>

        crypto.bssidx = rt2x00lib_get_bssidx(rt2x00dev, vif);
        crypto.cipher = rt2x00crypto_key_to_cipher(key);
        if (crypto.cipher == CIPHER_NONE)
                return -EOPNOTSUPP;

However there are some few others points in the code where we check
rt2x00_has_cap_hw_crypto() as well, but all should work the same when
we report to mac80211 that the cipher is not supported.

Stanislaw
