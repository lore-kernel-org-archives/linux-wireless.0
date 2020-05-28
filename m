Return-Path: <SRS0=UQ4x=7K=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81BD4C433DF
	for <linux-wireless@archiver.kernel.org>; Thu, 28 May 2020 16:38:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A53820829
	for <linux-wireless@archiver.kernel.org>; Thu, 28 May 2020 16:38:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405098AbgE1Qi4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 28 May 2020 12:38:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405042AbgE1Qiz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 May 2020 12:38:55 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4385C08C5C6
        for <linux-wireless@vger.kernel.org>; Thu, 28 May 2020 09:38:55 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jeLYT-004z32-5I; Thu, 28 May 2020 18:38:53 +0200
Message-ID: <a185a4283c1230965b520de52737427c91af9c22.camel@sipsolutions.net>
Subject: Re: iwlist scanning: how to exclude old scan results from output?
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Bruno Dantas <dantas@airpost.net>, linux-wireless@vger.kernel.org
Date:   Thu, 28 May 2020 18:38:50 +0200
In-Reply-To: <afef8a7d-053e-4aaa-ace7-d320c32e8b7c@www.fastmail.com> (sfid-20200528_174911_413757_32DBA783)
References: <afef8a7d-053e-4aaa-ace7-d320c32e8b7c@www.fastmail.com>
         (sfid-20200528_174911_413757_32DBA783)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.2 (3.36.2-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2020-05-28 at 11:48 -0400, Bruno Dantas wrote:
> I hope it's not too inappropriate to ask a support question here. I've
> tried at my distro's forum to no avail.
> 
> Please, how do I make "sudo iwlist <iface> scanning" display only
> results from current scan? Cached prior scan results (including no-
> longer-available hotspots) often show up in the output, which breaks
> one of my shell scripts.

You cannot.

You should use 'iw' instead of 'iwlist', which does have options for
flushing the cache.

johannes

