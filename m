Return-Path: <SRS0=f1+T=PQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34CA5C43387
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Jan 2019 16:44:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E2F62087F
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Jan 2019 16:44:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728593AbfAHQoa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 8 Jan 2019 11:44:30 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:55940 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727739AbfAHQoa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Jan 2019 11:44:30 -0500
X-IronPort-AV: E=Sophos;i="5.56,454,1539640800"; 
   d="scan'208";a="363145043"
Received: from vaio-julia.rsr.lip6.fr ([132.227.76.33])
  by mail2-relais-roc.national.inria.fr with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Jan 2019 17:44:27 +0100
Date:   Tue, 8 Jan 2019 17:44:25 +0100 (CET)
From:   Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To:     Kalle Valo <kvalo@codeaurora.org>
cc:     Solomon Peachy <pizza@shaftnet.org>,
        kernel-janitors@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 20/20] cw1200: drop useless LIST_HEAD
In-Reply-To: <87bm4rru12.fsf@kamboji.qca.qualcomm.com>
Message-ID: <alpine.DEB.2.20.1901081744100.13248@hadrien>
References: <1545555435-24576-1-git-send-email-Julia.Lawall@lip6.fr>        <1545555435-24576-21-git-send-email-Julia.Lawall@lip6.fr> <87bm4rru12.fsf@kamboji.qca.qualcomm.com>
User-Agent: Alpine 2.20 (DEB 67 2015-01-07)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org



On Tue, 8 Jan 2019, Kalle Valo wrote:

> Julia Lawall <Julia.Lawall@lip6.fr> writes:
>
> > Drop LIST_HEAD where the variable it declares has never
> > been used.
> >
> > The semantic patch that fixes this problem is as follows:
> > (http://coccinelle.lip6.fr/)
> >
> > // <smpl>
> > @@
> > identifier x;
> > @@
> > - LIST_HEAD(x);
> >   ... when != x
> > // </smpl>
> >
> > Fixes: a910e4a94f692 ("cw1200: add driver for the ST-E CW1100 & CW1200 WLAN chipsets")
> > Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> >
> > ---
> > Successfully 0-day tested on 151 configurations.
>
> I assume I can take this to wireless-drivers-next. If you are planning
> to push this via some other tree please let me know.

Please take it.  Thanks.

julia
