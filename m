Return-Path: <SRS0=Tazh=WL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E8A7C3A589
	for <linux-wireless@archiver.kernel.org>; Thu, 15 Aug 2019 15:36:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DFD2B20644
	for <linux-wireless@archiver.kernel.org>; Thu, 15 Aug 2019 15:36:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=miegl.cz header.i=@miegl.cz header.b="j18/k5de"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729924AbfHOPgw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 15 Aug 2019 11:36:52 -0400
Received: from ocelot.miegl.cz ([195.201.216.236]:60764 "EHLO ocelot.miegl.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725977AbfHOPgw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Aug 2019 11:36:52 -0400
X-Greylist: delayed 480 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Aug 2019 11:36:51 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=miegl.cz; s=dkim;
        t=1565882929; bh=RL3QjsituN+eKLm8rFAvRNU0p4kuHntE0WRM8nYx0Cc=;
        h=Date:From:To:Subject;
        b=j18/k5defNOvqDZ0rE8P8AGOKXF+u8BB2XCWI6KQ3gYzO5UvHMoTcmv8s6Ci5qWpH
         ct7UoYKKsQBtNIjiyTOP4RPJ97xjHlDoDcoNl68aE7RU9ZMBScK4lHAWREjQoQ1sZF
         as0lPxE3MFE270qNfJ/w7CvW6QZoQu4735JgWqJ12lB/u0ArF2zF7iRQTTE/vWtQk1
         awhdiAtbVL9TjT9LMmfdZBSMxm00lcD11vFmrUGoYQQbN9In0avVsLOgbNzA+xRnr9
         OqGmyt77Z+hUz/d3/nE9wbNE0N1wbRPfQMEJHOqd4zLmuac2n5nsSk/DVJTvjbsrXb
         fHrz+Q6nExvrQ==
Date:   Thu, 15 Aug 2019 17:28:44 +0200
From:   Josef Miegl <josef@miegl.cz>
To:     linux-wireless@vger.kernel.org
Subject: Implementing Mikrotik IE
Message-ID: <20190815152844.k5mmddvbwrohkzr6@pepin-laptop.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20180716
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

I've been trying to implement Mikrotik IE. It is a vendor IE that
carries stuff like radio name. Even though it is Mikrotik specific, UBNT
has a patch for madwifi:
https://github.com/jhairtt/ubnt-hal-0.7.379/blob/master/patches/madwifi-dfs-r3319-20080201/074-mtik-ie.patch

The IE is sent in beacon and assoc/reassoc frames. I think the correct
place for this is mac80211, but I'm not sure how should I expose a
switch to this functionality. Is there something like ioctl, or do I have
to implement a switch in nl80211, then in cfg80211 and then finally in
mac80211?

Any advice is greatly appreciated.
