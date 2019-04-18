Return-Path: <SRS0=x8ok=SU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,FROM_EXCESS_BASE64,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6626C10F0E
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Apr 2019 11:55:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 812DB2083D
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Apr 2019 11:55:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="in8oOnbw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388889AbfDRLzv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 18 Apr 2019 07:55:51 -0400
Received: from mail-yw1-f68.google.com ([209.85.161.68]:38773 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388535AbfDRLzv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Apr 2019 07:55:51 -0400
Received: by mail-yw1-f68.google.com with SMTP id m207so649433ywd.5
        for <linux-wireless@vger.kernel.org>; Thu, 18 Apr 2019 04:55:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=hcfGfaHegSAyycy47ypPTKIDhzqRH0SQYQ8hoPAqvFc=;
        b=in8oOnbw5POadgnwr08ZIAJId+4AFdTnZ5LCPs/w1WsgWcomxcRf2ZzuSulaLecllL
         HyV8owkuIwDBsh1dWMxWjfOpyw0Ml/eTByKXDWRcdu79uehpWBrq1QqPfix5wZNbH9HX
         cDZGocWK31MI1zXqFSA0YYnU7u+/sH7JBw3+1xPVbOah/p+xv9H3qwK+N272hXKMi8BA
         Nxqsas4on+5yO/j4CmmtURhK600V692YhOY4Jf88UWW1tkLr4orbXt6tFz00Lko+UJvG
         h/UYoEJ5vFc/+3kF6mqrZSkn28skzcwaKgIr0t48Xwc9H/ay7cU1PphfkhtmwXj5e55m
         z27Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=hcfGfaHegSAyycy47ypPTKIDhzqRH0SQYQ8hoPAqvFc=;
        b=TM+jDW+sgdUiMXJdy0m0/9VcRwApGEtpfdS0hJknm8QnfRsJmjHuYp7H47oD0wWW4I
         yDD7ezqFITU4GjnEwiHeh/r1gKkXidTyNURK+YTAEt+EZGo0pgsqFy8wAE3MTkkcF3pv
         ckPiukYb9ifVvUm17vPMrJrke++dtAbLgw1HHVA8dADRwW+YAqFD9m+bXvnTAtOfXa79
         f08C/ve1DQOko7rZ4HYWrBu5JG6gGb8U3Jk2P1BwZRDasc25YF/ioIa3/motquoXtKM0
         PqD9ESbAnYnw5B6AxG/0VPElxji/gZ2wUk5jJSyNYrM2BAeKb7NK7di0cy7H0QjNIotY
         IohQ==
X-Gm-Message-State: APjAAAUjlxBzri83mjWAePggGMQR/8VnE2vC+uSfJsQB1iMBTF6cPKw9
        E1kD70JUupd7hc39gUkdHLrdSCDKCc4zo5ArLUo=
X-Google-Smtp-Source: APXvYqzTwCDpTIPb8CM49fRrEE+oxINWzeOL+nnGOzgud/RDBSDlK7d28RwDuimNJvPCy8tNWoJMnODnJw0ZUof+9+I=
X-Received: by 2002:a0d:fec3:: with SMTP id o186mr72041021ywf.167.1555588550526;
 Thu, 18 Apr 2019 04:55:50 -0700 (PDT)
MIME-Version: 1.0
References: <b519e746-ddfd-421f-d897-7620d229e4b2@gmail.com>
 <16ea722f-e08d-044f-216c-4ea745cc6344@broadcom.com> <CACna6rxR4t1MpniasnUfyiuBhc9tTkJRx=O7GrMnmVPOXCZ-dQ@mail.gmail.com>
In-Reply-To: <CACna6rxR4t1MpniasnUfyiuBhc9tTkJRx=O7GrMnmVPOXCZ-dQ@mail.gmail.com>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date:   Thu, 18 Apr 2019 13:55:39 +0200
Message-ID: <CACna6rwF7rai_PMY3VtYXD=uBAT+jHsr8zrWP28vKjUx2S7Uyg@mail.gmail.com>
Subject: Re: brcmfmac: NULL pointer dereference during brcmf_detach() after
 firmware crash
To:     Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER
        <brcm80211-dev-list.pdl@broadcom.com>," 
        <brcm80211-dev-list@cypress.com>, Aaron Blair <aaron@aaronpb.me>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 15 Feb 2019 at 07:15, Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> wr=
ote:
> On Thu, 14 Feb 2019 at 23:37, Arend Van Spriel
> <arend.vanspriel@broadcom.com> wrote:
> > On 2/14/2019 11:30 PM, Rafa=C5=82 Mi=C5=82ecki wrote:
> > > I've just found a well reproducible brcmfmac crash (NULL pointer
> > > dereference).
> > >
> > > Steps:
> > > 1. Wait for or trigger a FullMAC firmware crash
> > > 2. Wait for some skb to get queued on a flowring
> > > 3. Call rmmod brcmfmac
> > >
> > > Problem:
> > > There is a NULL pointer dereference in one of the brcmf_detach() call=
s.
> > >
> > > Explanation:
> > > brcmf_detach() first frees all "ifp"s and then deletes flowrings. If =
any
> > > flowring has a skb it results in calling brcmf_txfinalize() which tri=
es
> > > to access "ifp" (struct brcmf_if) which is a NULL.
> >
> > Hi Rafa=C5=82,
> >
> > Thanks for diving in. That was my suspicion. Does it mean you are
> > working on a patch or shall I take care of it.
>
> It would be nice to have someone more experienced with detaching &
> rings look at it. Is adding a simple
> if (ifp)
> enough? Or should that code get redesigned? Should we e.g. reorder detach=
 order?

Hi Arend, would you find a moment to look at that crash, please?

--=20
Rafa=C5=82
