Return-Path: <SRS0=ht5v=ND=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7162AC46475
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Oct 2018 14:39:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3AB6A20652
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Oct 2018 14:39:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=thunk.org header.i=@thunk.org header.b="FUHbHd+w"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3AB6A20652
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=mit.edu
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728176AbeJWXCv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 23 Oct 2018 19:02:51 -0400
Received: from imap.thunk.org ([74.207.234.97]:48876 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727829AbeJWXCv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Oct 2018 19:02:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=thunk.org;
         s=ef5046eb; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ZUUyvOv+SDlYPpYvAvKrprUZi1eEyh/sA/WJpgeGqD8=; b=FUHbHd+wz72+DCXtj1bGJBgqws
        MZw67Z4CcYu6tzc05Wj64QNEsxS5KoeNA122cnOrhtHUjYyibCL3fDguJki+K/a2BfuoVAaLLqM1q
        NtfAQllSxiUUqRHkYSfSmcQkJNqnE1YD47q43W/p1/R8HYnHZYIFFofrY+IigBsGVc5U=;
Received: from root (helo=callcc.thunk.org)
        by imap.thunk.org with local-esmtp (Exim 4.89)
        (envelope-from <tytso@thunk.org>)
        id 1gExpq-00027F-7Q; Tue, 23 Oct 2018 14:39:07 +0000
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id A9F617A56BE; Tue, 23 Oct 2018 10:38:56 -0400 (EDT)
Date:   Tue, 23 Oct 2018 10:38:56 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Larry Finger <Larry.Finger@lwfinger.net>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Is Fixes line enough?
Message-ID: <20181023143856.GD6850@thunk.org>
Mail-Followup-To: "Theodore Y. Ts'o" <tytso@mit.edu>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
References: <a99840d5-7d57-ec1f-1c70-37ffa6cfd31b@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a99840d5-7d57-ec1f-1c70-37ffa6cfd31b@lwfinger.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Oct 23, 2018 at 09:05:20AM -0500, Larry Finger wrote:
> Greg,
> 
> A question has come up on the linux-wireless ML. If a patch has a "Fixes"
> line, is that sufficient to get it flagged as a patch in Stable, or is a
> "Cc: Stable" line also needed?

Someone actually asked this question at the Maintainer's Summit,
actually.  The answer was that the Fixes line is not sufficient for
Greg's scripts; you have to have the "Cc: stable" line as well.  Greg
tried using the Fixes line as a trigger, but there were too many cases
where this pulled in commits that weren't really suitable for the
Stable kernels.  Sasha's machine-learning lash up will use the Fixes
line as a signal, but if you want to explicitly request that the patch
should be cherry-picked into Stable, you should have the "Cc: stable"
line.

(Also mentioned that at the Maintainer's Summit was that we probably
do need to take a look at the Stable documentation and see how it
needs to be updated to reflect how things are currently behind
handled.  :-)

Cheers,

						- Ted
