Return-Path: <SRS0=Jk3u=RW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D285C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Mar 2019 21:21:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 665C920850
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Mar 2019 21:21:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=wetzel-home.de header.i=@wetzel-home.de header.b="lSiZ/pbO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727422AbfCSVVy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Mar 2019 17:21:54 -0400
Received: from 9.mo177.mail-out.ovh.net ([46.105.72.238]:37588 "EHLO
        9.mo177.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726712AbfCSVVy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Mar 2019 17:21:54 -0400
Received: from player746.ha.ovh.net (unknown [10.109.160.25])
        by mo177.mail-out.ovh.net (Postfix) with ESMTP id 391E2EB138
        for <linux-wireless@vger.kernel.org>; Tue, 19 Mar 2019 21:44:11 +0100 (CET)
Received: from awhome.eu (p4FF91B93.dip0.t-ipconnect.de [79.249.27.147])
        (Authenticated sender: postmaster@awhome.eu)
        by player746.ha.ovh.net (Postfix) with ESMTPSA id E83923F1376C;
        Tue, 19 Mar 2019 20:44:09 +0000 (UTC)
Subject: Re: [PATCH 5/5] mac80211_hwsim: Ext Key ID support (NATIVE)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wetzel-home.de;
        s=wetzel-home; t=1553028249;
        bh=5T9YNxIYPypzgzVa6EtMzjZGhcAZaAwHmFdpvd83frY=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To;
        b=lSiZ/pbOjqOtSMft2bX0O+SvmlYIC5oZqW9ZJX9VlWX9WfkEnS+3oQZvQueoaob5c
         sziBVmz+FEiwW/G1Wxm56y5la7WIPq+/dsgmJ4qSzJyNT4t4a1P2NPpE3bYhLBdj8C
         ljxob29t45LoYmL7AOdMh2VoJLejuEPXKLQwH0jQ=
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org
References: <20190316204208.16497-1-alexander@wetzel-home.de>
 <20190316204208.16497-6-alexander@wetzel-home.de>
 <d4db2ae373172afa8d2eb22e92a54a6f921784b7.camel@sipsolutions.net>
From:   Alexander Wetzel <alexander@wetzel-home.de>
Message-ID: <3ddf7283-7a35-cb0e-a7a1-d682f6bf9582@wetzel-home.de>
Date:   Tue, 19 Mar 2019 21:44:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <d4db2ae373172afa8d2eb22e92a54a6f921784b7.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 6096466524276464839
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedutddrieeggddugeefucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddm
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

>> Driver is not supporting hardware encryption and therefore fully
>> compatible with Extended Key ID.
> 
> On this particular patch now reading this I'm wondering if we shouldn't
> just do that in mac80211 if there's no set_key callback? I suspect
> that'd affect a few drivers that are otherwise more or less orphaned.

Good idea.
It's costing next to nothing to enable it for for drivers without a 
set_key() callback, so I've just released v2 of the patch doing exactly 
that. I kept all the information what has changed since the last RFC 
series in the cover letter and the patches, so you can just ignore v1 of 
the patch and directly move to v2.

Alexander



