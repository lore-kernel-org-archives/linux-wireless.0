Return-Path: <SRS0=9n1M=OL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26F36C04EB8
	for <linux-wireless@archiver.kernel.org>; Sun,  2 Dec 2018 15:08:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D2D9A20881
	for <linux-wireless@archiver.kernel.org>; Sun,  2 Dec 2018 15:08:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="QgiJpkaI"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D2D9A20881
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725885AbeLBPIY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 2 Dec 2018 10:08:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:48400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725875AbeLBPIY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 2 Dec 2018 10:08:24 -0500
Received: from localhost (unknown [213.57.143.11])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CCD1420851;
        Sun,  2 Dec 2018 15:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1543763302;
        bh=8dccp8SDTqmfpt7SPeq08f5n7SMi9PeePY6FCC7rBWY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QgiJpkaICZwVWYwYepYUb7FHiAC3qLsHrQOR4ug6otdpOGj4PEeQeCz6iJz7rVVkB
         cg+p12VGBY8gz4GKFyxEhFZuA7UtiYd2fKtbKxz5br2LcWDoSewtJvjdue6yTh+fE3
         SvNn2jLTvKb0rEwMR9rXT5VQ0PbTTj4Bt7rdJqdA=
Date:   Sun, 2 Dec 2018 10:08:13 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Dietmar May <dmay@intellastar.com>
Cc:     stable@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: wlcore update breaks on 4.9 and 4.4 kernel branches
Message-ID: <20181202150813.GG221015@sasha-vm>
References: <43ee432a-c6ab-e23c-616c-b626a5fb4637@intellastar.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <43ee432a-c6ab-e23c-616c-b626a5fb4637@intellastar.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Nov 29, 2018 at 05:56:31PM -0500, Dietmar May wrote:
>I've run into some problems which appear due to (a) recent patch(es) 
>on the wlcore wifi driver.
>
>4.4.160 - commit 3fdd34643ffc378b5924941fad40352c04610294
>4.9.131 - commit afeeecc764436f31d4447575bb9007732333818c
>
>Earlier versions (4.9.130 and 4.4.159 - tested back to 4.4.49) do not 
>exhibit this problem. It is still present in 4.9.141.
>
>master as of 4.20.0-rc4 does not exhibit this problem.
>
>Basically, during client association when in AP mode (running 
>hostapd), handshake may or may not complete following a noticeable 
>delay. If successful, then the driver fails consistently in 
>warn_slowpath_null during disassociation. If unsuccessful, the wifi 
>client attempts multiple times, sometimes failing repeatedly. I've had 
>clients unable to connect for 3-5 minutes during testing, with the 
>syslog filled with dozens of backtraces. syslog details are below.
>
>I'm working on an embedded device with a TI 3352 ARM processor and a 
>murata wl1271 module in sdio mode. We're running a fully patched 
>ubuntu 18.04 ARM build, with a kernel built from kernel.org's 
>stable/linux repo <https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-4.9.y&id=afeeecc764436f31d4447575bb9007732333818c>. 
>Relevant parts of the kernel config are included below.
>
>The commit message states:
>
>>/I've only seen this few times with the runtime PM patches enabled 
>>so this one is probably not needed before that. This seems to work 
>>currently based on the current PM implementation timer. Let's apply 
>>this separately though in case others are hitting this issue./
>We're not doing anything explicit with power management. The device is 
>an IoT edge gateway with battery backup, normally running on wall 
>power. The battery is currently used solely to shut down the system 
>cleanly to avoid filesystem corruption.
>
>The device tree is configured to keep power in suspend; but the device 
>should never suspend, so in our case, there is no need to call 
>wl1271_ps_elp_wakeup() or wl1271_ps_elp_sleep(), as occurs in the 
>patch.

Given that this patch went in through AUTOSEL, I've queued up a revert
of it (sorry for the trouble!).

I'll link this mail in the revert message. If anyone feels that this
patch should be in any of the LTS trees then either reply to this thread
or start a new one on stable@vger.kernel.org.

--
Thanks,
Sasha
