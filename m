Return-Path: <SRS0=Fc74=OH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DB9AC43441
	for <linux-wireless@archiver.kernel.org>; Wed, 28 Nov 2018 18:08:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D03AC206B2
	for <linux-wireless@archiver.kernel.org>; Wed, 28 Nov 2018 18:08:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JnQYi1WI"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D03AC206B2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725859AbeK2FLV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 29 Nov 2018 00:11:21 -0500
Received: from mail-ot1-f49.google.com ([209.85.210.49]:42748 "EHLO
        mail-ot1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725266AbeK2FLV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Nov 2018 00:11:21 -0500
Received: by mail-ot1-f49.google.com with SMTP id v23so18969468otk.9
        for <linux-wireless@vger.kernel.org>; Wed, 28 Nov 2018 10:08:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zEeosWWJWGT6qd0TZiUirFN/CeQHoHGApomVHH52FBg=;
        b=JnQYi1WIYwELV6v35HBicVumhRjXrp6xcQETo1mena3bVttkraAeTIxdRHJl/2XN+J
         +tcLYslVzrJdJbID7AquOg3/bsr+6wsHKbUal8xFhAyLApZUoLbfa9Hj8BeDUPiyQokJ
         zh15IinJuY4kNfFo1N0/MWVKRjXJXyq1R6/MZAM5Twxu5I9P9r6sebD9cjoNqGIYbC7C
         TAqBwkkx1m6GL8X3nwmP/Fx68+462oZ0fInYY0T2+tkfmPACbKC42gi02PcN3h8/GPd6
         bajHk4Ki+MXhHlN0WAPUCc/3Dsx4VVwEq8mzxucedpDB2QaEYqVEh42JDS7BsGscfj/a
         6m4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zEeosWWJWGT6qd0TZiUirFN/CeQHoHGApomVHH52FBg=;
        b=cRfVvpznvLmuX88+fa1iqII63YqyMEQktharyR7uFw1J2wWwCNFRk2ktTzl4ffF78T
         YDyDtbe6MqMY5RZBKGsMFWmIDM8Pnn9TLTQKcpDlIB9yPdJ5VUTwUbRV2YSww0uFhzBT
         VhA2y9DTDt09Avrt1a+QsjVh3R1vGQerJf4g/faGjyn5HHhbNOrSZxhPhnzMZfsoyBW/
         eLXjW/Bmj2Wp2hZLjQBywvD8S6Ng4jML8R/mBzB6dsxoyklnel5lzdHdTilI4e3cQqn7
         c9QKTt3liDHTj9pCkMeIV4QHxHUZbPULt8mZnZeHE+Rn4HGe0xbdiRoX3BMx4W4E84IE
         r86g==
X-Gm-Message-State: AA+aEWYkkBgwMgp7bByAe7g1tMhVL632mxbvX1OHOOlgChw8t2yVkb2T
        h9coKo0sayvXHJfKywrmDiX9QhsAhqiI/r8tA5A=
X-Google-Smtp-Source: AFSGD/W3/D/g9LDtET94t5mYlJ4sN/rrs8cf7hDU96ziZEBH0bbA312K54TBnwUNO+IzkiwadWC8fE7A8hgtSzcNrgA=
X-Received: by 2002:a9d:421a:: with SMTP id q26mr22569649ote.255.1543428530892;
 Wed, 28 Nov 2018 10:08:50 -0800 (PST)
MIME-Version: 1.0
References: <CABACg+yVE+fuzT-qwjNnACqq24KQbNJOae22=v+J+0Q=8kuKRQ@mail.gmail.com>
 <85717463-11e2-e2e3-b08e-b758986687b5@broadcom.com> <1510916848.26896.2.camel@nxp.com>
 <5A0EDC25.7030505@broadcom.com> <1510932224.22506.0.camel@nxp.com>
 <d9a80a75-b3d4-d78e-a5bf-ab31732f040d@broadcom.com> <e14bdc26-5092-18c9-4caa-c45fd1d12984@broadcom.com>
 <1511347672.18886.2.camel@nxp.com> <5A15584A.9090601@broadcom.com>
 <1511450638.9102.1.camel@nxp.com> <5A1FFA17.6000703@broadcom.com>
 <1512413992.18900.3.camel@nxp.com> <CAF7Mx6q6mTOXc=4OFVCHAHd26pyfv5e6pK=TMNmb1S6=FBWUWQ@mail.gmail.com>
 <1512485878.9392.1.camel@nxp.com> <CAOMZO5DXoCFgTtuRRAq_jFjzkzFp6chMCwczXF5Z0bFaNfQnog@mail.gmail.com>
 <5A5E5EBE.7040301@broadcom.com> <1516276016.8817.1.camel@nxp.com>
 <5A61B43C.4000305@broadcom.com> <1521646672.13983.1.camel@nxp.com>
 <5AB4C8D5.40203@broadcom.com> <1521810882.19239.1.camel@nxp.com>
 <1522067092.4780.3.camel@nxp.com> <1522071220.8102.0.camel@nxp.com>
 <05ab43bd-0033-fc45-a992-0a20b91a0e74@broadcom.com> <CABACg+wyLwYQna+HDJyjNA8V1_3cSoMRDyiBpq=K+UXVXDrtBQ@mail.gmail.com>
 <CAHWfWzm8Zwjc2tBQWVqpaa-cMYyEPWmUKYN7rspyb9W9spx2iQ@mail.gmail.com>
 <CAOMZO5C+r4s3Hn49QbP=0Y+hSYDT5-Y2ZY91E57JvAmq75CXLw@mail.gmail.com>
 <CAOMZO5DtqVBkWuD0iR5JHEG4G-MoWYYxU8aSu99rW8mpd3+PYQ@mail.gmail.com>
 <CAF7Mx6p1DpRieCKy_1qOE5YT4_76UO8vhLMBFUD2B0FrQ9BJGw@mail.gmail.com> <CAOMZO5Ah9CLGud3seRcru8Roy3-ChSVDRhiM4ojvMh1XrcDUOg@mail.gmail.com>
In-Reply-To: <CAOMZO5Ah9CLGud3seRcru8Roy3-ChSVDRhiM4ojvMh1XrcDUOg@mail.gmail.com>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Wed, 28 Nov 2018 16:08:43 -0200
Message-ID: <CAOMZO5D3d3ocHLkoQXTA+aSW=84X8CFN+xWTdZNuHasDqF8Azg@mail.gmail.com>
Subject: Re: AP6335 with mainline kernel
To:     Arend van Spriel <arend.vanspriel@broadcom.com>
Cc:     cameron@paloaltoinnovation.com,
        Vanessa Ayumi Maegima <van.ayumi@gmail.com>,
        Vanessa Maegima <vanessa.maegima@nxp.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        embed3d@gmail.com, John Weber <john.weber@technexion.com>,
        Otavio Salvador <otavio@ossystems.com.br>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Arend,

On Wed, Nov 28, 2018 at 2:23 PM Fabio Estevam <festevam@gmail.com> wrote:

> I am not sure if I can access this signal via scope.

Good news!

I managed to make mx7d to generate the 32kHz clock and now Wifi works
with the default nvram file value: boardflags3 0x08101188

Thanks a lot for your help!
