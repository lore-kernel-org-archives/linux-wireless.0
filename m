Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79A48C43143
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 10:44:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E8612064A
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 10:44:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KyvWCTjq"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2E8612064A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728926AbeJARVn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Oct 2018 13:21:43 -0400
Received: from mail-it1-f194.google.com ([209.85.166.194]:35121 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728791AbeJARVn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Oct 2018 13:21:43 -0400
Received: by mail-it1-f194.google.com with SMTP id p64-v6so3632736itp.0
        for <linux-wireless@vger.kernel.org>; Mon, 01 Oct 2018 03:44:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=8JX+5I+2QhctUc48kVLUlJGQd1d2uir+kJKrfJE+Q1Q=;
        b=KyvWCTjqlTGV2FbPWTcHvf5vHof8uKaTBvUnsHorRzAlPAiw89FfOYEk6GMFOjLx4E
         b+YNzCw9+E0/gQAEXqFqNV787OYGCvdfthZ8MVGbIIKDnLdAxVUE4X9+94DPgczxMZv9
         uiyL32zyFoLr2NIaC6BBrQj4d04v/nQqJJiVSJ0nFsq0Sq8WBsHEDrLoXcNn50cg+8Pq
         3AA6d6N6EXFokOVhnZofELrDQcXGuxO52Uf1hTrrpSaWwSiubt+QZ9iBCp6X9sYxYLiS
         kPPP0pVcLoNmzvpFvgPmPniGfyG5ciJvMQwoPJRj1we3MwwXQtimA/56/CwIUsoe3MYW
         EZFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=8JX+5I+2QhctUc48kVLUlJGQd1d2uir+kJKrfJE+Q1Q=;
        b=cEtbPJIlx3IHjoWNDs+3LzugTXFqv59kze6UJHMNLGg+hcwh/FXY+dCW0sDavmpeIe
         jpVnAGUG93XFFLNLNjlfRRw6d+kcYVABd/RFzB8WvEhy3XUUXwA4myCEbBkt+YVmVaKV
         gdI4VLs3qF7LbBXs2XXCl/Ae5lsSrCLt07ncqLus7Y76tQJuYIVPukhY+ahxuOz5lVnJ
         NEQ3IMeGyXbbGomf3ix6BMFtbamTX8Q9GRADbo+j4AlDqRRUHJA6f/Wt8LBrmf+z/aZt
         lDfVtTTUuRuzCyPaRabAHRZpYrWBQ0R2y7RoeIJ3XmsQ+QlqHN7MKxBS8e0KLhPr7C3G
         Exig==
X-Gm-Message-State: ABuFfohswypTnHsR6I+rAbcpenOKYpub0HtIeovbDhAihekFyEkguNum
        x8mwsjyV9P7NIIxzsDERs8K1xZHbf2SHrzKPpp4wYgE4l3U=
X-Google-Smtp-Source: ACcGV61QhmrobddLxTyk6dEPQVmic2A8iDm/rTXAQj+pnkOYvF/IvEgjrLkkLJwLY11gczn87HQbjsoRA8YFJQYbSWU=
X-Received: by 2002:a24:118f:: with SMTP id 137-v6mr9061860itf.30.1538390671694;
 Mon, 01 Oct 2018 03:44:31 -0700 (PDT)
MIME-Version: 1.0
References: <20180925081933.28553-1-enrique.giraldo@galgus.net> <1537954007.28767.10.camel@sipsolutions.net>
In-Reply-To: <1537954007.28767.10.camel@sipsolutions.net>
From:   Enrique Giraldo <hgiraldos@gmail.com>
Date:   Mon, 1 Oct 2018 12:44:19 +0200
Message-ID: <CAEbaMQKC4nCL=aZWdf7xSFcO1wJ0qP6scnW7a4gg5M3AEx1qYQ@mail.gmail.com>
Subject: Re: [PATCH] New functionality for aborting ongoing CAC.
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Enrique Giraldo <enrique.giraldo@galgus.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

You are right, it is possible to do it as you comment
(NL80211_CMD_STOP_AP and then NL80211_CMD_START_AP). It is therefore
not necessary a specific command to abort the CAC.
Thank you very much for the clarification and the time spent.

PS: If you use OpenWRT you have to control the STOP and the START, the
command "wifi" does not work properly.
El mi=C3=A9., 26 sept. 2018 a las 11:26, Johannes Berg
(<johannes@sipsolutions.net>) escribi=C3=B3:
>
> On Tue, 2018-09-25 at 10:19 +0200, Enrique Giraldo wrote:
> > Add NL80211_CMD_ABORT_CAC to the nl80211 interface.
>
> As Arend pointed out, this really needs a much better commit message.
>
> Please also adjust the subject to have a proper prefix etc. See
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpa=
tches
> for some help with that.
>
> > @@ -3227,6 +3228,7 @@ struct cfg80211_ops {
> >       int     (*scan)(struct wiphy *wiphy,
> >                       struct cfg80211_scan_request *request);
> >       void    (*abort_scan)(struct wiphy *wiphy, struct wireless_dev *w=
dev);
> > +     void    (*abort_cac)(struct wiphy *wiphy, struct wireless_dev *wd=
ev);
>
> This is fine, you can add in the middle of the struct.
>
> >
> > @@ -1220,6 +1223,7 @@ enum nl80211_commands {
> >       NL80211_CMD_WIPHY_REG_CHANGE,
> >
> >       NL80211_CMD_ABORT_SCAN,
> > +     NL80211_CMD_ABORT_CAC,
> >
> >       NL80211_CMD_START_NAN,
>
> This is *not* OK, as the comments here indicate, we must never add
> anything in the middle of this enum, doing so breaks userspace ABI.
>
> johannes
