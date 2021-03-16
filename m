Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B580EC433E0
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Mar 2021 12:10:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84D4564EED
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Mar 2021 12:10:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbhCPMKU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 16 Mar 2021 08:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbhCPMJx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Mar 2021 08:09:53 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92791C06174A
        for <linux-wireless@vger.kernel.org>; Tue, 16 Mar 2021 05:09:52 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lM8WA-00GtnM-U6; Tue, 16 Mar 2021 13:09:47 +0100
Message-ID: <2d2e0b2031c1e8072e7a98dce9206961450c11a9.camel@sipsolutions.net>
Subject: Re: [iwlwifi] v5.12-rc1: Unable to move phy0 to other network
 namespace
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Torsten Hilbrich <torsten.hilbrich@secunet.com>,
        luciano.coelho@intel.com
Cc:     linux-wireless@vger.kernel.org
Date:   Tue, 16 Mar 2021 13:09:45 +0100
In-Reply-To: <28fee372-0dc6-6351-2b1d-c79e924952a5@secunet.com> (sfid-20210316_123944_590498_1D9DB7F3)
References: <28fee372-0dc6-6351-2b1d-c79e924952a5@secunet.com>
         (sfid-20210316_123944_590498_1D9DB7F3)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2021-03-16 at 12:38 +0100, Torsten Hilbrich wrote:
> Hello,
> 
> starting with kernel v5.12-rc1 (and still not working in v5.12-rc3) I'm
> no longer able to move a wlan interface into another namespace.
> 
> I have created a new network namespace, like in the following example:
> 
> # ip netns add black
> 
> Then I move the phy0 interface to that network namespace. I then expect the wlan0 interface to be removed from the initial network namespace and then to appear in the new one.
> 
> # iw phy phy0 set netns name black
> 
> However, starting with v5.12-rc1 (last known to be working with v5.11) the command never finishes execution. Instead, I get a number of rntl warnings and a soft hangup

Yes, oops, known bug, fix is here:

https://patchwork.kernel.org/project/linux-wireless/patch/20210310215839.eadf7c43781b.I5fc6cf6676f800ab8008e03bbea9c3349b02d804@changeid/

I'll get it sent upstream soon.

johannes

