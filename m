Return-Path: <SRS0=ht5v=ND=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3745DC67863
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Oct 2018 17:37:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E950320665
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Oct 2018 17:37:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=thunk.org header.i=@thunk.org header.b="VTesovJ8"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E950320665
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=mit.edu
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728824AbeJXCCN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 23 Oct 2018 22:02:13 -0400
Received: from imap.thunk.org ([74.207.234.97]:49480 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728491AbeJXCCN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Oct 2018 22:02:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=thunk.org;
         s=ef5046eb; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=6zDC660enyPzZB14uWv3BH41ZC3Cl5MbVDd/YbCW9Cc=; b=VTesovJ8ki1sMbeMeNcI/1oeru
        Q9dUTGLYdhEtSr2FWelSw4owNJM4uznAbW/Ssv5ingbNh8go8noWVg28g77wS+G5HVTWi+DjAvPtv
        l7Xme1xZ/4eeELioEQM88cXpeoJtWeXwGOWYYJNawmewHRQiVd42LrSIb4pyg9Z8ohNs=;
Received: from root (helo=callcc.thunk.org)
        by imap.thunk.org with local-esmtp (Exim 4.89)
        (envelope-from <tytso@thunk.org>)
        id 1gF0cn-0003SR-Ja; Tue, 23 Oct 2018 17:37:49 +0000
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id D9D147A36C3; Tue, 23 Oct 2018 13:37:47 -0400 (EDT)
Date:   Tue, 23 Oct 2018 13:37:47 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Jiri Kosina <jikos@kernel.org>
Cc:     Larry Finger <Larry.Finger@lwfinger.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Is Fixes line enough?
Message-ID: <20181023173747.GG6850@thunk.org>
Mail-Followup-To: "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jiri Kosina <jikos@kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
References: <a99840d5-7d57-ec1f-1c70-37ffa6cfd31b@lwfinger.net>
 <20181023143856.GD6850@thunk.org>
 <alpine.LRH.2.00.1810231833260.2860@gjva.wvxbf.pm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1810231833260.2860@gjva.wvxbf.pm>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Oct 23, 2018 at 06:36:26PM +0200, Jiri Kosina wrote:
> FWIW, I brought this up already at KS 2016, see Jon's coverage here:
> 
> 	https://lwn.net/Articles/705220/
> 
> My primary motivation to bring that up back then was to try to reduce the 
> number of patches that are taken into -stable while there is no good 
> justification for that (by requiring each and every of those having Fixes: 
> present as a requirement), but it didn't really lead anywhere.

Ah, I didn't get that you were trying to suggest that things only go
into stable if it has both Fixes: *and* Cc: Stable.

If that's the problem you were trying to solve, perhaps we could ask
Stephen Rothwell if he would be willing to run a script that sends
nag-o-grams to Maintainers who incluce patches in linux-next that have
Cc: stable but neither Fixes nor a "# 4.x" appended to the end of the
Cc: stable line?

						- Ted
