Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EB97C636D4
	for <linux-wireless@archiver.kernel.org>; Mon, 13 Feb 2023 12:24:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbjBMMYw convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 13 Feb 2023 07:24:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231193AbjBMMYq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Feb 2023 07:24:46 -0500
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19CAB18A9A
        for <linux-wireless@vger.kernel.org>; Mon, 13 Feb 2023 04:24:36 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id 89C31642ECB8;
        Mon, 13 Feb 2023 13:24:34 +0100 (CET)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id 5JmuXyD4XZKA; Mon, 13 Feb 2023 13:24:34 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id 05FC76323048;
        Mon, 13 Feb 2023 13:24:34 +0100 (CET)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id vvfLvRO0uh4R; Mon, 13 Feb 2023 13:24:33 +0100 (CET)
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
        by lithops.sigma-star.at (Postfix) with ESMTP id DC5F2642ECB8;
        Mon, 13 Feb 2023 13:24:33 +0100 (CET)
Date:   Mon, 13 Feb 2023 13:24:33 +0100 (CET)
From:   Richard Weinberger <richard@nod.at>
To:     kvalo <kvalo@kernel.org>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>,
        ath11k <ath11k@lists.infradead.org>
Message-ID: <370539199.123516.1676291073661.JavaMail.zimbra@nod.at>
In-Reply-To: <873579wze8.fsf@kernel.org>
References: <1263051271.53086.1674425560245.JavaMail.zimbra@nod.at> <873579wze8.fsf@kernel.org>
Subject: Re: Resume from hibernation fails due to ath11k_pci
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [195.201.40.130]
X-Mailer: Zimbra 8.8.12_GA_3807 (ZimbraWebClient - FF97 (Linux)/8.8.12_GA_3809)
Thread-Topic: Resume from hibernation fails due to ath11k_pci
Thread-Index: m1FCqBhgubupsnJMxfUBeHozk0YSRg==
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

----- Ursprüngliche Mail -----
> Von: "kvalo" <kvalo@kernel.org>
> Richard Weinberger <richard@nod.at> writes:
> 
>> On my shiny new Lenovo T14s resume from hibernation always fails, and crashes
>> the kernel.
>> Looks like ath11k_pci is unable to resume the device.
>> This happens also with Linus' tree as of today.
> 
> Unfortunately a known issue in ath11k but no fix available:
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=214649

So the device is unable to operate after entering ACPI S4.

Is this a bug in the Linux ath11k driver itself or more likely a firmware
chip issue?
I didn't verify whether resume works on Windows though.

Thanks,
//richard
