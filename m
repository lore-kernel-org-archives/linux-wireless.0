Return-Path: <SRS0=z7UY=PZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23D88C43387
	for <linux-wireless@archiver.kernel.org>; Thu, 17 Jan 2019 19:47:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E775B20855
	for <linux-wireless@archiver.kernel.org>; Thu, 17 Jan 2019 19:47:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="uOLRvkrr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728952AbfAQTrp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 17 Jan 2019 14:47:45 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:44208 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728776AbfAQTro (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Jan 2019 14:47:44 -0500
Received: by mail-io1-f68.google.com with SMTP id r200so8774435iod.11
        for <linux-wireless@vger.kernel.org>; Thu, 17 Jan 2019 11:47:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=v7m1XN4lBSJlpn7YEisuqCjSSW8k8tOPka9yLENqQ+I=;
        b=uOLRvkrr/0Imk8Cd8Q+QMSrc02jmxyjPaO9QNmJMpQN1YknBvarvYEB6VwQGRUUwIs
         Vc8f00N1a34W1ju3Khn6DFeQOwViMN67R1YhVYR6arGEKeR3wDGcp0lo88t5KggJnAYz
         tAekliJ2P22GJ4JgslBN2mGW1c9N1sbat486DUKHKgBG4JBujxqe8MXeyjiW5mRJb5UA
         q6JBpNGQZKisPvuJ112jkwNyqrLEHyBJcWS0BUho6eld2uabjWWvxG8g5ijmIi8zhRVH
         hLn/xoibFzi7WsZY2Ndp5GiDv2NRUltVt7M6TBVtzZp31lxUVb9RKSVUIHPuV+62IEDv
         Oq2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=v7m1XN4lBSJlpn7YEisuqCjSSW8k8tOPka9yLENqQ+I=;
        b=q996E8yEvCKxG9s3g677ssh+yfIW0fCFGrLDBUCo5NAIlvMVd5GFJjBF7yteDMP1wB
         O1t9XHwE6JCUspMJkG1Mb7ETbAn4Tr2X+Dp60epPD6CMRuAoRsdeKB4iZ001TMy7eN3L
         IM47nre9c2dkegr9xhl8NYueh0eShsiectoLxmVvNg0+1gUii3vq48UM+hmZ2EvEuveW
         tT6K4cX2zdjRybWy2n/TawdCcSBVxHh2JmUvKJqUX+02fRRbtOS8rfxUYlQLn1iQrmjq
         ykMlHgc4OGht/fzjhIK4C30jq9oOj8CSexDTGhkJfc3jdxGcRCSR9MpHoSapbJieQF2H
         Q24A==
X-Gm-Message-State: AJcUukc1VCcnk2jUhmGBNm0YmVZkAgnen4hLiC0UUHs2Rzg0TNrJuIsV
        u3EEeILSR9WzD7GOsdgKw1Zxy71pbIZ/Isqt7Mo=
X-Google-Smtp-Source: ALg8bN5ODHtCwdE2Ex2+YJDRhEBSf51y79BfVfQCR7SqwmH+ypIxdA1gjEBpoaXL1H0HTSZjwJGT9ctYBy8fB3k3Q88=
X-Received: by 2002:a6b:f814:: with SMTP id o20mr8397481ioh.129.1547754463486;
 Thu, 17 Jan 2019 11:47:43 -0800 (PST)
MIME-Version: 1.0
References: <20181218080815.19395-1-chaitanya.mgit@gmail.com>
 <CABPxzYK+Tu678C=84i3+67gA1EBw_pG3cJ1y1ZvWZobU6iS8Dg@mail.gmail.com> <87lg3j6aly.fsf@purkki.adurom.net>
In-Reply-To: <87lg3j6aly.fsf@purkki.adurom.net>
From:   Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date:   Fri, 18 Jan 2019 01:17:31 +0530
Message-ID: <CABPxzYKHMUQyM+gi5-u-PVmD-viCxAaweeGUGWQ7jkjqG==amQ@mail.gmail.com>
Subject: Re: [PATCH] wireless-regdb: update 60ghz band rules for us
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Seth Forshee <seth.forshee@canonical.com>,
        wireless-regdb@lists.infradead.org,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Jan 17, 2019 at 12:20 PM Kalle Valo <kvalo@codeaurora.org> wrote:
>
> Krishna Chaitanya <chaitanya.mgit@gmail.com> writes:
>
> > On Tue, Dec 18, 2018 at 1:38 PM <chaitanya.mgit@gmail.com> wrote:
> >>
> >> From: Chaitanya Tata <Chaitanya.Mgit@gmail.com>
> >>
> >> Include channels 4, 5 & 6 for US in 60GHz band. FCC extended the
> >> 57-64GHz band till 71GHz with almost same rules.
> >> ---
> >>  db.txt | 6 +++---
> >>  1 file changed, 3 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/db.txt b/db.txt
> >> index fa5c0e0..ae650dd 100644
> >> --- a/db.txt
> >> +++ b/db.txt
> >> @@ -1280,9 +1280,9 @@ country US: DFS-FCC
> >>         (5490 - 5730 @ 160), (23), DFS
> >>         (5735 - 5835 @ 80), (30)
> >>         # 60g band
> >> -       # reference: http://cfr.regstoday.com/47cfr15.aspx#47_CFR_15p255
> >> -       # channels 1,2,3, EIRP=40dBm(43dBm peak)
> >> -       (57240 - 63720 @ 2160), (40)
> >> +       # reference: section IV-D https://docs.fcc.gov/public/attachments/FCC-16-89A1.pdf
> >> +       # channels 1-6 EIRP=40dBm(43dBm peak)
> >> +       (57240 - 71000 @ 2160), (40)
> >>
> >>  country UY: DFS-FCC
> >>         (2402 - 2482 @ 40), (20)
> >>
> > Kalle/Seth,
> >
> > Any update on this? Patchwork shows its delegated to you(may be by default).
>
> Seth doesn't use patchwork so I just delegate regdb patches to myself
> and then mark them as 'Not Applicaple'.
>
Ah okay, Thanks. Will wait for Seth to comment on this.


-- 
Thanks,
Regards,
Chaitanya T K.
