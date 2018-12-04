Return-Path: <SRS0=aqaD=ON=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99B30C04EB8
	for <linux-wireless@archiver.kernel.org>; Tue,  4 Dec 2018 16:38:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 56887206B6
	for <linux-wireless@archiver.kernel.org>; Tue,  4 Dec 2018 16:38:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BiX/4Fwf"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 56887206B6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbeLDQiy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 4 Dec 2018 11:38:54 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:43676 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726226AbeLDQiy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Dec 2018 11:38:54 -0500
Received: by mail-io1-f65.google.com with SMTP id f10so8329563iop.10
        for <linux-wireless@vger.kernel.org>; Tue, 04 Dec 2018 08:38:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wxaZWqyJSiLnyiLdeuwnRCR9JpcKakhAsXPqUNNRljM=;
        b=BiX/4FwfYBLJitJegiEz5AC/8gxmY6Eez0RqcfN2xO8tMRe8JsDyuhSW32MuR4sTZg
         2VjG8nCXkpmTRJC4ndtTag3K6kXfwMNOH9m3+9X8nbtnSPcvXD2039gZr5sz+Owcl26O
         TzM0UTdiu6Y2xQ0NHRzknFRk5IhAzxzY48I7tIdNt0zygyvG9G4kcUV48V5Klp38Fu3V
         qJmsiQnnSZQJ/FkH+TSq0xmRgdY0YCWRTRIgwvT2tnGC3N5ZnrdcInBtLo86xWWCjes+
         e6DrwfwgXASldWT7cEpzpNb1D03H0w6OqCmOn3En02oXwkUL9NgOFUTvjvBrmu5/whbb
         N9TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wxaZWqyJSiLnyiLdeuwnRCR9JpcKakhAsXPqUNNRljM=;
        b=DBmgUWzGxQCEVYNfIqdn42fimuVQu4AJwGnzvdenXcofBggLcHtJ1MGkxvHaPuPMFi
         bY3u0G3F8aZZ4HL7nzO4YgonfOZ7z6RkE0Z6eVKOKhetwlBHLD1DNxafN1unFH0Yk0D5
         /xNKFVMO+4+jUSTjgCkr13kJRzop3H2YfEzU6S7D/t2LceggwArDuzc+xMwvMmkEAjkV
         UCrSy9Uj7CVHA6L9BGkNadLthARNf/4g0B21Bs8nxdq9dotphg71KgesOD6oNDPj9Llv
         8xS5Bgj+iT6Clw7IHlDUqlZE3/ZvkJ4sLZ7I8Ys9utPQz27/0rd+c5RIuI1hYHoR8tcS
         LxmA==
X-Gm-Message-State: AA+aEWY16K1mRzt1PBsBKqd141LX0GGv9HdTBS4YUARqMu01eayEdXuz
        9DHyvUBcSCraCNLfPVWL0swSdHf+ptsXnxGaxznIDxqi
X-Google-Smtp-Source: AFSGD/U5u2TznBduxKdq+L2wKS9zBzQoq4cHRPvqge5yrSJcB5X5180Z01XSthb2TDdtuBzNNYtl6g9za1uas/vuVVg=
X-Received: by 2002:a5e:a619:: with SMTP id q25mr18432279ioi.82.1543941532973;
 Tue, 04 Dec 2018 08:38:52 -0800 (PST)
MIME-Version: 1.0
References: <20181204152200.2252-1-me@bobcopeland.com>
In-Reply-To: <20181204152200.2252-1-me@bobcopeland.com>
From:   Steve deRosier <derosier@gmail.com>
Date:   Tue, 4 Dec 2018 08:38:15 -0800
Message-ID: <CALLGbRKYX3b18R=oMcUajpWiGEBZJn_8Q-vhR+N87jNZzdMT7A@mail.gmail.com>
Subject: Re: [PATCH] mac80211: rewrite Kconfig text for mesh
To:     me@bobcopeland.com
Cc:     Johannes Berg <johannes@sipsolutions.net>, lkundrak@v3.sk,
        linux-wireless <linux-wireless@vger.kernel.org>,
        bobcopeland@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Dec 4, 2018 at 7:25 AM Bob Copeland <me@bobcopeland.com> wrote:
>
> Lubomir Rintel recently pointed out a dead link for o11s.org, and
> repointed it to a still live, but also stale website.  As far as I
> know, no one is updating the content at open80211s.org.
>

Indeed.  The o11s effort more or less ended after cozybit finished
writing and upstreamed the mesh code. A little maintenance and changes
happened via o11s until the 802.11s stuff was ratified, in, stable,
etc...  including by me and others at cozybit. You are correct -
AFAIK, no one is updating that site, o11s.org is down and actually
cozybit as an entity is no more either. And all of us are long
elsewhere.

> Since this Kconfig text was originally written, though, the 802.11s
> mesh drafts were approved and ultimately rolled into 802.11 proper.
> Meanwhile, the implementation has converged on the final standard,
> so we can lose all of the text here and provide something that's a
> little more helpful and accurate.
>
> Signed-off-by: Bob Copeland <bobcopeland@fb.com>
> ---
>  net/mac80211/Kconfig | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
>
> diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
> index f869e35d0974..6b09355dfc90 100644
> --- a/net/mac80211/Kconfig
> +++ b/net/mac80211/Kconfig
> @@ -57,14 +57,13 @@ comment "Some wireless drivers require a rate control algorithm"
>         depends on MAC80211 && MAC80211_HAS_RC=n
>
>  config MAC80211_MESH
> -       bool "Enable mac80211 mesh networking (pre-802.11s) support"
> +       bool "Enable mac80211 mesh networking support"
>         depends on MAC80211
>         ---help---
> -        This options enables support of Draft 802.11s mesh networking.
> -        The implementation is based on Draft 2.08 of the Mesh Networking
> -        amendment.  However, no compliance with that draft is claimed or even
> -        possible, as drafts leave a number of identifiers to be defined after
> -        ratification.  For more information visit http://o11s.org/.
> +         Select this option to enable 802.11 mesh operation in mac80211
> +         drivers that support it.  802.11 mesh connects multiple stations
> +         over (possibly multi-hop) wireless links to form a single logical
> +         LAN.
>

Looks good to me.

Reviewed-by: Steve deRosier <derosier@cal-sierra.com>

- Steve
