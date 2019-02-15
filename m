Return-Path: <SRS0=7xxp=QW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,FROM_EXCESS_BASE64,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B68A3C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 10:08:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8671921924
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 10:08:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A3COgQcm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405550AbfBOKIr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Feb 2019 05:08:47 -0500
Received: from mail-yw1-f66.google.com ([209.85.161.66]:41555 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726122AbfBOKIr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Feb 2019 05:08:47 -0500
Received: by mail-yw1-f66.google.com with SMTP id q128so3485135ywg.8
        for <linux-wireless@vger.kernel.org>; Fri, 15 Feb 2019 02:08:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=eCifAycPyj6MDUjj7oHdr6POj6VlcGL0kcB16bp0i/w=;
        b=A3COgQcm/4o+7XAYdKS4COOd1V4IT1IrXxrgJwogBsn3VfFY+crghQ4Lu3jtR37jEY
         N885DsDNEnggifuSdyEkHPNY+iAq+E39uhG3KXdRffJGoYCUsfHlps/bQii8fHwSkzFp
         Q4deAqtxlG6ppFiDti7APH9qRZorZ7d3Bv63R5zx+Ol+PvXWnnnTjaykO/CT5U7Hk/Ih
         ETvFUSUxW0TuIRvh0GC7tRkWtyO/h4c5mjV9zAE0lsddbFW5y65cD6JGUmL45RhgBc2+
         h9aeTuVEi2lV8DVtcBpnSIn2WFVhRGDtEwKtVHx7SFbQDO7Yj9H6C2StLql23o1MvQGH
         JBJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=eCifAycPyj6MDUjj7oHdr6POj6VlcGL0kcB16bp0i/w=;
        b=SCgYexpxqjBrtEclZhZuwkdtRAdFFoMmRubKyDm8IRM434uPR0YSxzAyluv5hLpcJS
         pIL7JGXlZfO4NUCwt/qukJdVwAuzgfCObt+mZ0YdFn8BJgJrPs8/OvSe+5rnFTEc0SfO
         sZNzlI0EWtKCpbKBOFEF/omTTL5LDqGt+AjDKFfa4Ja1F68mPr13HXrEaE2HX8CawOM4
         PIzzarfE0tpN6dg+sAubazQvjhx8gNRhK/X4Wh5eVku3vQaBuS83vpbTpIOzoxNhpSqH
         bheA5Zo5celvtOsXa7rpX5APtqOlB6TO4cdB+vjgnc1cmSQWz+Na+J84O/OXVduqID1l
         0YzA==
X-Gm-Message-State: AHQUAuabUksNT2Dyedp17wyuKS79WVfpkXlCkeVyF65Uay7j0feaiyux
        jhpEHsda/E/ujXycUTcS1pgctcoQ3QqejQTEttM=
X-Google-Smtp-Source: AHgI3IaH/DDC/cLHL7sIJG/IKr6moKcT0Oc935iGRUWUKlrXYzWPKVvdA6tI00DocP5EYB6tVPVTyKvw57S5/iXtvXM=
X-Received: by 2002:a81:6344:: with SMTP id x65mr7123960ywb.377.1550225326043;
 Fri, 15 Feb 2019 02:08:46 -0800 (PST)
MIME-Version: 1.0
References: <20190215061601.GE2304@kadam> <87bm3dz7tc.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87bm3dz7tc.fsf@kamboji.qca.qualcomm.com>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date:   Fri, 15 Feb 2019 11:08:34 +0100
Message-ID: <CACna6ryji=s3CNc4DHrcQnUKjTV1Dt2rGUyYM+1AVG67Hu4Jag@mail.gmail.com>
Subject: Re: [PATCH] brcmfmac: use bphy_err() in all wiphy-related code
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>, kbuild@01.org,
        kbuild-all@01.org, Arend van Spriel <arend.vanspriel@broadcom.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER
        <brcm80211-dev-list.pdl@broadcom.com>," 
        <brcm80211-dev-list@cypress.com>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 15 Feb 2019 at 11:04, Kalle Valo <kvalo@codeaurora.org> wrote:
> Dan Carpenter <dan.carpenter@oracle.com> writes:
>
> > Hi Rafa=C5=82,
> >
> > url:
> > https://github.com/0day-ci/linux/commits/Rafa-Mi-ecki/brcmfmac-use-bphy=
_err-in-all-wiphy-related-code/20190214-140004
> > base:
> > https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-=
next.git
> > master
> >
> > smatch warnings:
> > drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c:114
> > brcmf_fweh_call_event_handler() warn: variable dereferenced before
> > check 'ifp' (see line 110)
> > drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c:187
> > brcmf_fweh_handle_if_event() error: we previously assumed 'ifp' could
> > be null (see line 184)
> > drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c:189
> > brcmf_fweh_handle_if_event() warn: variable dereferenced before check
> > 'ifp' (see line 187)
> >
> > # https://github.com/0day-ci/linux/commit/e12dba9f5ed77216c5984a4b57ddc=
31ba23376c9
> > git remote add linux-review https://github.com/0day-ci/linux
> > git remote update linux-review
> > git checkout e12dba9f5ed77216c5984a4b57ddc31ba23376c9
> > vim +/ifp +114 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
> >
> > 5c36b99a drivers/net/wireless/brcm80211/brcmfmac/fweh.c Arend van
> > Spriel 2012-11-14 104
> > 3e0a97e1 drivers/net/wireless/brcm80211/brcmfmac/fweh.c Arend van
> > Spriel 2012-11-14 105 static int brcmf_fweh_call_event_handler(struct
> > brcmf_if *ifp,
> > 3e0a97e1 drivers/net/wireless/brcm80211/brcmfmac/fweh.c Arend van
> > Spriel 2012-11-14 106 enum brcmf_fweh_event_code code,
> > 3e0a97e1 drivers/net/wireless/brcm80211/brcmfmac/fweh.c Arend van
> > Spriel 2012-11-14 107 struct brcmf_event_msg *emsg,
> > 3e0a97e1 drivers/net/wireless/brcm80211/brcmfmac/fweh.c Arend van
> > Spriel 2012-11-14 108 void *data)
> > 3e0a97e1 drivers/net/wireless/brcm80211/brcmfmac/fweh.c Arend van
>
> This report is very hard to read as the lines seem to be wrapped.

I think it's your client playing tricks on you. I got the report
correctly formatted and so did patchwork:
https://patchwork.kernel.org/comment/22483031/

--=20
Rafa=C5=82
