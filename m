Return-Path: <SRS0=/7yp=NT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68BA3ECDE4B
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 17:31:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 274A220818
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 17:31:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Q0BtwzS9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 274A220818
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbeKIDIP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 8 Nov 2018 22:08:15 -0500
Received: from mail-it1-f194.google.com ([209.85.166.194]:52623 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726684AbeKIDIP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Nov 2018 22:08:15 -0500
Received: by mail-it1-f194.google.com with SMTP id t190-v6so2758263itb.2
        for <linux-wireless@vger.kernel.org>; Thu, 08 Nov 2018 09:31:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VdYF3WX3GJAY0kanvw201TBbKXMrlke2gUcOPt/8g8c=;
        b=Q0BtwzS9i0uXnSMZNmNl8gwVXuSQbdCrM8x2W8oYKA4/XBi02mzkXWg+GdsDS61dz7
         N12JEEoas3U0c1dZ/eRnN8cHJgB8GgDV4ol9SPH0Cs3+Ha7X+RMB2RNCcisBd5LMMRUS
         hjNLY0GgTI+TxRyd+p3SaCm+Odt91x2OuzMws=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VdYF3WX3GJAY0kanvw201TBbKXMrlke2gUcOPt/8g8c=;
        b=AVrKAM3KSklqwaN0SXfSWRtae531aNA2J0vGkFqRF73WKtSMYLeGncotjKAQzxDFqV
         B2RKmN5a0PKFGNGHEDLjJH51siOBAzQkNCBYXTgvktLbeWca0qpty3ROQ67ezNMdMcsV
         bgp1RLjD5aDlf6SBh0j5NUoNd25Av6oIE6Nx7zdGJ0fjes/nwa3zVXvyIOaeCfCH6+Q9
         2hd6m8WT55edyjs0BK0cmaPaxcvPXJ/kHCCGr8FfH2QNQtBbq9atVfjGAoPkyACagVpG
         dFN7ER7mVRRPEBGkbbvov0UZ4i4cTUsLWoFt53wSVyeCmuDog3i456OOFtuKQL9dxFGY
         3FaA==
X-Gm-Message-State: AGRZ1gIj+gnyJqHnShGK6rpYjTHo6DPd5u+TpVzqwR6ZcYbxJn9PDDBO
        Nv5NGTCz3pQfum+eq31dD3ejiXxJk+E=
X-Google-Smtp-Source: AJdET5cPa32lyvFo+sUayzH4RfKkhl/wtGTU+dlfuJpCupjKDXNYBPvqQUnYXkppj62qAOt5jFgnig==
X-Received: by 2002:a24:9717:: with SMTP id k23-v6mr2009446ite.94.1541698303072;
        Thu, 08 Nov 2018 09:31:43 -0800 (PST)
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com. [209.85.166.41])
        by smtp.gmail.com with ESMTPSA id x26-v6sm801960ita.34.2018.11.08.09.30.59
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Nov 2018 09:31:12 -0800 (PST)
Received: by mail-io1-f41.google.com with SMTP id f12-v6so15246620iog.0
        for <linux-wireless@vger.kernel.org>; Thu, 08 Nov 2018 09:30:59 -0800 (PST)
X-Received: by 2002:a6b:d541:: with SMTP id x1-v6mr4659579ioc.113.1541698256286;
 Thu, 08 Nov 2018 09:30:56 -0800 (PST)
MIME-Version: 1.0
References: <20181107185643.240346-1-briannorris@chromium.org>
 <7f2ef494f4a2aba1845a157da8fec449@codeaurora.org> <b1a64bd66fa25f274af8c018c6fc02f4@codeaurora.org>
In-Reply-To: <b1a64bd66fa25f274af8c018c6fc02f4@codeaurora.org>
From:   Brian Norris <briannorris@chromium.org>
Date:   Thu, 8 Nov 2018 09:30:43 -0800
X-Gmail-Original-Message-ID: <CA+ASDXOqJ1-G2amyu7sJCnzKf1oY_2j9Qw4WS0VTf8EqGr6Uqw@mail.gmail.com>
Message-ID: <CA+ASDXOqJ1-G2amyu7sJCnzKf1oY_2j9Qw4WS0VTf8EqGr6Uqw@mail.gmail.com>
Subject: Re: [PATCH REGRESSION] Revert "ath10k: add quiet mode support for QCA6174/QCA9377"
To:     govinds@codeaurora.org
Cc:     rmanohar@codeaurora.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        yyuwang@codeaurora.org, pillair@codeaurora.org,
        stable <stable@vger.kernel.org>,
        linux-wireless-owner@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Nov 7, 2018 at 8:32 PM Govind Singh <govinds@codeaurora.org> wrote:
> On 2018-11-08 03:00, Rajkumar Manoharan wrote:
> > On 2018-11-07 10:56, Brian Norris wrote:
> >> This reverts commit cfb353c0dc058bc1619cc226d3cbbda1f360bdd3.
> >>
> >> WCN3990 firmware does not yet implement this feature, and so it
> >> crashes
> >> like this:
> >>
> >>   fatal error received: err_qdi.c:456:EX:wlan_process:1:WLAN
> >> RT:207a:PC=b001b4f0
> >>
> >> This feature can be re-implemented with a proper service bitmap or
> >> other
> >> feature-discovery mechanism in the future. But it should not break
> >> working boards.
> >>
> > Brian,
> >
> > The change "ath10k: add quiet mode support for QCA6174/QCA9377" was
> > merged even
> > before full WCN3990 device support was added in ath10k. How come it
> > could be regression
> > for WCN3990. I know both are sharing same WMI-TLV interface but
> > reverting this
> > will break QCA6174/QCA9377. no?

I don't see how the revert would "break" QCA6174 -- QCA6174 worked
just fine without this feature and should continue to do so.

> This regression is found while we switched from 4.18 + WCN3990
> back-ports to 4.19.

^^ What Govind said. WCN3990 support has been trickling in over a few
releases, and it doesn't seem kosher to allow people to submit
regressions in the midst of that.

> > I would prefer to handle this within WMI callback or upper layer.
> >
>
> IMO, we should use (WMI_SERVICE_THERMAL_MGMT | WMI_SERVICE_THERM_THROT )
> service bitmap check and call
> ath10k_thermal_set_throttling only if fw supports THERMAL THROTTLE
> feature. But we need to ensure all
> available ath10k fw's are reporting this service.

And the above notes from Govind highlight this -- if the feature was
not protected by the appropriate service flags, then we can't be sure
that you didn't break a bunch of other firmware releases out there.
Linux should not break for everyone just because you spun a firmware
release.

Of course, I'll leave it up to Kalle as to how he wants to mediate
this. And if you come up with a solid patch soon that can fix this
without dropping the feature, then so be it.

Brian
