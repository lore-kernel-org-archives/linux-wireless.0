Return-Path: <SRS0=OUAD=SF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: *
X-Spam-Status: No, score=1.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 358BCC10F0B
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 21:02:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EACB02082C
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 21:02:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="aDSAFST9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbfDCVCH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Apr 2019 17:02:07 -0400
Received: from mail-pf1-f178.google.com ([209.85.210.178]:44491 "EHLO
        mail-pf1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726206AbfDCVCG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Apr 2019 17:02:06 -0400
Received: by mail-pf1-f178.google.com with SMTP id y13so173955pfm.11
        for <linux-wireless@vger.kernel.org>; Wed, 03 Apr 2019 14:02:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=mSOfPJwtRVs9iUaKl29+lgeypa/AilcFV2DDdu3zgpE=;
        b=aDSAFST9Z4IVNWGDsXVhhK/FXVDClKsQRqQabBz/MmLWE7LWrkNSS49A+5LsWjnCQK
         RF/qMxESLqxHQqtxGecuLT1NnvSQfHIs6bVuS0GWfy3WTbUFBOVPJexolvuIdY5q6upD
         abSSvLVPLz6RyijQC1F27NN648kjqyvk6O95w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=mSOfPJwtRVs9iUaKl29+lgeypa/AilcFV2DDdu3zgpE=;
        b=XLvUSFCUsTyUsynljUy5heo5dKCAlJ1EbDSaTgixA3B9DXF8QoOz1RQEWGu+lo6XnI
         NpCNiW4egE2nq0QT6Z+60CB7tZmQ/u110Fa66s9CedYLm2hzE/Z0BI2n0DxOc/MFd+gp
         5jsrM3AUUTQsbnok1vwbbHfxdNeovBeTUwOAwN//29zzokFrF8IK9ZBpU6Nl1B+1KIEE
         Y5wsnOuMN9f+jCN2j0EyRtgxNvUoM87TB2nPaQ//5e1Lvdl9lfnKOpIXPOayEWblJ78m
         +r0Y5aQQAOYNIWVp9kHTCryB4WcXrPQ7lAiGU7A4rjwOuox/+/8KGlezLcuPPuRZZwzD
         KpiQ==
X-Gm-Message-State: APjAAAW1yYumqOTAKiOA7Ekiz5xllkVP8eytXZubNvMDrqJz6McGcRqz
        fACpeQzFZ6XJVUgsJTr+Tq6P1UvzVnE=
X-Google-Smtp-Source: APXvYqzRiFZGDHy/5y/CGVTkPbd7Bx50OkQXd85Dbagrvoda5EJroJe3ADsgHqrgYUd7K6adPzeDmw==
X-Received: by 2002:a63:5e43:: with SMTP id s64mr1770695pgb.15.1554325325227;
        Wed, 03 Apr 2019 14:02:05 -0700 (PDT)
Received: from google.com ([2620:15c:202:1:534:b7c0:a63c:460c])
        by smtp.gmail.com with ESMTPSA id k14sm23663209pfb.125.2019.04.03.14.02.03
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 03 Apr 2019 14:02:04 -0700 (PDT)
Date:   Wed, 3 Apr 2019 14:02:02 -0700
From:   Brian Norris <briannorris@chromium.org>
To:     Matthew Wang <matthewmwang@google.com>
Cc:     linux-wireless@vger.kernel.org,
        Kirtika Ruchandani <kirtika@google.com>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Flag for detecting 802.11r Fast BSS Transition support
Message-ID: <20190403210200.GA93453@google.com>
References: <CAAooHFeLWrY_wmCp-HWqygh8gnKsfpoPCky7SykOBKZgXkb8OQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAooHFeLWrY_wmCp-HWqygh8gnKsfpoPCky7SykOBKZgXkb8OQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

+ Johannes

On Thu, Oct 04, 2018 at 12:06:50PM -0700, Matthew Wang wrote:
> Hi,
> 
> I'm wondering if there is a flag for detecting firmware/driver support
> for FT. It seems like checking for SME support is a pretty good proxy
> for this, but there is a non-mac80211 driver that can do FT as well
> (ath/wil6210). It would be great if anyone knows of a feature flag
> specifically for FT.

I chatted with Johannes, and he agreed that there was no such flag
today. It also sounded like he was open to adding one, even if it's
several years too late. I don't think there's any useful way people
could (generically) use FT support today.

Brian
