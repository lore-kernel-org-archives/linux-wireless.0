Return-Path: <SRS0=9Upc=RP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2735C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 20:31:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 74CA12147C
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 20:31:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbfCLUbF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Mar 2019 16:31:05 -0400
Received: from vulcan.kevinlocke.name ([107.191.43.88]:50018 "EHLO
        vulcan.kevinlocke.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726191AbfCLUbF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Mar 2019 16:31:05 -0400
Received: from kevinolos (unknown [71.15.201.20])
        (Authenticated sender: kevin@kevinlocke.name)
        by vulcan.kevinlocke.name (Postfix) with ESMTPSA id 1282CDBFB56;
        Tue, 12 Mar 2019 20:31:03 +0000 (UTC)
Received: by kevinolos (Postfix, from userid 1000)
        id F0C191300406; Tue, 12 Mar 2019 14:31:01 -0600 (MDT)
Date:   Tue, 12 Mar 2019 14:31:01 -0600
From:   Kevin Locke <kevin@kevinlocke.name>
To:     "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc:     linuxwifi@intel.com, linux-wireless@vger.kernel.org,
        "Coelho, Luciano" <luciano.coelho@intel.com>
Subject: Re: [linuxwifi] [RFC] iwlwifi: enable TX AMPDU for some iwldvm
Message-ID: <20190312203101.GA19902@kevinolos>
Mail-Followup-To: Kevin Locke <kevin@kevinlocke.name>,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
        linuxwifi@intel.com, linux-wireless@vger.kernel.org,
        "Coelho, Luciano" <luciano.coelho@intel.com>
References: <20190312171205.GA12792@kevinolos>
 <0f9132187a5567fa94e396ed317efbae1aa4de14.camel@intel.com>
 <1b6eaef941d3bc887a9fbedea47c2677e5511cdd.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1b6eaef941d3bc887a9fbedea47c2677e5511cdd.camel@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Thanks Luca and Emmanuel,

On Tue, 2019-03-12 at 19:47 +0000, Grumbach, Emmanuel wrote:
> On Tue, 2019-03-12 at 21:38 +0200, Luciano Coelho wrote:
>> If this feature was explicitly disabled, it certainly means that
>> something was causing problems with it, so I'd be wary to enable it
>> for all DVM devices.
>> 
>> I guess we could enable it by default for devices that work fine, but
>> we would have to run it in real life for a lot longer with a lot more
>> different APs to be sure it won't cause any problems.

Makes sense to me.  I can start testing with available APs.  Let me
know if there is anything specific I should look for or catalog beyond
latency, packet drop rates, and bandwidth.

>> Emmanuel, do you happen to remember what was the issue, so Kevin
>> could test that specific scenario with this specific NIC?
> 
> long long nights of despair.
> 
> We had issues with reclaim path upon BACK. This is of course a firmware
> problem...

Does that suggest the issue may have been fixed by a firmware update?
For reference, I'm currently using "firmware version 9.221.4.1 build
25532" from the firmware-iwlwifi Debian package (version 20190114-1).

If it would be helpful, I could attempt to bisect the firmware
revisions to find the one that fixed it (assuming I can reproduce the
issue with a previous firmware version).

Thanks again,
Kevin
