Return-Path: <SRS0=ogP8=PS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07C89C43387
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Jan 2019 07:50:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC95B20685
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Jan 2019 07:50:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=airfi-aero.20150623.gappssmtp.com header.i=@airfi-aero.20150623.gappssmtp.com header.b="nP3dJQ8D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727321AbfAJHuG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 10 Jan 2019 02:50:06 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:44126 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726137AbfAJHuG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Jan 2019 02:50:06 -0500
Received: by mail-io1-f65.google.com with SMTP id r200so8184195iod.11
        for <linux-wireless@vger.kernel.org>; Wed, 09 Jan 2019 23:50:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=airfi-aero.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=l82idVawimpye688Wl6Vu2rz5EbJWNKPfR5hD0hmxjw=;
        b=nP3dJQ8DTfDWn1iYi0OvCwrIXNcWbVUQXQQmNWo+V9GMdjkRXRuPMuqq4+gsBfE2q+
         BLbBxwnH1ZXPTVVGO/UXPCGUlxOLnRtT3/tW2JjNUsjYU7fMsM+6UzxZ0pCsjQuyGGlP
         hCwoHB5j4JMxOVDvLXoL8RcPHxo1g0FUgh7SJVNIpCCE+tWePhrwhC9/bMrjBmuu7d4s
         Vd9cQfPigGuk7Dy8Kg0/i2Kuh7WngkqQHIADxOki+7LVz3znRF+C4NiHTBQ1ac3XAvB7
         z2hhYprnM5tvjf+ixUbEoP1ie/oQ2TwH1Qy09yiJXUUqHGdAXldQ8YZvPSt2Ws+0i3iF
         FUnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=l82idVawimpye688Wl6Vu2rz5EbJWNKPfR5hD0hmxjw=;
        b=PLC5fofun8YmHRbIfGuOp4DGBvuyGPIYVo8rWjUXce5K2XNUJcGjshcm9KGP+1gAUm
         ONq8p0US3z5Acr66p3dcVVxqwoDuj4qIdAlGN52uiahQk0g3h9tJh71hzi98xHKJYRAY
         d5isX/KwWZnXME/ikQzK57FaKDtwQYL/AcUiLSuXoe98AKoxzqtJ/n+UH9cExqjwM85w
         hqrm8clLal4uQfnZCLOKQOHLNWFgdjDqKRrTmdLDEIVD6VKEOci+0mkwdl3CtETxZmpA
         FEBk7FDl/Bz89l5PPnLljWk3U+4HUKVJHkeSll3At3p/1IglUUIdJefE4kNx0W5Z+yBG
         y/5g==
X-Gm-Message-State: AJcUukdi/Ndp7LP1o5mz17IxJ8bHTsBMvwmIo6UPAd3rIv3OcDLrQc0w
        zRNA5kziN7BxGEObOa+2Smq/kvKgaQFaIbUEuWJT00gzs/Y=
X-Google-Smtp-Source: ALg8bN6mz1R5Y7lLwflzn/qQeb7ebhSke/pomz0JLbOn2G2ax6C7erfinHoEwjg2CRoXLehJ/KZIO9Q/Eg1yVky9GEc=
X-Received: by 2002:a6b:bc83:: with SMTP id m125mr2103144iof.83.1547106605973;
 Wed, 09 Jan 2019 23:50:05 -0800 (PST)
MIME-Version: 1.0
References: <1545318971-28351-1-git-send-email-sgruszka@redhat.com>
 <1545318971-28351-2-git-send-email-sgruszka@redhat.com> <CANCHnQoU-PPTotVD-MmCKCjtoVZEx7Nj4+5YGyfYBEKb2+VNdQ@mail.gmail.com>
 <20190107150912.GA9516@redhat.com> <CANCHnQrkB7U2KHd7v6psFaD3cbR+cWj0PaBhRZ8Nk5B6ne7ECw@mail.gmail.com>
 <CAKR_QVLY9ryxUebZD_WWw01Wub9Ue=S3u5YGe2CVk+R8uNgjVw@mail.gmail.com>
 <CANCHnQqe7Y1=h0An0qNQGPONnN-tZ5vMon=-Uoif0GGY5NmPTg@mail.gmail.com> <20190109113320.GA15658@redhat.com>
In-Reply-To: <20190109113320.GA15658@redhat.com>
From:   Jeroen Roovers <jer@airfi.aero>
Date:   Thu, 10 Jan 2019 08:49:55 +0100
Message-ID: <CANCHnQp+J56S=PbMTBkAWfrAi_GoTCOk3Wbao=wRm4A8=bbGKQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] rt2x00: check number of EPROTO errors
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Tom Psyborg <pozega.tomislav@gmail.com>,
        linux-wireless@vger.kernel.org,
        Randy Oostdyk <linux-kernel@oostdyk.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Felix Fietkau <nbd@nbd.name>, Mathias Kresin <dev@kresin.me>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

     Hi Stanislaw,

On Wed, 9 Jan 2019 at 12:33, Stanislaw Gruszka <sgruszka@redhat.com> wrote:

> So would be below patch (on top of this set) be a solution for at
> least to not kill the kernel. Or we looking for something better
> i.e. watchdog ?

I'll give it a spin. Thanks!


Kind regards,
     jer
