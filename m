Return-Path: <SRS0=LoJ4=QT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB8CBC282C4
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 15:02:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ACAF121773
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 15:02:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728603AbfBLPCf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Feb 2019 10:02:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46324 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726238AbfBLPCf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Feb 2019 10:02:35 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EDD0919CBD7;
        Tue, 12 Feb 2019 15:02:34 +0000 (UTC)
Received: from localhost (ovpn-204-125.brq.redhat.com [10.40.204.125])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3102862989;
        Tue, 12 Feb 2019 15:02:33 +0000 (UTC)
Date:   Tue, 12 Feb 2019 16:02:32 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Jeroen Roovers <jer@airfi.aero>
Cc:     Tom Psyborg <pozega.tomislav@gmail.com>,
        linux-wireless@vger.kernel.org,
        Randy Oostdyk <linux-kernel@oostdyk.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Felix Fietkau <nbd@nbd.name>, Mathias Kresin <dev@kresin.me>
Subject: Re: [PATCH v2 2/3] rt2x00: check number of EPROTO errors
Message-ID: <20190212150232.GA23126@redhat.com>
References: <1545318971-28351-2-git-send-email-sgruszka@redhat.com>
 <CANCHnQoU-PPTotVD-MmCKCjtoVZEx7Nj4+5YGyfYBEKb2+VNdQ@mail.gmail.com>
 <20190107150912.GA9516@redhat.com>
 <CANCHnQrkB7U2KHd7v6psFaD3cbR+cWj0PaBhRZ8Nk5B6ne7ECw@mail.gmail.com>
 <CAKR_QVLY9ryxUebZD_WWw01Wub9Ue=S3u5YGe2CVk+R8uNgjVw@mail.gmail.com>
 <CANCHnQqe7Y1=h0An0qNQGPONnN-tZ5vMon=-Uoif0GGY5NmPTg@mail.gmail.com>
 <20190109113320.GA15658@redhat.com>
 <CANCHnQp+J56S=PbMTBkAWfrAi_GoTCOk3Wbao=wRm4A8=bbGKQ@mail.gmail.com>
 <CANCHnQrF1u9sxPw3Dx+ZyDLRnZ0Qtn5C3d5Pr4=7tL0YnwtwWw@mail.gmail.com>
 <CANCHnQrb57bUCj_kftD+5_gRZFeruFxaXWR8B_feEcpyF-6rVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANCHnQrb57bUCj_kftD+5_gRZFeruFxaXWR8B_feEcpyF-6rVw@mail.gmail.com>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Tue, 12 Feb 2019 15:02:35 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Jan 22, 2019 at 06:32:05PM +0100, Jeroen Roovers wrote:
> > then triggered a kernel panic. Sadly I couldn't capture it in time but
> > I did spot that more phyN (up to phy4) devices had been added.
> 
> Yes, even when some rt2x00usb_vendor_request starts to fail but keeps
> on trying, the WLAN modules remain unrecoverable except by removing
> power, so the 10 retries are usually not reached and the device is
> never removed. Could it be that some operations do succeed, perhaps
> because the MCU was reset and is now capable of responding to some
> "vendor requests" but not others?
> 
> Checking for num_proto_errs > 1 would then make as much sense as
> num_proto_errs > 10 when running an AP. Maybe it's different for an
> STA?

Does it make sense to do num_proto_err > 3 check. Would that
be helpful on your problem with rt2800usb device? I don't want
make num_proto_err > 1 since this will remove device just after
2 errors.

Also have you tested tx_power patch with lowering txpower ?
Did it improve things ?

Stanislaw
