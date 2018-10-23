Return-Path: <SRS0=ht5v=ND=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4A34C67863
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Oct 2018 17:02:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B783520665
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Oct 2018 17:02:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B783520665
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728454AbeJXB0z (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 23 Oct 2018 21:26:55 -0400
Received: from twin.jikos.cz ([91.219.245.39]:42108 "EHLO twin.jikos.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727758AbeJXB0z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Oct 2018 21:26:55 -0400
X-Greylist: delayed 1567 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Oct 2018 21:26:54 EDT
Received: from twin.jikos.cz (jikos@[127.0.0.1])
        by twin.jikos.cz (8.13.6/8.13.6) with ESMTP id w9NGaRHF019896
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO);
        Tue, 23 Oct 2018 18:36:27 +0200
Received: from localhost (jikos@localhost)
        by twin.jikos.cz (8.13.6/8.13.6/Submit) with ESMTP id w9NGaQfR019892;
        Tue, 23 Oct 2018 18:36:26 +0200
X-Authentication-Warning: twin.jikos.cz: jikos owned process doing -bs
Date:   Tue, 23 Oct 2018 18:36:26 +0200 (CEST)
From:   Jiri Kosina <jikos@kernel.org>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>
cc:     Larry Finger <Larry.Finger@lwfinger.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Is Fixes line enough?
In-Reply-To: <20181023143856.GD6850@thunk.org>
Message-ID: <alpine.LRH.2.00.1810231833260.2860@gjva.wvxbf.pm>
References: <a99840d5-7d57-ec1f-1c70-37ffa6cfd31b@lwfinger.net> <20181023143856.GD6850@thunk.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 23 Oct 2018, Theodore Y. Ts'o wrote:

> > A question has come up on the linux-wireless ML. If a patch has a "Fixes"
> > line, is that sufficient to get it flagged as a patch in Stable, or is a
> > "Cc: Stable" line also needed?
> 
> Someone actually asked this question at the Maintainer's Summit,
> actually.  The answer was that the Fixes line is not sufficient for
> Greg's scripts; you have to have the "Cc: stable" line as well.  Greg
> tried using the Fixes line as a trigger, but there were too many cases
> where this pulled in commits that weren't really suitable for the
> Stable kernels.  Sasha's machine-learning lash up will use the Fixes
> line as a signal, but if you want to explicitly request that the patch
> should be cherry-picked into Stable, you should have the "Cc: stable"
> line.

FWIW, I brought this up already at KS 2016, see Jon's coverage here:

	https://lwn.net/Articles/705220/

My primary motivation to bring that up back then was to try to reduce the 
number of patches that are taken into -stable while there is no good 
justification for that (by requiring each and every of those having Fixes: 
present as a requirement), but it didn't really lead anywhere.

-- 
Jiri Kosina
SUSE Labs
