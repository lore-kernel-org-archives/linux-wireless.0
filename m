Return-Path: <SRS0=9Upc=RP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68BC3C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 21:44:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 37DE92077B
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 21:44:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbfCLVou (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Mar 2019 17:44:50 -0400
Received: from vulcan.kevinlocke.name ([107.191.43.88]:50222 "EHLO
        vulcan.kevinlocke.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbfCLVot (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Mar 2019 17:44:49 -0400
Received: from kevinolos (unknown [71.15.201.20])
        (Authenticated sender: kevin@kevinlocke.name)
        by vulcan.kevinlocke.name (Postfix) with ESMTPSA id 493FCDBFD9C;
        Tue, 12 Mar 2019 21:44:47 +0000 (UTC)
Received: by kevinolos (Postfix, from userid 1000)
        id E7B97130040B; Tue, 12 Mar 2019 15:44:45 -0600 (MDT)
Date:   Tue, 12 Mar 2019 15:44:45 -0600
From:   Kevin Locke <kevin@kevinlocke.name>
To:     "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc:     linuxwifi@intel.com, linux-wireless@vger.kernel.org,
        "Coelho, Luciano" <luciano.coelho@intel.com>
Subject: Re: [linuxwifi] [RFC] iwlwifi: enable TX AMPDU for some iwldvm
Message-ID: <20190312214445.GA20993@kevinolos>
Mail-Followup-To: Kevin Locke <kevin@kevinlocke.name>,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
        linuxwifi@intel.com, linux-wireless@vger.kernel.org,
        "Coelho, Luciano" <luciano.coelho@intel.com>
References: <20190312171205.GA12792@kevinolos>
 <0f9132187a5567fa94e396ed317efbae1aa4de14.camel@intel.com>
 <1b6eaef941d3bc887a9fbedea47c2677e5511cdd.camel@intel.com>
 <20190312203101.GA19902@kevinolos>
 <58bd45ab11912eef5c809427449a31800ecdbf53.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <58bd45ab11912eef5c809427449a31800ecdbf53.camel@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2019-03-12 at 20:48 +0000, Grumbach, Emmanuel wrote:
> On Tue, 2019-03-12 at 14:31 -0600, Kevin Locke wrote:
>> On Tue, 2019-03-12 at 19:47 +0000, Grumbach, Emmanuel wrote:
>>> We had issues with reclaim path upon BACK. This is of course a
>>> firmware problem...
>> 
>> Does that suggest the issue may have been fixed by a firmware update?
>> For reference, I'm currently using "firmware version 9.221.4.1 build
>> 25532" from the firmware-iwlwifi Debian package (version 20190114-1).
>> 
>> If it would be helpful, I could attempt to bisect the firmware
>> revisions to find the one that fixed it (assuming I can reproduce the
>> issue with a previous firmware version).
> 
> Well.. Sorry, I wasn't very "technical".
> So the problem was really that we stopped getting BACK notifications
> from the firmware and that caused a reclaim stall which in turn was
> caught by a Tx queue stuck timer firing in the driver.
> I was never able to reproduce this. What I can do is to enable A-MPDU
> on my old system that has this same device, just to see what happens.

Thanks for the additional details and for offering to try it out, that
would be great!

> While chasing this bug, I even found another one which bought me a few
> moments of fame:
> 
> commit d6ee27eb13beab94056e0de52d81220058ca2297
> Author: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> Date:   Wed Jun 6 09:13:36 2012 +0200
> 
>     iwlwifi: don't mess up the SCD when removing a key
> 
> and in the commit message of that very commit:
> 
>     This doesn't seem to fix the higher queues that get stuck
>     from time to time.
> 
> There were no new versions of the firmware released since then.
> I tried to skim through bugzilla, but couldn't find the bugs I was
> handling then.

Ah.  You are right about the firmware version.  I should have checked.

I see what you mean.  I found several reports for TX queue stuck
issues in Bugzilla.  Perhaps this is one (or one of its many dups):
https://bugzilla.kernel.org/show_bug.cgi?id=56581

Let me know if there is anything I can do to help search or test.

Thanks again,
Kevin
