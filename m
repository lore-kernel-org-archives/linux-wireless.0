Return-Path: <SRS0=MtVb=O3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEA08C43387
	for <linux-wireless@archiver.kernel.org>; Tue, 18 Dec 2018 18:39:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8BE2B21841
	for <linux-wireless@archiver.kernel.org>; Tue, 18 Dec 2018 18:39:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aAZjtrUm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726570AbeLRSjE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 18 Dec 2018 13:39:04 -0500
Received: from mail-it1-f174.google.com ([209.85.166.174]:55315 "EHLO
        mail-it1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726446AbeLRSjE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Dec 2018 13:39:04 -0500
Received: by mail-it1-f174.google.com with SMTP id m62so5680117ith.5
        for <linux-wireless@vger.kernel.org>; Tue, 18 Dec 2018 10:39:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mMdiDBtkU+0V73Ad6hQblDFNv1BrdT1f202hC296wsw=;
        b=aAZjtrUmMazmBZl0sZFc9y37l70xw+OFunSV2DXJigRl19j8HJ5wZnJMNsJdaCqrva
         /wjaftMEnos848G0rHNsd6GJcEgt32hGNQCkzQvfrS8gWxZOnnPypUskKHburHrsq0TB
         M+M90m8knrPWH6i9g8GEQCLv/MviI2eBcccG6j9q8jPGNYUR/ICBae+9I53MIH9JphHq
         5rBG4C9M18Cx66GTnx68Y51HYaKoDuVDMT8+5HQeffgbUgZQtnW8iTkIcH7J/n43k8Kf
         aBRtB6UAZRIx8IHcZ+kdaussqAKx5CJR9g+taR4kgjw0ivo6j/+lXgKFOhAv/9SbS4+R
         ezTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mMdiDBtkU+0V73Ad6hQblDFNv1BrdT1f202hC296wsw=;
        b=oFOVa7W2JcypArb0yRDZVMWSPNyjIHh/BkAIFnn0/1CERt06+/bAunf6jXgniQKpN/
         uvJHWhbM0hJH4S2ACWA26yiRAwpEY9su7iCpOuU6r/nJAxu0X8llAcFPlHE6vzd+3tjg
         TPDikNnhUdYRe3H/oyph7HQ0dbJ5JgoyEklGMhkKBbtIDhJAI2AOmerAS48kGUsvAfXU
         Wr4bLREg4bVu+kSdkaaLJROaQ5MYEs515/AvsBHDGVcABlwtalwLrF6xR+JiLFLVqY0C
         LJbtTXYGw+8EESSlNRgIFcdqpINVm0VGC7zCkb9JcxmQe/A262o2ts+RmISycokihqvw
         wqaQ==
X-Gm-Message-State: AA+aEWb0wCjmc180Ckait/dDTunAsaZ8QmU2ErmhrDCBmAlUWA00Ms/l
        fZz3UzQrWuND7g69e1vdK8U1gJh087MOzcZeggpxfQ==
X-Google-Smtp-Source: AFSGD/XX5lYB3QI4MK3SWYSSQE6FbJoPOT5pT+B6oe2DWW4fLCB3/ZS8U8zFXVgTcsVMuqRcwiAbkWldrRYuUME9RVw=
X-Received: by 2002:a24:dd8f:: with SMTP id t137mr3270574itf.10.1545158343027;
 Tue, 18 Dec 2018 10:39:03 -0800 (PST)
MIME-Version: 1.0
References: <CAM0KTbBUXJsBfO0=hQgeTGVteym6iuObdyNynWumQnnGY0L3wg@mail.gmail.com>
 <20181213143947.GA11947@localhost.localdomain> <CAM0KTbCMrcXNFHUFEmoHg+nseN1GkegqAM0GSuWBDHP=gVgi=w@mail.gmail.com>
 <dd275289-99d0-54a8-9ac5-cb137123950a@gmail.com> <CAM0KTbBV_YZqt6kkrKeY5tRtKn10UOLQY3EyTKPY+zLzht7sgg@mail.gmail.com>
 <20181217154628.GA4773@redhat.com> <20181218080939.GA16795@redhat.com>
In-Reply-To: <20181218080939.GA16795@redhat.com>
From:   Sid Hayn <sidhayn@gmail.com>
Date:   Tue, 18 Dec 2018 13:38:54 -0500
Message-ID: <CAM0KTbCWtwYE3DzmqeHSs3m7A7JojeFFs2_Mp1q5Kg=ySaN0Rw@mail.gmail.com>
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

On Tue, Dec 18, 2018 at 3:09 AM Stanislaw Gruszka <sgruszka@redhat.com> wrote:
>
> On Mon, Dec 17, 2018 at 04:46:28PM +0100, Stanislaw Gruszka wrote:
> > On Mon, Dec 17, 2018 at 10:07:43AM -0500, Sid Hayn wrote:
> > > Interestingly when I asked for the monitor mode patch to be ported it
> > > was initially refused and then just kind of happened a few weeks
> > > later.
> >
> > It was not quite like that. It was refused to apply on 4.19-rcX due to
> > -next merge -rc conflict that it will cause. And it was promised
> > that fixes will be backported thought -stable.
> >
> > Regarding this case, there is no single commit that add 802.11w support
> > we could request to add to -stable. It was added together with other
> > features in:
> >
> > commit 0ae976a11b4fb5704b597e103b5189237641c1a1
> > Author: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> > Date:   Thu Sep 6 11:18:41 2018 +0200
> >
> >     mt76x0: init hw capabilities
> >
> > which depend on switching mt76x0u to mt76-usb layer.
> >
> > So I'm not sure how this request should be satisfied.
>
> Can you check if adding
>
> ieee80211_hw_set(rt2x00dev->hw, MFP_CAPABLE);
In this case I inferred from cotext that it should be
ieee80211_hw_set(hw, MFP_CAPABLE); hopefully that is correct.
>
> is sufficient to add support for 802.11w ?
As a matter of fact it was sufficient.  I can now connect to my AP
with 802.11w required and prior to this one line change I could not.
Thanks for taking the time to suggest this, it seems to work well
enough to connect.  I don't much have a means to test to see if deauth
frames are properly handled, do you have any test cases you want to
suggest or are you comfortable enough that it should work properly?

Thanks,
Zero
>
> Most likely it is, since in 4.19 mt76x0_set_key() do not allow to
> set unsupported ciphers. However it returns -EINVAL instead of
> -EOPNOTSUPP, so I want to be sure.
>
> Thanks
> Stanislaw
