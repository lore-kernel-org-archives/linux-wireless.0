Return-Path: <SRS0=LItA=3E=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 122BAC33CB2
	for <linux-wireless@archiver.kernel.org>; Wed, 15 Jan 2020 13:40:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D1CC324656
	for <linux-wireless@archiver.kernel.org>; Wed, 15 Jan 2020 13:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1579095617;
	bh=vq7dWZIt2uzMmU//MJnDRlhzag57tdT+vRJG617udFk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=QoppMseHWLueuQBPPOCfoeMOtBfHCwwWlo0xxw59uoe+x9chlpZLKep6Il6RQ9yER
	 SYSlvw6IOK2px7nGwT9c2Qw5gif46+0/f13aT2KPkE7rnxogXO+A4hEPMKjh6PJVHq
	 j8PCfQFS8aeqlX8PzSFcN7X2Z355EM5+R5FivD04=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728977AbgAONkO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 15 Jan 2020 08:40:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:51314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726071AbgAONkN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Jan 2020 08:40:13 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5FF6B207FF;
        Wed, 15 Jan 2020 13:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579095613;
        bh=vq7dWZIt2uzMmU//MJnDRlhzag57tdT+vRJG617udFk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pAuyIq2GysfG9S3GlghWZ6CQmBaqtmrJezPEwteygMOKNCDLyRE8eXRMflMeiWvza
         ufxC+sjMlz+9DD3PZkDbc0BoAThgdsDIQNqRr1tk8EOCy/UIhVDW5o/9iA2wj0sGcO
         xXVuV696c5E89sRBN9ayELZBHVGuO9qzKoEW1wI8=
Date:   Wed, 15 Jan 2020 14:40:10 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     =?iso-8859-1?B?Suly9G1l?= Pouiller <Jerome.Pouiller@silabs.com>
Cc:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH 00/65] Simplify and improve the wfx driver
Message-ID: <20200115134010.GA3555935@kroah.com>
References: <20200115121041.10863-1-Jerome.Pouiller@silabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200115121041.10863-1-Jerome.Pouiller@silabs.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Jan 15, 2020 at 12:12:07PM +0000, Jérôme Pouiller wrote:
> From: Jérôme Pouiller <jerome.pouiller@silabs.com>
> 
> Hello all,
> 
> This pull request is finally bigger than I expected, sorry.

After applying this series, I get this build error:

drivers/staging/wfx/sta.c: In function ‘wfx_cqm_bssloss_sm’:
drivers/staging/wfx/sta.c:91:28: error: expected ‘;’ before ‘struct’
   91 |   struct ieee80211_hdr *hdr
      |                            ^
      |                            ;
   92 |   struct ieee80211_tx_control control = { };
      |   ~~~~~~
drivers/staging/wfx/sta.c:99:3: error: ‘hdr’ undeclared (first use in this function); did you mean ‘idr’?
   99 |   hdr = (struct ieee80211_hdr *)skb->data;
      |   ^~~
      |   idr

Did you even test-build this?

I could try to bisect and track down the offending commit, but that's
too much work :)

I'll wait for a v2 of this series, please fix up and resend.

thanks,

greg k-h
