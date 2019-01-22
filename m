Return-Path: <SRS0=0pM2=P6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35061C282C3
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 20:23:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0B22C217D6
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 20:23:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbfAVUXe (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 22 Jan 2019 15:23:34 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36626 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726035AbfAVUXe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Jan 2019 15:23:34 -0500
Received: from mail-yb1-f198.google.com ([209.85.219.198])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <seth.forshee@canonical.com>)
        id 1gm2a4-000123-18
        for linux-wireless@vger.kernel.org; Tue, 22 Jan 2019 20:23:32 +0000
Received: by mail-yb1-f198.google.com with SMTP id n1so5637783ybd.10
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jan 2019 12:23:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=FOyORcphcCw659xQxU9QxKoWbuJ4s7FU3d6v8GogR/w=;
        b=Nvikzmnl0H10ACyuyO+NgLdg2biFpt4XDbaY84KrgkGAh1ckbZk5TAd0TqV5+5dXGW
         M51U3gL9c+AoQxtOfMliW249RCWP7O+N/d65hR7esEOdWnFLPeX8sLMTxw+yRIIqKhcw
         033hCo1TRtCmsXQUNQJBYjLg9fR1sPE5mct9NLdb4NHLSUmg+8gLbxT+mo2nBGgTJuFi
         9Cb1GOU/hZBXDn42zX86G149tD8gOQNecb6jUrygngMrkHikMJ0lPTPH9+DmN+IyIaF5
         Q9sofvVAkWPAEsuer1kEUacTnVlIiIq/1BPQyn/eLRHz8fhFejVq1D3BDuS4vXym/8sd
         cZ/A==
X-Gm-Message-State: AJcUukd7TAnjkPadhs6sO3ia/634EzIJs9ZTFEmXDDo5S+ev158p8hMC
        xDfGFnoRCmDa8g94QO5gZETZtg6VLg4yiqd2WtCZBX1b2PTx2NACtTmg2a1Krae2egDNgKacsST
        516K+2LGIl9HwlQZGm9oM6E7bq9Q4nYW5neHC764t8i+p
X-Received: by 2002:a81:5744:: with SMTP id l65mr32761545ywb.91.1548188606045;
        Tue, 22 Jan 2019 12:23:26 -0800 (PST)
X-Google-Smtp-Source: ALg8bN67Mc0rBG4NDMihfJ7KS1YrT4oDqParWtmkrIaT6WkK13eT0oHGqt+A9ZUQFw6d7T/nJUTwag==
X-Received: by 2002:a81:5744:: with SMTP id l65mr32761523ywb.91.1548188605693;
        Tue, 22 Jan 2019 12:23:25 -0800 (PST)
Received: from localhost ([2605:a601:ac2:fb20:b0c3:23ce:f04b:2786])
        by smtp.gmail.com with ESMTPSA id w70sm11317924yww.76.2019.01.22.12.23.18
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 22 Jan 2019 12:23:25 -0800 (PST)
Date:   Tue, 22 Jan 2019 14:23:17 -0600
From:   Seth Forshee <seth.forshee@canonical.com>
To:     Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        wireless-regdb@lists.infradead.org,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] wireless-regdb: update 60ghz band rules for us
Message-ID: <20190122202317.GV7206@ubuntu-xps13>
References: <20181218080815.19395-1-chaitanya.mgit@gmail.com>
 <CABPxzYK+Tu678C=84i3+67gA1EBw_pG3cJ1y1ZvWZobU6iS8Dg@mail.gmail.com>
 <87lg3j6aly.fsf@purkki.adurom.net>
 <CABPxzYKHMUQyM+gi5-u-PVmD-viCxAaweeGUGWQ7jkjqG==amQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPxzYKHMUQyM+gi5-u-PVmD-viCxAaweeGUGWQ7jkjqG==amQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, Jan 18, 2019 at 01:17:31AM +0530, Krishna Chaitanya wrote:
> On Thu, Jan 17, 2019 at 12:20 PM Kalle Valo <kvalo@codeaurora.org> wrote:
> >
> > Krishna Chaitanya <chaitanya.mgit@gmail.com> writes:
> >
> > > On Tue, Dec 18, 2018 at 1:38 PM <chaitanya.mgit@gmail.com> wrote:
> > >>
> > >> From: Chaitanya Tata <Chaitanya.Mgit@gmail.com>
> > >>
> > >> Include channels 4, 5 & 6 for US in 60GHz band. FCC extended the
> > >> 57-64GHz band till 71GHz with almost same rules.
> > >> ---
> > >>  db.txt | 6 +++---
> > >>  1 file changed, 3 insertions(+), 3 deletions(-)
> > >>
> > >> diff --git a/db.txt b/db.txt
> > >> index fa5c0e0..ae650dd 100644
> > >> --- a/db.txt
> > >> +++ b/db.txt
> > >> @@ -1280,9 +1280,9 @@ country US: DFS-FCC
> > >>         (5490 - 5730 @ 160), (23), DFS
> > >>         (5735 - 5835 @ 80), (30)
> > >>         # 60g band
> > >> -       # reference: http://cfr.regstoday.com/47cfr15.aspx#47_CFR_15p255
> > >> -       # channels 1,2,3, EIRP=40dBm(43dBm peak)
> > >> -       (57240 - 63720 @ 2160), (40)
> > >> +       # reference: section IV-D https://docs.fcc.gov/public/attachments/FCC-16-89A1.pdf
> > >> +       # channels 1-6 EIRP=40dBm(43dBm peak)
> > >> +       (57240 - 71000 @ 2160), (40)
> > >>
> > >>  country UY: DFS-FCC
> > >>         (2402 - 2482 @ 40), (20)
> > >>
> > > Kalle/Seth,
> > >
> > > Any update on this? Patchwork shows its delegated to you(may be by default).
> >
> > Seth doesn't use patchwork so I just delegate regdb patches to myself
> > and then mark them as 'Not Applicaple'.
> >
> Ah okay, Thanks. Will wait for Seth to comment on this.

Sorry, I had an extended time off around the holidays and just haven't
gotten to applying patches from this list yet. I'm getting started on it
now so patches should be applied soon.

Seth
