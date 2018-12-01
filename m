Return-Path: <SRS0=FAJS=OK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E2D6C04EB8
	for <linux-wireless@archiver.kernel.org>; Sat,  1 Dec 2018 02:27:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 48B522082F
	for <linux-wireless@archiver.kernel.org>; Sat,  1 Dec 2018 02:27:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="S8/9do46"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 48B522082F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbeLANig (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 1 Dec 2018 08:38:36 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:35846 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726424AbeLANig (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 1 Dec 2018 08:38:36 -0500
Received: by mail-pf1-f196.google.com with SMTP id b85so3692840pfc.3
        for <linux-wireless@vger.kernel.org>; Fri, 30 Nov 2018 18:27:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=kXcO7SxMiWUYuTHTZUP7IvQYRbDb/BJiQKAlC9Lz5vY=;
        b=S8/9do46O8WuuaeptBdbOBsXY1E/KgwrGX1/cHI9mc+JsAx+n9aMnIJM6SL7wyUJm0
         B5UapgbZ/39KBGsA4rLwj/QPo6XAgOgj++yjua7z13X+kHaJ/7zyUJYFckQvXxXBCECh
         CR+Ttvrf8DP6Xs013qvy0BUD6Pb84GXyi8OWU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=kXcO7SxMiWUYuTHTZUP7IvQYRbDb/BJiQKAlC9Lz5vY=;
        b=WGcRy+YpnyYHtQ75C8c7+ZYPdM6fyu0kBNt9RosofG3cn0AVWejh+LgVBn22wcDa2k
         GPM1pEH6JzgoDcUZ2IUJtTpzdPVLlWqIGiHBvRZzo44y+YRNEsg5eV8D6s7HC8Uia6dC
         O60QVvytP8BopHoJR2sWytze7LPvWZ0b13pnTHOA+OxjOXorsAUj/y4kHIbVT92Ot0Ao
         1Wu1wYv4QrNk/7P/rdOLQt/So2VdWAxzwDb2llXtgFM0KuDFDwMl93jxCU+/S8cVOglm
         Fvg5eqC31oyhvwBiyOg8L/p3vLZkX6QqYuhQE5c4noi+Y/c6clglNClm40Ur8oiI4Bum
         riOw==
X-Gm-Message-State: AA+aEWbJnBRBspyiAldphMZLpCflXyAdgEELttU8aVezqLn4h79w7pZC
        Da0/aVruKcmOq2IsYKvsjp/3cg==
X-Google-Smtp-Source: AFSGD/V6fyefkK+eHATdKcPNHYKSzN5ASWHGjZSDzXkebPRuC5h2WiZrst7FDyiMdK71L/HcrnIuSg==
X-Received: by 2002:a63:db02:: with SMTP id e2mr6774601pgg.419.1543631233672;
        Fri, 30 Nov 2018 18:27:13 -0800 (PST)
Received: from google.com ([2620:15c:202:1:534:b7c0:a63c:460c])
        by smtp.gmail.com with ESMTPSA id x19sm10745926pfk.14.2018.11.30.18.27.12
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 30 Nov 2018 18:27:12 -0800 (PST)
Date:   Fri, 30 Nov 2018 18:27:11 -0800
From:   Brian Norris <briannorris@chromium.org>
To:     Ganapathi Bhat <gbhat@marvell.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Xinming Hu <huxinming820@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [EXT] [4.20 PATCH] Revert "mwifiex: restructure
 rx_reorder_tbl_lock usage"
Message-ID: <20181201022710.GA237752@google.com>
References: <20181130175957.167031-1-briannorris@chromium.org>
 <2cbb1f04ef8545ad9eaf3d7551a5dc03@SC-EXCH02.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2cbb1f04ef8545ad9eaf3d7551a5dc03@SC-EXCH02.marvell.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, Nov 30, 2018 at 07:04:49PM +0000, Ganapathi Bhat wrote:
> > This was clearly not tested well at all. I simply performed 'wget' in a loop and
> > it fell over within a few seconds.
> Sorry. I had run a iperf test before sharing the patch (no regression observed).
> It looks I failed to get this right for second time I will check this.

Were you running on an 11n/ac network? IIUC, the particular code that's
being blamed is only active with 11n+ features.

You might also make sure you test with stuff like lockdep enabled, as
that gives nice warnings and can even preemptively warn about potential
problems before they even occur, if you use the right settings. (Some
lockdep configurations can slow things down significantly, BTW.)

Brian
