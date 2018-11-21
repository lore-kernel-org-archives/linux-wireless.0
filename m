Return-Path: <SRS0=oODW=OA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,FROM_EXCESS_BASE64,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3AC6C43441
	for <linux-wireless@archiver.kernel.org>; Wed, 21 Nov 2018 08:25:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 88BBC2145D
	for <linux-wireless@archiver.kernel.org>; Wed, 21 Nov 2018 08:25:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aQLazDUv"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 88BBC2145D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728483AbeKUS6m (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 21 Nov 2018 13:58:42 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41501 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728078AbeKUS6m (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Nov 2018 13:58:42 -0500
Received: by mail-wr1-f66.google.com with SMTP id x10so4653146wrs.8
        for <linux-wireless@vger.kernel.org>; Wed, 21 Nov 2018 00:25:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=EZuPSeHpB+rNlPwggZChCSJghg8urcst16aTTScxkwU=;
        b=aQLazDUv2hmSK/aGdu9fF3A29qfbInQel+BXc9tMpUsrXtH/XlqBSRh8hK++o1GvHY
         WLFjl5IBwKlTcoYne8/lLkymRV5QCFmwQisDlHCJtxrA2NjYp7AsPz8wtHKJZnt8h2Z9
         Ep5mYWOGsYC2FAnHaHOJo9psAPJF9llLXi3CPbC0Sbo68sxKEfzy0hmCN57sOEMXLM4f
         2nY017IjGGKZ05P3UPisTdWOXIEr5rRmg4H/hAD+fPVaDsAP++IgPrDkjd35NdgTGl0G
         beVD1SOTZe+5dj71z2EqFqFoObW5bmVgGCnqV6c22Lt6ysLumZU7Xy3pGPlYKVa3Q4kJ
         Ok/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=EZuPSeHpB+rNlPwggZChCSJghg8urcst16aTTScxkwU=;
        b=N2QU92cTc+3s1paiIOuFdFNr5w0mKD1aWxFKs8T8p7y4tVHFObWBMVoZUBoJg9P1vD
         O2VtMeknemM3lrGi0K3UcXfj3JmPVZcjwJzac3blgCwgAtcIFcFBI/zFEbzl43jjgrRG
         waVAbcvHVkmSLJ1/onG0+P1Z2L0M6HH7Kg11S9Vl9iop4gIqwQ48ZcYawUZims5Ey/CU
         whYkr3pVmQWbIM2xYooCc3qAdPCJHKIJCQFnbdGOBF3ku8ag0T8NIgtHvOnra1Bmuoo/
         YVpecwzg3BTVvLP4jeg6l7wYWoWgADe0JJK13TjfmirMJDjHB+muoLGTXTuj9fBtU79N
         cDVw==
X-Gm-Message-State: AA+aEWZfl9GW+k1AlqJOW6oDVD6kKblnYMqJNstDhxRpK7DunSJqzNw1
        JjNIj50ynUHBHLeIePBaj9K2V/lyH7bK5NekbmM=
X-Google-Smtp-Source: AFSGD/XELxu3BrBls6Cn12PLqjP1+2/EK0w+58EPLRZkVGNEkQi0eVNy/dnJZWAQaKgfyiqmjS/z9c/1GAsHrWBhhLo=
X-Received: by 2002:a5d:60cc:: with SMTP id x12mr4626627wrt.193.1542788706542;
 Wed, 21 Nov 2018 00:25:06 -0800 (PST)
MIME-Version: 1.0
References: <260962939eeb4dbbb6e462cc010aac21@SC-EXCH02.marvell.com>
 <CALLGbRLXa5m+eRhZpvWKyXkemB0qAkB=eoQKwns-vP29+izV+Q@mail.gmail.com>
 <CACna6rzKWAz_xxi=ehKijGtM4XEcioSjwmb=V0rq_vKioiS=Ew@mail.gmail.com>
 <3e57f30c29254db4a906e3e71ac36da5@SC-EXCH02.marvell.com> <CALLGbRJ9h5fvS+DLOBGTcejW8yiwFW-xey+TaubauH2rZuVWwQ@mail.gmail.com>
 <def0e631e44d4b44a87124a5b530d6ec@SC-EXCH02.marvell.com> <CACna6rz8chrPU+yZC0xakKVeLFm8fgpDoSFP_Vyo8mH1C+DCzQ@mail.gmail.com>
 <8492870c897543a1b3c635a96f1066cb@SC-EXCH02.marvell.com> <CACna6rwE1YE6bokFehgRNsyRGNGORbrYcnuUR-df286h0K4KXw@mail.gmail.com>
 <4b33da1fb23a476ca5bc21eb74f1ffd2@SC-EXCH02.marvell.com>
In-Reply-To: <4b33da1fb23a476ca5bc21eb74f1ffd2@SC-EXCH02.marvell.com>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date:   Wed, 21 Nov 2018 09:24:55 +0100
Message-ID: <CACna6rwXq2PJmNxX8j9V2yMTtCeFHf5-GrjcA-U8A1bPW9pqPg@mail.gmail.com>
Subject: Re: [PATCH v9] Add new mac80211 driver mwlwifi.
To:     David Lin <dlin@marvell.com>
Cc:     Steve deRosier <derosier@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Chor Teck Law <ctlaw@marvell.com>,
        James Lin <jamesl@marvell.com>, Pete Hsieh <peteh@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 8 Feb 2017 at 08:55, David Lin <dlin@marvell.com> wrote:
