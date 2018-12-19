Return-Path: <SRS0=qpxp=O4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C199CC43387
	for <linux-wireless@archiver.kernel.org>; Wed, 19 Dec 2018 07:47:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9205421850
	for <linux-wireless@archiver.kernel.org>; Wed, 19 Dec 2018 07:47:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727874AbeLSHrs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 19 Dec 2018 02:47:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54800 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726704AbeLSHrs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Dec 2018 02:47:48 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E076289AC8;
        Wed, 19 Dec 2018 07:47:47 +0000 (UTC)
Received: from localhost (ovpn-204-95.brq.redhat.com [10.40.204.95])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B638B600CC;
        Wed, 19 Dec 2018 07:47:44 +0000 (UTC)
Date:   Wed, 19 Dec 2018 08:47:43 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Sid Hayn <sidhayn@gmail.com>
Cc:     Matthias Brugger <matthias.bgg@gmail.com>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        linux-mediatek@lists.infradead.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Felix Fietkau <nbd@nbd.name>
Subject: Re: mt76x[02]u 802.11w support
Message-ID: <20181219074743.GA3538@redhat.com>
References: <CAM0KTbBUXJsBfO0=hQgeTGVteym6iuObdyNynWumQnnGY0L3wg@mail.gmail.com>
 <20181213143947.GA11947@localhost.localdomain>
 <CAM0KTbCMrcXNFHUFEmoHg+nseN1GkegqAM0GSuWBDHP=gVgi=w@mail.gmail.com>
 <dd275289-99d0-54a8-9ac5-cb137123950a@gmail.com>
 <CAM0KTbBV_YZqt6kkrKeY5tRtKn10UOLQY3EyTKPY+zLzht7sgg@mail.gmail.com>
 <20181217154628.GA4773@redhat.com>
 <20181218080939.GA16795@redhat.com>
 <CAM0KTbCWtwYE3DzmqeHSs3m7A7JojeFFs2_Mp1q5Kg=ySaN0Rw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM0KTbCWtwYE3DzmqeHSs3m7A7JojeFFs2_Mp1q5Kg=ySaN0Rw@mail.gmail.com>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Wed, 19 Dec 2018 07:47:48 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Dec 18, 2018 at 01:38:54PM -0500, Sid Hayn wrote:
> > > Regarding this case, there is no single commit that add 802.11w support
> > > we could request to add to -stable. It was added together with other
> > > features in:
> > >
> > > commit 0ae976a11b4fb5704b597e103b5189237641c1a1
> > > Author: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> > > Date:   Thu Sep 6 11:18:41 2018 +0200
> > >
> > >     mt76x0: init hw capabilities
> > >
> > > which depend on switching mt76x0u to mt76-usb layer.
> > >
> > > So I'm not sure how this request should be satisfied.
> >
> > Can you check if adding
> >
> > ieee80211_hw_set(rt2x00dev->hw, MFP_CAPABLE);
> In this case I inferred from cotext that it should be
> ieee80211_hw_set(hw, MFP_CAPABLE); hopefully that is correct.

Yeah it is. I copied the line from wrong driver :-) 

> > is sufficient to add support for 802.11w ?
> As a matter of fact it was sufficient.  I can now connect to my AP
> with 802.11w required and prior to this one line change I could not.
> Thanks for taking the time to suggest this, it seems to work well
> enough to connect.  I don't much have a means to test to see if deauth
> frames are properly handled, do you have any test cases you want to
> suggest or are you comfortable enough that it should work properly?

If you using wpa_supplicant, 'wpa_cli disconnect' should
trigger deauth exchange.

Are there errors in dmesg ? If there are many errors, I think
we will need to change EINVAL to EOPNOTSUPP as well.

Thanks
Stanislaw
