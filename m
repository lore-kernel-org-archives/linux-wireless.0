Return-Path: <SRS0=pQzZ=MS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ABDDC65C31
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Oct 2018 11:52:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A6922087D
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Oct 2018 11:52:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Gfb810dc";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Gfb810dc"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3A6922087D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727768AbeJFSz3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 6 Oct 2018 14:55:29 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:42616 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726919AbeJFSz3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 6 Oct 2018 14:55:29 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id CD9986021C; Sat,  6 Oct 2018 11:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538826751;
        bh=MCFDA02KMy2t7nbezQouY64mdhbsYX6o+dFGLYImCts=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Gfb810dc9d9HyGRQWfen4lS1OSsY/bcwaXOmSOXwbOChD2cAUZIIj7lYzf1RlNVxH
         CEjQiOGUFus55KKRmooBruJVm67WY9gU24+Ap675ppcu5hVyrGvWaBkV/NJe7u9Mg+
         4BXZOaMbaZMc5H0msxMAXa2n2b6Hy8PEhfOhb580=
Received: from potku.adurom.net (88-114-240-52.elisa-laajakaista.fi [88.114.240.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E88696021C;
        Sat,  6 Oct 2018 11:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538826751;
        bh=MCFDA02KMy2t7nbezQouY64mdhbsYX6o+dFGLYImCts=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Gfb810dc9d9HyGRQWfen4lS1OSsY/bcwaXOmSOXwbOChD2cAUZIIj7lYzf1RlNVxH
         CEjQiOGUFus55KKRmooBruJVm67WY9gU24+Ap675ppcu5hVyrGvWaBkV/NJe7u9Mg+
         4BXZOaMbaZMc5H0msxMAXa2n2b6Hy8PEhfOhb580=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E88696021C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Cody Schuffelen <schuffelen@google.com>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, kernel-team@android.com
Subject: Re: [PATCH net-next v3] wireless-drivers: rtnetlink wifi simulation device
References: <20181004195906.201895-1-schuffelen@google.com>
Date:   Sat, 06 Oct 2018 14:52:26 +0300
In-Reply-To: <20181004195906.201895-1-schuffelen@google.com> (Cody
        Schuffelen's message of "Thu, 4 Oct 2018 12:59:06 -0700")
Message-ID: <8736tjgumd.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Cody Schuffelen <schuffelen@google.com> writes:

> This device takes over an existing network device and produces a
> new one that appears like a wireless connection, returning enough canned
> responses to nl80211 to satisfy a standard connection manager. If
> necessary, it can also be set up one step removed from an existing
> network device, such as through a vlan/80211Q or macvlan connection to
> not disrupt the existing network interface.
>
> To use it to wrap a bare ethernet connection:
>
> ip link add link eth0 name wlan0 type virt_wifi
>
> You may have to rename or otherwise hide the eth0 from your connection
> manager, as the original network link will become unusuable and only
> the wireless wrapper will be functional. This can also be combined with
> vlan or macvlan links on top of eth0 to share the network between
> distinct links, but that requires support outside the machine for
> accepting vlan-tagged packets or packets from multiple MAC addresses.
>
> This is being used for Google's Remote Android Virtual Device project,
> which runs Android devices in virtual machines. The standard network
> interfaces provided inside the virtual machines are all ethernet.
> However, Android is not interested in ethernet devices and would rather
> connect to a wireless interface. This patch allows the virtual machine
> guest to treat one of its network connections as wireless rather than
> ethernet, satisfying Android's network connection requirements.
>
> We believe this is a generally useful driver for simulating wireless
> network connections in other environments where a wireless connection is
> desired by some userspace process but is not available.
>
> This is distinct from other testing efforts such as mac80211_hwsim by
> being a cfg80211 device instead of mac80211 device, allowing straight
> pass-through on the data plane instead of forcing packaging of ethernet
> data into mac80211 frames.
>
> Signed-off-by: A. Cody Schuffelen <schuffelen@google.com>
> Acked-by: Alistair Strachan <astrachan@google.com>
> Acked-by: Greg Hartman <ghartman@google.com>
> ---
> First version: https://lkml.org/lkml/2018/7/27/947
> First review: https://lore.kernel.org/lkml/1535460343.5895.56.camel@sipsolutions.net/
> Second version: https://lore.kernel.org/lkml/20180926194324.71290-1-schuffelen@google.com/
> Second review: https://www.lkml.org/lkml/2018/9/27/228
> Second review: https://www.lkml.org/lkml/2018/9/27/229
> Second review: https://www.lkml.org/lkml/2018/9/27/669
>
> Thanks for all the comments on v2! I believe I've addressed all of them
> here. I've also added changes to react better to the netdev going down,
> canceling ongoing scans and rejecting wifi network connection requests.
>
> I wasn't completely clear on whether I should change the title (net-next
> to mac80211-next) so I left it as is for v3 to try to keep the patchwork
> series together.

I already said in v2 that you should not mark this for net-next as this
goes to mac80211-next (if it gets accepted), now you are just
unnecessarily confusing people.

-- 
Kalle Valo
