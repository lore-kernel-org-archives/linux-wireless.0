Return-Path: <SRS0=4wL/=7E=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D78DDC433E0
	for <linux-wireless@archiver.kernel.org>; Fri, 22 May 2020 18:18:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73C5B206F6
	for <linux-wireless@archiver.kernel.org>; Fri, 22 May 2020 18:18:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=hyperfekt.net header.i=@hyperfekt.net header.b="YzAhTOVE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730808AbgEVSSv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 May 2020 14:18:51 -0400
Received: from mail2.protonmail.ch ([185.70.40.22]:13981 "EHLO
        mail2.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726373AbgEVSSv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 May 2020 14:18:51 -0400
Date:   Fri, 22 May 2020 18:18:38 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hyperfekt.net;
        s=protonmail; t=1590171529;
        bh=nuzOwIlYxnLZ2euWHdne2bNZw+FikysFttcJoP9y7j8=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=YzAhTOVEr0+Ksoh+4yYykWFD+TLWNmpZ6f/clnCDqMK6twqO6m/VpKDBE3VA1yVdF
         xOqM28kM39JUaUBo1UbYQPcivHcSZFe2Af1M+ZG2V3JnlwIMEAB2zS7g8n32uslROV
         fCfgs2JvuQcm/ZMdTVjNZ371N9t9GXCpRsgvbByQ=
To:     hyperfekt <linux-wireless@hyperfekt.net>
From:   hyperfekt <linux-wireless@hyperfekt.net>
Cc:     johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
        luca@coelho.fi
Reply-To: hyperfekt <linux-wireless@hyperfekt.net>
Subject: (No Subject)
Message-ID: <20200522181832.13840-1-linux-wireless@hyperfekt.net>
In-Reply-To: <20200519095732.16268-1-linux-wireless@hyperfekt.net>
References: <20200519095732.16268-1-linux-wireless@hyperfekt.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Subject: Re: [PATCH 8/8] mac80211: IBSS: send deauth when expiring inactive=
 STAs

After running a kernel without the patch some more, I can say that that onl=
y
seems to reduce the frequency of the lockups, instead of eliminating them.

I don't really feel capable of debugging this on my own, but the last kerne=
l
version this problem does not occur on is 5.3.

