Return-Path: <SRS0=Y0IC=ZO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 597F6C43215
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Nov 2019 17:34:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 32F242071F
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Nov 2019 17:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1574444054;
	bh=irjQEPHQ0B/bBVOw9LXstzMmwaBvkQEk1Zy4mmAlCS4=;
	h=Date:From:To:Cc:Subject:List-ID:From;
	b=r4/9VpD6FWkKi9+i0CPIeOjSpNY5g/JzhqxY1mNU1Kb4PDy7qBC104+idMeai5nwC
	 69jWOKjNuroYyNy4YS3QlUb8qnH813P839t5OPuhObzk/Fin4oAhXgSS/TwDnZ+XX4
	 tbTVoy6bmQZUfAOZP02rvasHXDkFeCTS4WxstF58=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbfKVReN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Nov 2019 12:34:13 -0500
Received: from mail.stusta.mhn.de ([141.84.69.5]:54714 "EHLO
        mail.stusta.mhn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbfKVReN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Nov 2019 12:34:13 -0500
X-Greylist: delayed 575 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Nov 2019 12:34:12 EST
Received: from [127.0.0.1] (localhost [127.0.0.1])
        by mail.stusta.mhn.de (Postfix) with ESMTPSA id 47KNb62SwHz4Y;
        Fri, 22 Nov 2019 18:24:34 +0100 (CET)
Date:   Fri, 22 Nov 2019 19:24:31 +0200
From:   Adrian Bunk <bunk@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, stable@vger.kernel.org
Subject: Please backport "mwifiex: Fix NL80211_TX_POWER_LIMITED" to stable
 branches
Message-ID: <20191122172431.GA24156@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Please backport commit 65a576e27309120e0621f54d5c81eb9128bd56be
"mwifiex: Fix NL80211_TX_POWER_LIMITED" to stable branches.

It is a non-CVE kind of security issue when a wifi adapter
exceeds the configured TX power limit.

The commit applies and builds against all branches from 3.16 to 4.19, 
confirmed working with 4.14. It is already included in kernel 5.3.

Thanks in advance
Adrian
