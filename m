Return-Path: <SRS0=rx5y=NU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92D07C43441
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 11:55:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B5F820827
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 11:55:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SrA+ARM4"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5B5F820827
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728277AbeKIVfd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 9 Nov 2018 16:35:33 -0500
Received: from mail-vs1-f67.google.com ([209.85.217.67]:39036 "EHLO
        mail-vs1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727885AbeKIVfd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Nov 2018 16:35:33 -0500
Received: by mail-vs1-f67.google.com with SMTP id h78so852290vsi.6
        for <linux-wireless@vger.kernel.org>; Fri, 09 Nov 2018 03:55:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yDWwgG2caqnKg2r1bkOdZbs8GHcoZkw1iBz96V7CASE=;
        b=SrA+ARM4PIdOCTjkV8HV6kLcMMJw1MosqhgEeEu4dnzKEVxTo2kkQlcEJ8wY6mg4NY
         PHEAnS1kqFcqWvYG+qFcspHPdLZpohG+ZfsR3kL7i67y27u0vTc/jPnYOduO1oXJtExP
         J9U3tXqMQ96rqBdVT82APTp2C/kTSL8T60111WKKqsODSxaZQUNyA+SYu6utzagwxrb6
         V+vXUHWE9DYsA8SDVjI7hbTkVYKU85DtwwiaS8HfhKWX23mN1/1HeLeNXRjeA5+gaid0
         TCdIJ5YI255zZdglI5zneIL6srxL3hpEWMbbIm2izbFTHXQu4kBzUH/Wx7etwZ9IIBgn
         g9dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yDWwgG2caqnKg2r1bkOdZbs8GHcoZkw1iBz96V7CASE=;
        b=lvSzy027MXK1utaRmFxevN7Pzrk6w0OqS0RVndyV9MfRLmO0Nw0iFc90viN6K6+iUR
         tSZUJFTugxfe83VX2QCabej35+ddoyEwpyGpCdg3tuhF5/GDvXeCcIsGES681dTTCwVL
         JUaa6zzke+1n8rdxzaIipSD6GLqlq4mVEEjTQqHfFVeKDLvwnrWSSRngiBuwhWYsmTUU
         Yea5YWuNsGOlKckZQe/i3q4RJ9IRATeb84GgslhyUQAtppemp3UvfCLnTbglARAfIc0+
         1OeK8wE/f5A67YxTwngm9vEOvHGvsSgor51Vl+tiBpWzA3ft5bFj0whs9rmLKCIepKVm
         f4EA==
X-Gm-Message-State: AGRZ1gLK/DmZiXNp5zf9ICBh2lAbgAibADw6LPBEwn3disP+N5RyI90V
        B0WP7a91gd2dDH1/rLgMM6qC/dxDjC4SGEVY15Y=
X-Google-Smtp-Source: AJdET5c0RAmPHmEaMwWdbP/7YCEbO0CNVT31JLKuGj2Ga71s/lDY3M2qgNvA/56cETTjkRBuxwXz3N4dqwUXViSuIho=
X-Received: by 2002:a67:4c8f:: with SMTP id h15mr3582202vsg.110.1541764514747;
 Fri, 09 Nov 2018 03:55:14 -0800 (PST)
MIME-Version: 1.0
References: <20181018083547.23262-1-johannes@sipsolutions.net>
 <CANGSkXRMOK7dJwyRZOgBZbypvAPyV6DUEtE+2LGodtiN5=BqmQ@mail.gmail.com>
 <CANGSkXSox2BquGzhXzALtLxVe8nY67iOfe-kHtRnhg2FEFE6Pg@mail.gmail.com> <37faa3760d0b2d9e3aa5c13de283763838e58c20.camel@sipsolutions.net>
In-Reply-To: <37faa3760d0b2d9e3aa5c13de283763838e58c20.camel@sipsolutions.net>
From:   Siva Rebbagondla <siva8118@gmail.com>
Date:   Fri, 9 Nov 2018 17:25:00 +0530
Message-ID: <CANGSkXQc4eRVGFE65-1Ugw6qSKJ8hgt8WD=QKV7fTsfT0BRzjw@mail.gmail.com>
Subject: Re: [PATCH] mac80211: allow hardware scan to fall back to software
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Linux Wireless <linux-wireless@vger.kernel.org>,
        sushant kumar mishra <sushant2k1513@gmail.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Sanjay Kumar Konduri <sanjay.konduri@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Sushant Mishra <sushant.mishra@redpinesignals.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, Nov 9, 2018 at 4:49 PM Johannes Berg <johannes@sipsolutions.net> wrote:
>
> On Fri, 2018-11-09 at 11:48 +0530, Siva Rebbagondla wrote:
> > Hi,
> > Gentle Remainder..!!!.
> > Any update required for this patch?. If not, When can i expect this
> > patch to be available in wireless-next?.
>
> Sorry, I hadn't been merging things for a while due to the merge window.
>
> I just put it into mac80211-next, so I guess the answer should be
> "soon".
Thank you. I was waiting for a long time for this patch.

Best Regards,
Siva Rebbagondla
>
> johannes
>
