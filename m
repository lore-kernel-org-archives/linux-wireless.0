Return-Path: <SRS0=euQo=MJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A2A9C43382
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 04:33:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C1FC521566
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 04:33:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="bNuESIyJ";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="bNuESIyJ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C1FC521566
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726687AbeI0KtV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Sep 2018 06:49:21 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:33710 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726598AbeI0KtV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Sep 2018 06:49:21 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id CF8D6607F4; Thu, 27 Sep 2018 04:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538022786;
        bh=0ZJGCSYdj5hCqJyT1at0PZI0aI8Kd2xn+MbTIoBGRNU=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=bNuESIyJ3oBKh7Ojpy+fBkX+HiGLGyNJLv6uQhhXQOUQg1UCpbtkn77jkyHoNjiNI
         Bk6erQGMCHh3HcyFa8dyxYujtvOa8y7FgXqH3G3395Fn806YvWEg6vWfCXVkV14WFT
         koieAmBJIgr2E+atE+dKi/G6IBV7RHCuKAHLuXyo=
Received: from potku.adurom.net (88-114-240-52.elisa-laajakaista.fi [88.114.240.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6A021607F4;
        Thu, 27 Sep 2018 04:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538022786;
        bh=0ZJGCSYdj5hCqJyT1at0PZI0aI8Kd2xn+MbTIoBGRNU=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=bNuESIyJ3oBKh7Ojpy+fBkX+HiGLGyNJLv6uQhhXQOUQg1UCpbtkn77jkyHoNjiNI
         Bk6erQGMCHh3HcyFa8dyxYujtvOa8y7FgXqH3G3395Fn806YvWEg6vWfCXVkV14WFT
         koieAmBJIgr2E+atE+dKi/G6IBV7RHCuKAHLuXyo=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6A021607F4
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Cody Schuffelen <schuffelen@google.com>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, kernel-team@android.com
Subject: Re: [PATCH net-next v2] wireless-drivers: rtnetlink wifi simulation device
References: <20180926194324.71290-1-schuffelen@google.com>
Date:   Thu, 27 Sep 2018 07:33:01 +0300
In-Reply-To: <20180926194324.71290-1-schuffelen@google.com> (Cody Schuffelen's
        message of "Wed, 26 Sep 2018 12:43:24 -0700")
Message-ID: <875zyrr24i.fsf@kamboji.qca.qualcomm.com>
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
> responses to nl80211 to satisfy a standard network manager. If
> necessary, it can also be set up one step removed from an existing
> network device, such as through a vlan/80211Q or macvlan connection to
> not disrupt the existing network interface.
>
> To use it to wrap a bare ethernet connection:
>
> ip link set eth0 down
> ip link set eth0 name buried_eth0
> ip link set buried_eth0 up
> ip link add link buried_eth0 name wlan0 type virt_wifi
>
> eth0 is renamed to buried_eth0 to avoid a network manager trying to
> manage it, as the original network link will become unusuable and only
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
> desired by some userspace process but is not available. Future work can
> also include exporting the wireless control plane to userspace, so the
> device can configure the behavior of the simulated wireless network
> itself.
>
> This is distinct from other testing efforts such as mac80211_hwsim by
> being a cfg80211 device instead of mac80211 device, allowing straight
> pass-through on the data plane instead of forcing packaging of ethernet
> data into mac80211 frames.
>
> Signed-off-by: A. Cody Schuffelen <schuffelen@google.com>
> Acked-by: Alistair Strachan <astrachan@google.com>
> Acked-by: Greg Hartman <ghartman@google.com>
> Signed-off-by: Cody Schuffelen <schuffelen@google.com>
> ---
> Original change: https://lore.kernel.org/lkml/5b5b8e09.1c69fb81.c693c.0acd@mx.google.com/
> First review: https://lore.kernel.org/lkml/1535460343.5895.56.camel@sipsolutions.net/
>
> Thanks for the detailed review! I believe I've addressed all comments.

BTW, this will likely go through mac80211-next, so don't add net-next to
the subject to avoid Dave getting confused. But no need to resend
because of this.

-- 
Kalle Valo
