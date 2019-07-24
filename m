Return-Path: <SRS0=rB3s=VV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99CABC76186
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Jul 2019 17:15:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 351BE21911
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Jul 2019 17:15:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=wp.pl header.i=@wp.pl header.b="ntAPjIlL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbfGXRP1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 24 Jul 2019 13:15:27 -0400
Received: from mx4.wp.pl ([212.77.101.12]:60124 "EHLO mx4.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727238AbfGXRP1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Jul 2019 13:15:27 -0400
Received: (wp-smtpd smtp.wp.pl 7512 invoked from network); 24 Jul 2019 19:15:23 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1563988524; bh=gEkDwIuDO2Mlt47g7fHTqzHcSxdtZTDr5XQG+4+AvdU=;
          h=From:To:Cc:Subject;
          b=ntAPjIlLwGvOxgC2v+xm/bV3mQvMUDMExK5e9IszAZdswFVOM1CMFo9sCJ1pKqGLF
           kpQZCuccigvIcEx+x1AdexCezOy9xB+tz6O3Y7xqR2h9mmc1Ypn5frAT1xfDiD+D4g
           91q1Fzzc/O8xKBgRvC2r2763CVpjRIG6Mu7bIfb0=
Received: from 014.152-60-66-biz-static.surewest.net (HELO cakuba.netronome.com) (kubakici@wp.pl@[66.60.152.14])
          (envelope-sender <kubakici@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <navid.emamdoost@gmail.com>; 24 Jul 2019 19:15:23 +0200
Date:   Wed, 24 Jul 2019 10:15:14 -0700
From:   Jakub Kicinski <kubakici@wp.pl>
To:     Navid Emamdoost <navid.emamdoost@gmail.com>
Cc:     emamd001@umn.edu, kjlu@umn.edu, smccaman@umn.edu,
        secalert@redhat.com, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mt76_init_sband_2g: null check the allocation
Message-ID: <20190724101514.29efc10a@cakuba.netronome.com>
In-Reply-To: <20190723221954.9233-1-navid.emamdoost@gmail.com>
References: <20190723221954.9233-1-navid.emamdoost@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-MailID: 3fa229c2b67e2a6425aaa1fc737c8941
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 000000A [EYOU]                               
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 23 Jul 2019 17:19:54 -0500, Navid Emamdoost wrote:
> devm_kzalloc may fail and return NULL. So the null check is needed.
> 
> Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>

Acked-by: Jakub Kicinski <kubakici@wp.pl>

Thanks!
