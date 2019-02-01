Return-Path: <SRS0=B73O=QI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5349C282D8
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 22:17:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9238221872
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 22:17:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="ImtY979L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbfBAWRZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 1 Feb 2019 17:17:25 -0500
Received: from mail-ed1-f44.google.com ([209.85.208.44]:38363 "EHLO
        mail-ed1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726284AbfBAWRZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Feb 2019 17:17:25 -0500
Received: by mail-ed1-f44.google.com with SMTP id h50so6722457ede.5
        for <linux-wireless@vger.kernel.org>; Fri, 01 Feb 2019 14:17:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lr+s3YhcDLSKx85FYtBGSGWW+bVK8msAyXwi+jtvviE=;
        b=ImtY979L1v7vD/b474Elb2w38pbTyO/QoEIg7cDeskvTW5SreRh7K/y7xIKDwvjSNg
         zukVAveZnt0SwmSWvHOBJvCORdweQ+nTK+ElTdjynWS/JZH3jGlD3q8QISVma+epQoK4
         Tmg1B3FMuUuLHj2K5h+kn7Y9pyOnG/UmMa3Og=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lr+s3YhcDLSKx85FYtBGSGWW+bVK8msAyXwi+jtvviE=;
        b=YEJmkuezHOLrxfDbf8EZfmOxYGy3igIhE2UlKIdtee78QFmNJWE0tES7IfU49x7mH2
         58HMNEd4/prdU352OZUOO7/SlaYtwjY3RQKiBpCO4f5gsSMviFI1nGC/bJQT1zrmPQ2/
         q5StxasCBzPeyG0USzkMd0dgT4w5Lw8cl9SOPDAeeWTfEv4EA6MmMvhpU2DPzcv+21uR
         lKUXOIaBbB8N6dm7/o38/amml6cLJHF4JoYTBeMFud2yk1CIWjSd6g1alaHNTI3bAVlk
         3aU6A4zWoCk180IKkbLi/zS4uPU6GVr/ownDQKcNM592xVD2mU9pXsArmt18Xpo7pufe
         OsLA==
X-Gm-Message-State: AJcUukeMRs/IowvyebHN4V0/o6ElCbIy6ZhiRy3AdccHGufAhxxdT7vc
        kdKNYzVSBephVkIZWvYIL4p+GDjuL7g=
X-Google-Smtp-Source: ALg8bN4T8Anr6RKQZ4I8SxK4AzVcfvCy1IOrlnauhZMt6kNO0CPojZvyqeCwsZ7ajt77PmjoHpd1AA==
X-Received: by 2002:a17:906:914a:: with SMTP id y10mr37079635ejw.124.1549059443345;
        Fri, 01 Feb 2019 14:17:23 -0800 (PST)
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com. [209.85.208.44])
        by smtp.gmail.com with ESMTPSA id d2sm2341570eda.92.2019.02.01.14.17.22
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 01 Feb 2019 14:17:22 -0800 (PST)
Received: by mail-ed1-f44.google.com with SMTP id h50so6722383ede.5
        for <linux-wireless@vger.kernel.org>; Fri, 01 Feb 2019 14:17:22 -0800 (PST)
X-Received: by 2002:a17:906:7c42:: with SMTP id g2mr36516556ejp.212.1549059441966;
 Fri, 01 Feb 2019 14:17:21 -0800 (PST)
MIME-Version: 1.0
References: <CA+ASDXMVAP4CsE=vaomOn5mu_uAM0jc3jvWGzaVPFFif4kTX+Q@mail.gmail.com>
 <2d274e00c3e15e9786ccc865215d9853a5ab30f0.camel@sipsolutions.net> <3282a26ab610c1590742c0d50632c35ae4bb82c8.camel@sipsolutions.net>
In-Reply-To: <3282a26ab610c1590742c0d50632c35ae4bb82c8.camel@sipsolutions.net>
From:   Brian Norris <briannorris@chromium.org>
Date:   Fri, 1 Feb 2019 14:17:10 -0800
X-Gmail-Original-Message-ID: <CA+ASDXMNu2Jv1nFCWMtg6bcks-XKv1fTGr6j2f0TdgtAhkQK3w@mail.gmail.com>
Message-ID: <CA+ASDXMNu2Jv1nFCWMtg6bcks-XKv1fTGr6j2f0TdgtAhkQK3w@mail.gmail.com>
Subject: Re: iw release cadence?
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, Feb 1, 2019 at 2:09 PM Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2019-02-01 at 22:54 +0100, Johannes Berg wrote:
> >
> > I'll just tag one now :-)
>
> Done. I updated a few things and pulled in our FTM support code too, now
> that all the nl80211.h api is upstream.

Awesome, thanks! Presumably a tarball is on its way?

Brian
