Return-Path: <SRS0=rH0W=QA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58930C282C5
	for <linux-wireless@archiver.kernel.org>; Thu, 24 Jan 2019 18:15:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25C4A21872
	for <linux-wireless@archiver.kernel.org>; Thu, 24 Jan 2019 18:15:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726028AbfAXSO5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 24 Jan 2019 13:14:57 -0500
Received: from mail-oi1-f194.google.com ([209.85.167.194]:40094 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725913AbfAXSO5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Jan 2019 13:14:57 -0500
Received: by mail-oi1-f194.google.com with SMTP id t204so5611971oie.7;
        Thu, 24 Jan 2019 10:14:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yQznOfcoW1oz3mVpS27ZueYS2k9RApFUqNOp4u2CwIA=;
        b=nNACXbnFBtkrsQ2ubJW3fevwNzzG8IWefXHre1FN4tyNVLzdLnlVk2fXzvB90G9CoB
         f3pHUNwbDzg1VF2zDW6Ab9OoofWmTEpxCTauiB6DInq9URDmcsZ20w+K0n2ocox4j145
         iNC0vgM8IiTKkSotGRIBwWRwOTkXw4+ZWNeDjt8L9Gx35bXM101R4maD9YUKHXOwANRK
         E2gr49ucWF4274CH+N3vflgbno9749CqDOPlOeRbChem/Z4x4wQ+c6vr8AQQMotK/pF8
         b3uWx1RedldOOT8iHgiFiESgnQkOAqdqHOaddgqz0mz1e1StewVE79gQk1920eCyIx8o
         Z4Cw==
X-Gm-Message-State: AHQUAubfl6+h4kDbShEC4hgY27bh0dLlO2B38Ul8T2A9lnNZKRrrH0PX
        fBvvr0TLZWWX+KItSTW78atwYISMnOUHJLVabsV7lA==
X-Google-Smtp-Source: ALg8bN63R8cyctBKjAgGVYb5nGeQZNE/Gzsj4RnPioWJHn4N1mH9rjq2oPkktcNH+asAjAD0sbl10H5qJyvJZ0bldow=
X-Received: by 2002:aca:b05:: with SMTP id 5mr1920651oil.258.1548353695789;
 Thu, 24 Jan 2019 10:14:55 -0800 (PST)
MIME-Version: 1.0
References: <20190124180535.20216-1-malat@debian.org> <2b8b377a84883db1a45afb42204d8fb5a7d5ccf9.camel@sipsolutions.net>
In-Reply-To: <2b8b377a84883db1a45afb42204d8fb5a7d5ccf9.camel@sipsolutions.net>
From:   Mathieu Malaterre <malat@debian.org>
Date:   Thu, 24 Jan 2019 19:14:44 +0100
Message-ID: <CA+7wUszXbRt=j1C1PF11EtnO2ojLpvL8Zs60c7UcEDrqjRMxOw@mail.gmail.com>
Subject: Re: [PATCH] mac80211: Remove attribute packed from struct 'action'
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Jan 24, 2019 at 7:08 PM Johannes Berg <johannes@sipsolutions.net> wrote:
>
> On Thu, 2019-01-24 at 19:05 +0100, Mathieu Malaterre wrote:
> > During refactor in commit 9e478066eae4 ("mac80211: fix MU-MIMO
> > follow-MAC mode") a new struct 'action' was declared with packed
> > attribute as:
> >
> >   struct {
> >           struct ieee80211_hdr_3addr hdr;
> >           u8 category;
> >           u8 action_code;
> >   } __packed action;
> >
> > But since struct 'ieee80211_hdr_3addr' is declared with an aligned
> > keyword as:
> >
> >   struct ieee80211_hdr {
> >       __le16 frame_control;
> >       __le16 duration_id;
> >       u8 addr1[ETH_ALEN];
> >       u8 addr2[ETH_ALEN];
> >       u8 addr3[ETH_ALEN];
> >       __le16 seq_ctrl;
> >       u8 addr4[ETH_ALEN];
> >   } __packed __aligned(2);
> >
> > Solve the ambiguity of placing aligned structure in a packed one by
> > removing the packed attribute from struct. This seems to be the behavior
> > of gcc anyway, since the following is still compiling:
> >
> >   BUILD_BUG_ON(sizeof(action) != IEEE80211_MIN_ACTION_SIZE + 1);
>
> I'm not sure this will work on all platforms, didn't something like
> alpha pad out u8's to u32 when not requiring packing?

I was not aware of that.

> I guess I'd feel better about using __packed __aligned(2) here as well,
> which should solve the warning too?

Indeed, I will re-spin a v2 then.
