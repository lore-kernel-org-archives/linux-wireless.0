Return-Path: <SRS0=qpxp=O4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B766C43387
	for <linux-wireless@archiver.kernel.org>; Wed, 19 Dec 2018 17:08:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D10F0218A6
	for <linux-wireless@archiver.kernel.org>; Wed, 19 Dec 2018 17:08:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FZ+kcqIQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730294AbeLSRIO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 19 Dec 2018 12:08:14 -0500
Received: from mail-it1-f196.google.com ([209.85.166.196]:55621 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727640AbeLSRIN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Dec 2018 12:08:13 -0500
Received: by mail-it1-f196.google.com with SMTP id m62so10722576ith.5
        for <linux-wireless@vger.kernel.org>; Wed, 19 Dec 2018 09:08:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8QsXnlTDSZE166TyqHMS+Qj6qMZ1jiRvdzO0hKzHcMI=;
        b=FZ+kcqIQbWJLSuVNHgH5tYmvs3EbQT+TmBzvsqCRqdYaragmxq1eLsSNXjn4lC8to6
         TwU12/7O+VB4UUYHaOp4BXpudaLFiavIvjYUNg00HcUcSswvLyESrwhZSReeYBF1lwSD
         Ll0xQBS2z7WAn+/4AIT2yUIcYei3AL9o2XXGyrF1bsAEUsnQTu5FMaQSnYgTHdKrtDtE
         wiiGRQ1yWC2D8ROh/frzG/J4S94MW32CsGul7ET6MvgFFIpQXPseGsQ6c8u10FGi1nS1
         03Ck4xbfJgmcIGQKAsqQsRNzYCET1HrwxOcJDutla4pRGlM+kps71sAf0kRTbSSy+nB+
         zjYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8QsXnlTDSZE166TyqHMS+Qj6qMZ1jiRvdzO0hKzHcMI=;
        b=UPGH/2reWYcFZjo1OX/rP1gOFnzgf3pinTJkNu591A5mGENvuh9plzWZdB2EmoK0+U
         ev9YhjiPgbr1Lxx4PoqTEdBkfiS6rdCdaNXZ4mYqlwUWKYqAXrSdsGGrQlDQWogWTC9e
         Qbn18/9rsAvmRyU+kPQAJ3ZDr4eo9mBneMqS7HZ6KDTEWYRJh+TtbxI0WzQWJPabQoeQ
         jkLDLlbK7H7rz7F0gDTURfW2PCuTsdDYpGbM4xYZ7Fdedg5PY9xe0kiHnU966f9oVDd1
         qkQJYnnNqKYKv6uwv3Er/rHoLvwgA/AxlW3BByP1CayKCsbdXhW30Ia2+Jl+J8UpCcb4
         oHpA==
X-Gm-Message-State: AA+aEWZvw0KwarXzoNDfX5NuEH0UUhbsUI5qU/WU7lIpbIkB+n5yRFAH
        qw8MumcilG1jo2e+6KjMJymlCtt+dZSFKvZVMRwoWQ==
X-Google-Smtp-Source: AFSGD/Wsm5Ar4pxU1VGiwOXT55Z6aZbDfl0W8TEiVGiYrKOnkJxf7QfCQuemR/8mNliCJtWrO8/6bzCpwDff4mHBq7g=
X-Received: by 2002:a24:c342:: with SMTP id s63mr8187838itg.43.1545239292991;
 Wed, 19 Dec 2018 09:08:12 -0800 (PST)
MIME-Version: 1.0
References: <CAM0KTbBUXJsBfO0=hQgeTGVteym6iuObdyNynWumQnnGY0L3wg@mail.gmail.com>
 <20181213143947.GA11947@localhost.localdomain> <CAM0KTbCMrcXNFHUFEmoHg+nseN1GkegqAM0GSuWBDHP=gVgi=w@mail.gmail.com>
 <dd275289-99d0-54a8-9ac5-cb137123950a@gmail.com> <CAM0KTbBV_YZqt6kkrKeY5tRtKn10UOLQY3EyTKPY+zLzht7sgg@mail.gmail.com>
 <20181217154628.GA4773@redhat.com> <20181218080939.GA16795@redhat.com>
 <CAM0KTbCWtwYE3DzmqeHSs3m7A7JojeFFs2_Mp1q5Kg=ySaN0Rw@mail.gmail.com> <20181219074743.GA3538@redhat.com>
In-Reply-To: <20181219074743.GA3538@redhat.com>
From:   Sid Hayn <sidhayn@gmail.com>
Date:   Wed, 19 Dec 2018 12:08:04 -0500
Message-ID: <CAM0KTbAvVQ8oCgs3mThmqUcpRK7MCaHs_38Vt+6N_+4c3jRaGQ@mail.gmail.com>
Subject: Re: mt76x[02]u 802.11w support
To:     sgruszka@redhat.com
Cc:     Matthias Brugger <matthias.bgg@gmail.com>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        linux-mediatek@lists.infradead.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Felix Fietkau <nbd@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Dec 19, 2018 at 2:47 AM Stanislaw Gruszka <sgruszka@redhat.com> wrote:
>
> On Tue, Dec 18, 2018 at 01:38:54PM -0500, Sid Hayn wrote:
> > > > Regarding this case, there is no single commit that add 802.11w support
> > > > we could request to add to -stable. It was added together with other
> > > > features in:
> > > >
> > > > commit 0ae976a11b4fb5704b597e103b5189237641c1a1
> > > > Author: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> > > > Date:   Thu Sep 6 11:18:41 2018 +0200
> > > >
> > > >     mt76x0: init hw capabilities
> > > >
> > > > which depend on switching mt76x0u to mt76-usb layer.
> > > >
> > > > So I'm not sure how this request should be satisfied.
> > >
> > > Can you check if adding
> > >
> > > ieee80211_hw_set(rt2x00dev->hw, MFP_CAPABLE);
> > In this case I inferred from cotext that it should be
> > ieee80211_hw_set(hw, MFP_CAPABLE); hopefully that is correct.
>
> Yeah it is. I copied the line from wrong driver :-)
>
> > > is sufficient to add support for 802.11w ?
> > As a matter of fact it was sufficient.  I can now connect to my AP
> > with 802.11w required and prior to this one line change I could not.
> > Thanks for taking the time to suggest this, it seems to work well
> > enough to connect.  I don't much have a means to test to see if deauth
> > frames are properly handled, do you have any test cases you want to
> > suggest or are you comfortable enough that it should work properly?
>
> If you using wpa_supplicant, 'wpa_cli disconnect' should
> trigger deauth exchange.
politely killing wpa_supplicant also triggers deauth.  it didn't error
when it did so, so I'll assume it was happy.
>
> Are there errors in dmesg ? If there are many errors, I think
> we will need to change EINVAL to EOPNOTSUPP as well.

dmesg appears clean.

Thanks,
Zero
>
> Thanks
> Stanislaw
