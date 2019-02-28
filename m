Return-Path: <SRS0=yJNj=RD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CC4BC43381
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 21:24:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 217A920854
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 21:24:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729322AbfB1VYA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 28 Feb 2019 16:24:00 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:35164 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728045AbfB1VX7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Feb 2019 16:23:59 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC5)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gzT9n-0001Mz-Mt; Thu, 28 Feb 2019 22:23:55 +0100
Message-ID: <5ec99b14c40a178b726313f5af7a166f4aed8e44.camel@sipsolutions.net>
Subject: Re: long startup delay ath10k_pci known issue?
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Kalle Valo <kvalo@codeaurora.org>, Robert White <rwhite@pobox.com>
Cc:     linux-wireless@vger.kernel.org
Date:   Thu, 28 Feb 2019 22:23:54 +0100
In-Reply-To: <877edk1f6j.fsf@purkki.adurom.net> (sfid-20190228_093803_234305_61F241F7)
References: <53b7cbe9-f419-24c7-0f51-37f92e11df1d@pobox.com>
         <877edk1f6j.fsf@purkki.adurom.net> (sfid-20190228_093803_234305_61F241F7)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2019-02-28 at 10:37 +0200, Kalle Valo wrote:
> 
> > Is this long delay after module and firmware load some expected effect
> > that I need to code around or what?
> 
> Usually these 60 second (or it's multiply) delays are caused by kernel
> requesting a firmware image from user space but the corresponding user
> space component is not replying and kernel waits for the reply until it
> timeouts and continues. IIRC there's a kernel config option you can use
> to disable this feature, or you could also try to fix the user space.

Regardless though, fixing this will just make the race condition less
likely, not fix it.

Most wifi NICs these days will load firmware because they need to run
it, and they will typically have to load the firmware *before* they
register their wiphy/netdev. Due to technical considerations (built-in
drivers etc.) the firmware load pretty much has to happen
asynchronously.

As a result, modprobe will return before the netdev exists. Now, in your
case you likely have some sort of firmware problem like Kalle says,
which causes it to take an excessive amount of time, perhaps by calling
out to a userspace helper that doesn't work and thus doesn't answer
negatively?

However, the fact remains that you shouldn't assume that modprobe
returning means anything - the netdev will exists when that happens, and
you should trigger your networking startup on the event that says it
exists now.

johannes

