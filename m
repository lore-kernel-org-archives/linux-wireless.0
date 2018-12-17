Return-Path: <SRS0=RnVe=O2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C43EC43387
	for <linux-wireless@archiver.kernel.org>; Mon, 17 Dec 2018 15:46:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6BD252133F
	for <linux-wireless@archiver.kernel.org>; Mon, 17 Dec 2018 15:46:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387609AbeLQPqe (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 17 Dec 2018 10:46:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53726 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727617AbeLQPqe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Dec 2018 10:46:34 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 481F289ADF;
        Mon, 17 Dec 2018 15:46:34 +0000 (UTC)
Received: from localhost (ovpn-204-242.brq.redhat.com [10.40.204.242])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6D219277A5;
        Mon, 17 Dec 2018 15:46:31 +0000 (UTC)
Date:   Mon, 17 Dec 2018 16:46:30 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Sid Hayn <sidhayn@gmail.com>
Cc:     Matthias Brugger <matthias.bgg@gmail.com>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        linux-mediatek@lists.infradead.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Felix Fietkau <nbd@nbd.name>
Subject: Re: mt76x[02]u 802.11w support
Message-ID: <20181217154628.GA4773@redhat.com>
References: <CAM0KTbBUXJsBfO0=hQgeTGVteym6iuObdyNynWumQnnGY0L3wg@mail.gmail.com>
 <20181213143947.GA11947@localhost.localdomain>
 <CAM0KTbCMrcXNFHUFEmoHg+nseN1GkegqAM0GSuWBDHP=gVgi=w@mail.gmail.com>
 <dd275289-99d0-54a8-9ac5-cb137123950a@gmail.com>
 <CAM0KTbBV_YZqt6kkrKeY5tRtKn10UOLQY3EyTKPY+zLzht7sgg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM0KTbBV_YZqt6kkrKeY5tRtKn10UOLQY3EyTKPY+zLzht7sgg@mail.gmail.com>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Mon, 17 Dec 2018 15:46:34 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Dec 17, 2018 at 10:07:43AM -0500, Sid Hayn wrote:
> Interestingly when I asked for the monitor mode patch to be ported it
> was initially refused and then just kind of happened a few weeks
> later.

It was not quite like that. It was refused to apply on 4.19-rcX due to
-next merge -rc conflict that it will cause. And it was promised
that fixes will be backported thought -stable.

Regarding this case, there is no single commit that add 802.11w support
we could request to add to -stable. It was added together with other
features in:

commit 0ae976a11b4fb5704b597e103b5189237641c1a1
Author: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date:   Thu Sep 6 11:18:41 2018 +0200

    mt76x0: init hw capabilities

which depend on switching mt76x0u to mt76-usb layer.

So I'm not sure how this request should be satisfied.

Regards
Stanislaw