> > From: Rafa=C5=82 Mi=C5=82ecki [mailto:zajec5@gmail.com] worte:
> > On 8 February 2017 at 08:28, David Lin <dlin@marvell.com> wrote:
> > >> From: Rafa=C5=82 Mi=C5=82ecki [mailto:zajec5@gmail.com] worte:
> > >> Sent: Wednesday, February 08, 2017 3:24 PM On 8 February 2017 at
> > >> 07:30, David Lin <dlin@marvell.com> wrote:
> > >> > steve.derosier@gmail.com [mailto:steve.derosier@gmail.com] wrote:
> > >> >> On Tue, Feb 7, 2017 at 10:15 PM, David Lin <dlin@marvell.com> wro=
te:
> > >> >> >> Rafa=C5=82 Mi=C5=82ecki [mailto:zajec5@gmail.com] wrote:
> > >> >> >> Please use ieee80211-freq-limit:
> > >> >> >> https://git.kernel.org/cgit/linux/kernel/git/davem/net-next.gi=
t
> > >> >> >> /co
> > >> >> >> mmi
> > >> >> >> t/?id=3Db3
> > >> >> >> 30b25eaabda00d74e47566d9200907da381896
> > >> >> >>
> > >> >> >> Most likely with wiphy_read_of_freq_limits helper:
> > >> >> >> https://git.kernel.org/cgit/linux/kernel/git/davem/net-next.gi=
t
> > >> >> >> /co
> > >> >> >> mmi
> > >> >> >> t/?id=3De6
> > >> >> >> 91ac2f75b69bee743f0370d79454ba4429b175
> > >> >> >
> > >> >> > I already replied meaning of these parameters:
> > >> >> > <marvell,2ghz> is used to disable 2g band.
> > >> >> > <marvell,5ghz> is used to disable 5g band.
> > >> >> > <marvell, chainmask> is used to specify antenna number (if
> > >> >> > default number
> > >> >> is suitable for you, there is no need to use this parameter).
> > >> >> > <marvell,powertable> should not be used for chip with device
> > >> >> > power
> > >> table.
> > >> >> In fact, this parameter should not be used any more.
> > >> >> >
> > >> >>
> > >> >> David, I think you're not understanding the comment, or at least
> > >> >> that's what it looks like to me. Yes, you did reply as to the mea=
ning.
> > >> >> And, your reply, while informative, didn't tell us you understood
> > >> >> and were willing to fix the problem. I doubt you meant it this
> > >> >> way, but it feels defensive and like a brush-off.
> > >> >>
> > >> >> First off, you will still have to document any DT bindings you're
> > >> >> adding. Just because you answer the question in the review doesn'=
t
> > >> >> mean you're not responsible for doing so.
> > >> >>
> > >> >> And second off, I think that Rafal (and sorry about my spelling,
> > >> >> looks like there's some sort of accent on the l that I don't know
> > >> >> how to make my keyboard do) is saying: there's already some
> > >> >> generic bindings that can be used to disable the 2g or 5g bands.
> > >> >> Granted they're even newer than your patch, but I do think if sai=
d
> > >> >> bindings exist and
> > >> are appropriate, you should use them.
> > >> >>
> > >> >> - Steve
> > >> >
> > >> > These parameters are marvell proprietary parameters, I don't think
> > >> > it should
> > >> be added to DT bindings.
> > >>
> > >> Steve is correct.
> > >>
> > >> You have to document new properties, just because they are Marvell
> > >> specific doesn't change anything. You just document them in a proper
> > place.
> > >>
> > >
> > > All right. I will do that.
> > >
> > >>
> > >> > BTW, <marvell,2ghz> and <marvell,5ghz> are only used for mwlwifi t=
o
> > >> > report
> > >> supported bands, it is not related to limitation of frequency.
> > >>
> > >> How reporting a single band doesn't limit reported frequencies? You
> > >> can achieve exactly the same using generic property, so there is no
> > >> place for Marvell specific ones.
> > >>
> > >> In fact there were drivers of 3 vendors requiring band/freq-related
> > >> description in DT: Broadcom, Marvell & Mediatek. This property was
> > >> discussed & designed to support all limitation cases we found
> > >> possible to make it usable with
> > >> (hopefully) all drivers.
> > >>
> > >
> > > I only need simple way to disable 2g or 5g band. I will follow your s=
uggestion
> > to document these marvell proprietary parameters.
> >
> > Seriously? Refusing to use generic binding because you think marvell,5g=
hz; is
> > simpler than ieee80211-freq-limit =3D <2402000 2482000>; (not to mentio=
n your
> > property seems reversed!)?
> >
> > I don't know how else to explain this to you. We don't want duplicated
> > properties where one can work. Just use existing one. Don't add new one=
 even
> > if documented.
> >
>
> All right. I will check and let patch v10 to use it. For previous paramet=
ers, they will only be used by previous OpenWrt projects.

Hi David, how are things going? Could we get v10?

--=20
Rafa=C5=82
