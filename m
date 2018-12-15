Return-Path: <SRS0=s1k3=OY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4294C43387
	for <linux-wireless@archiver.kernel.org>; Sat, 15 Dec 2018 17:31:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A76562080F
	for <linux-wireless@archiver.kernel.org>; Sat, 15 Dec 2018 17:31:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lqWzr0zQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726615AbeLORbx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 15 Dec 2018 12:31:53 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:34766 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726494AbeLORbw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 15 Dec 2018 12:31:52 -0500
Received: by mail-io1-f68.google.com with SMTP id w21so7006767ioc.1;
        Sat, 15 Dec 2018 09:31:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UXaIXunpmBaiIW/nBMwnMDJ8CFAQ/G8ZOkw+k5svA7o=;
        b=lqWzr0zQJgeSzJHQJFuiI5TdLiorMD8yJ0W8+n4seaj3cwPB9yw8EbxRoOANxsf504
         jMgLSEfaoknYI6I8qIIMjXeg54zwiRQi3sizUA778nPMTYdUT/hRq3WV8buHMtfkKVvi
         omOAKmriydVkNZizauj1+5eKjAQjuHIqj6h4gHOw1PJO6TaNfSand/C/6P2mHPNx7cOW
         F3hz3pSTcXFVfZbiRzmFL65X+3gbIetlPq5AIHlKTJFL7BShciSK7yF8fKlZrcYhQZ7m
         JCYErKMtXYormzyyFjdReLH9mqPdUorJfuPsZkYjNnvPgX9dYYe1bFtNksuJrIL3Gyqc
         NT3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UXaIXunpmBaiIW/nBMwnMDJ8CFAQ/G8ZOkw+k5svA7o=;
        b=JWxAKb/4Iaxzh89k4KLEB80GIKc6D3iESoZyaPsW6ijEEcSQbbIK8lQnnGjSo48TYC
         Fgu9wg9okpu5UCGubHVIDgvFpRRTlOyAMTshOQASL1a70VrE5tD5gL6ftzNWDoPbadTv
         VaKFtQY4azNQ3BwbFQEPKNlajVn9xh73rvMrK+C3BYn2KpX8qI5yJE16C8FLCRp3Zt5a
         iQK8rK5ELvEN2ljYLvG7CArc+C0vRCkDQvOREN24NeyBvb9au2ssXG6T4GQdW5kZ/dmd
         NVsKD1tU/17nS9tm+mDlGJCU1hcOR/NvbADOvBIX9HcIDLWH4PcKvNvyozgFISKSdlcN
         lTvg==
X-Gm-Message-State: AA+aEWYy8EZSY4wbWdkgc1IooMRfb2XWEOAnjBQJhjhck55deXo5o6bM
        pvNIcnsLtb1JRUkjua3lQZBHkgmcOnh10oxE5pqzKA==
X-Google-Smtp-Source: AFSGD/WWPVvZXQPHrVOHtd656CeDBTT4gpPTQ3EHk0D3qt8IRGo8GZ8t+UC1ESg49yJyVefrF3fswzFTa6N+nviOfkg=
X-Received: by 2002:a5d:9697:: with SMTP id m23mr5965285ion.201.1544895111707;
 Sat, 15 Dec 2018 09:31:51 -0800 (PST)
MIME-Version: 1.0
References: <20181215090325.31604-1-luca@coelho.fi> <20181215090325.31604-13-luca@coelho.fi>
In-Reply-To: <20181215090325.31604-13-luca@coelho.fi>
From:   Emmanuel Grumbach <egrumbach@gmail.com>
Date:   Sat, 15 Dec 2018 19:31:39 +0200
Message-ID: <CANUX_P2En=4v24qpOvxtRSn-V8f851-mW0o4pK+-VKrprwf6_w@mail.gmail.com>
Subject: Re: [PATCH 12/24] mac80211: ignore NullFunc frames in the duplicate detection
To:     Luca Coelho <luca@coelho.fi>
Cc:     "Berg, Johannes" <johannes@sipsolutions.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        stable@vger.kernel.org,
        "Coelho, Luciano" <luciano.coelho@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sat, Dec 15, 2018 at 11:20 AM Luca Coelho <luca@coelho.fi> wrote:
>
> From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
>
> NullFunc packets should never be duplicate just like
> QoS-NullFunc packets.
>
> We saw a client that enters / exits power save with
> NullFunc frames (and not with QoS-NullFunc) despite the
> fact that the association supports HT.
> This specific client also re-uses a non-zero sequence number
> for different NullFunc frames.
> At some point, the client had to send a retransmission of
> the NullFunc frame and we dropped it, leading to a
> misalignment in the power save state.
> Fix this by never consider a NullFunc frame as duplicate,
> just like we do for QoS NullFunc frames.
>
> This fixes https://bugzilla.kernel.org/show_bug.cgi?id=201449
>

This has already been sent, it is in net.git already :)
