Return-Path: <SRS0=ZHYo=P7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC9E0C282C0
	for <linux-wireless@archiver.kernel.org>; Wed, 23 Jan 2019 10:49:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B982920861
	for <linux-wireless@archiver.kernel.org>; Wed, 23 Jan 2019 10:49:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KXk9b8Hb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727198AbfAWKtj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 23 Jan 2019 05:49:39 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:39384 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727105AbfAWKti (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 Jan 2019 05:49:38 -0500
Received: by mail-io1-f67.google.com with SMTP id k7so1297837iob.6
        for <linux-wireless@vger.kernel.org>; Wed, 23 Jan 2019 02:49:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hiLcX7lPx4SMc9ycFXr0ewyjEdV7WldwqG3JhBQgDyk=;
        b=KXk9b8HbxYS3BfkzjN4Y6Jm0hu1K5I+K+nYXnVHmx5mBnEdZKr1vo8zSu6O8CGnxKe
         2a/wknhmBmt/l/geQz1afn7TVWt7PfzghtW0oUVA3s7HRGrKUCOFhthd56KcA6QZeWDU
         CJF43/OfTSlgUV+mFwnwcLRIVy8xcak06KXHiIy01V28dST78uC0rZhU1Gi/yleeUg+a
         F0EjWNwJ47zcG8VOygGzA2E5BEFSIwEVcdQGp7ygfL73u+1jS3o2RXkcYSS1yyo2dHZm
         4Oqbrq9BO4iiNvoTArDafHrgdfhkArIq54AX8d7S3Xv1pdGy7c+ypcORgslXO7PeOpjz
         V5KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hiLcX7lPx4SMc9ycFXr0ewyjEdV7WldwqG3JhBQgDyk=;
        b=iDFOojgqbwv5INrFJ9z5ijE0dRDBkr7Sl4X8aUv2gyU69Ts3WbxCq1U6uttY+mlbpm
         OhQFpgMRWl6B25dcDSQMwI1kdUNijTJ76qKnPRnQvdjcolH36ps0/MOu0t66wEPM29dD
         fDK14qeY82nsWVKSnLE2eb49LfN9tslOJJQjpYencriDlTUKlWFhHuBZksw6E4yZngWw
         R/4lrjXbFUMH+Q8+Nl7u28/dZCmNoTjTuq7pdWpKZa43LtTAeVOLHixyK8fTsBKZPgr2
         w1yL1eVeCnoyhvL3Ct31gBIMreF3a2Awudez5W7snu5JDymp+GH/U42AmywIpSMeQpag
         jhcg==
X-Gm-Message-State: AHQUAuaqPdrP07tB7pkYezhX45PXrFVriaXf5hGugYV5w3mDzN3qQ7qt
        qV7zEVbMcNzuhI+9CplzS4BP/J96rik4OjcN3VWEZg==
X-Google-Smtp-Source: AHgI3IaitUSHS3nLvAtwVV/ipjdMbZY5rm5xMC1a30AsD/xYm3YKvZCa8PIsUxW12/CMdcSBCM4s9yZIOqQcZ0lmI58=
X-Received: by 2002:a5d:8597:: with SMTP id f23mr937521ioj.238.1548240577874;
 Wed, 23 Jan 2019 02:49:37 -0800 (PST)
MIME-Version: 1.0
References: <20181218080815.19395-1-chaitanya.mgit@gmail.com> <20190122211351.GW7206@ubuntu-xps13>
In-Reply-To: <20190122211351.GW7206@ubuntu-xps13>
From:   Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date:   Wed, 23 Jan 2019 16:19:26 +0530
Message-ID: <CABPxzY+jbfoVGF_fta3reHa5yngmp_+dVKCiu3DR-8WzzxAPow@mail.gmail.com>
Subject: Re: [PATCH] wireless-regdb: update 60ghz band rules for us
To:     Seth Forshee <seth.forshee@canonical.com>
Cc:     wireless-regdb@lists.infradead.org,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Jan 23, 2019 at 2:43 AM Seth Forshee <seth.forshee@canonical.com> wrote:
>
> On Tue, Dec 18, 2018 at 01:38:15PM +0530, chaitanya.mgit@gmail.com wrote:
> > From: Chaitanya Tata <Chaitanya.Mgit@gmail.com>
> >
> > Include channels 4, 5 & 6 for US in 60GHz band. FCC extended the
> > 57-64GHz band till 71GHz with almost same rules.
>
> This looks right to me based on my research. You're missing one thing
> though. You need to provide a Signed-off-by tag, please see the
> CONTRIBUTING file for more information. If you reply with your tag I
> will add it when I apply the patch. Thanks!

Sorry, didn't realize missed SO. You can use below. Thanks.
Signed-off-by: Chaitanya Tata <Chaitanya.Tata@bluwireless.co.uk>

> > ---
> >  db.txt | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/db.txt b/db.txt
> > index fa5c0e0..ae650dd 100644
> > --- a/db.txt
> > +++ b/db.txt
> > @@ -1280,9 +1280,9 @@ country US: DFS-FCC
> >       (5490 - 5730 @ 160), (23), DFS
> >       (5735 - 5835 @ 80), (30)
> >       # 60g band
> > -     # reference: http://cfr.regstoday.com/47cfr15.aspx#47_CFR_15p255
> > -     # channels 1,2,3, EIRP=40dBm(43dBm peak)
> > -     (57240 - 63720 @ 2160), (40)
> > +     # reference: section IV-D https://docs.fcc.gov/public/attachments/FCC-16-89A1.pdf
> > +     # channels 1-6 EIRP=40dBm(43dBm peak)
> > +     (57240 - 71000 @ 2160), (40)
> >
> >  country UY: DFS-FCC
> >       (2402 - 2482 @ 40), (20)
> > --
> > 2.17.1
> >



-- 
Thanks,
Regards,
Chaitanya T K.
