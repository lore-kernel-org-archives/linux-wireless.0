Return-Path: <SRS0=EqeY=MQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE3F3C64EBC
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 09:54:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B31A02098A
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 09:54:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="biJlksrc";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="AvCOeO+6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B31A02098A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727500AbeJDQqW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Oct 2018 12:46:22 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:47420 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727369AbeJDQqW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Oct 2018 12:46:22 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 42C0860C86; Thu,  4 Oct 2018 09:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538646833;
        bh=alRNw4uLZ2UGbKsmh6rMlj4pOiV6ckDyOJdfMdDVDG8=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=biJlksrcOVxU3bYgiwM4gi82mtDuxL5p7QbKz9Vcm1dJyGpU468qkO9nHqh6f0wPT
         tTMx0/0EuQcSYRtcP0R+P2I3aXwC8/tq7SQZYjGkpHydfWAWeIwkjGz8FORRS8DCER
         NY5KP9pu+EQMn4xP2aLHNIAEkujQuBxY2GJ3UD5w=
Received: from x230.qca.qualcomm.com (85-76-114-39-nat.elisa-mobile.fi [85.76.114.39])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 50C3F60C6A;
        Thu,  4 Oct 2018 09:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538646832;
        bh=alRNw4uLZ2UGbKsmh6rMlj4pOiV6ckDyOJdfMdDVDG8=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=AvCOeO+6M8fnp5zb42FbrWz+GgkOsx5QXw+7JjPmk1U/8lo3P66kLMVBwkA0dXViE
         x/Rof3CCg8390/H+Zqwo7UX7Ohfn+3LiUY52tTlMov4wQ8InHO3LHuThARo9UOquR5
         Q09fEyYYtaQD4OQ/03THco1BgWRO0T08JaqYMHBI=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 50C3F60C6A
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Vladis Dronov <vdronov@redhat.com>
Cc:     David Miller <davem@davemloft.net>, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, netdev@vger.kernel.org,
        syzkaller@googlegroups.com, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] net: arp, ipv6: handle special case of tap device
References: <20180926093018.6646-1-vdronov@redhat.com>
        <20180929.114023.1370133506922372520.davem@davemloft.net>
        <1615981257.17285278.1538393552487.JavaMail.zimbra@redhat.com>
        <20181002.222540.1948082296309410659.davem@davemloft.net>
        <2058134821.17788321.1538573112620.JavaMail.zimbra@redhat.com>
Date:   Thu, 04 Oct 2018 12:53:46 +0300
In-Reply-To: <2058134821.17788321.1538573112620.JavaMail.zimbra@redhat.com>
        (Vladis Dronov's message of "Wed, 3 Oct 2018 09:25:12 -0400 (EDT)")
Message-ID: <87muru2g2d.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Vladis Dronov <vdronov@redhat.com> writes:

>> From: "David Miller" <davem@davemloft.net>
>> Sent: Wednesday, October 3, 2018 7:25:40 AM
>>
>> > Probably, this functionality is already used by some userspace, so I
>> > believe, I cannot just remove TUNSETLINK ioctl.
>> 
>> Who uses it, how do they use it, and what do they sanely expect about
>> the link layer header properties of a tap device which has had ->type
>> changed?
>
> Honestly, I have no idea. I was working on a syzkaller bug report and
> found that the reason for that bug was TUNSETLINK ioctl.
>
> This ioctl was introduced 13 years ago with ff4cc3ac93e1d and it says:
>
>> For use with
>> wireless and other networking types it should be possible to set the
>> ARP type via an ioctl.
>
> , that's all. Let me try to prepare a patch that sets dev->addr_len and
> dev->broadcast according to dev->type. I would probably need an advise
> what other fields must be adjusted too.
>
> Otherwise, we can just to remove the TUNSETLINK ioctl.

Let's add linux-wireless in case someone there knows about the ioctl.

-- 
Kalle Valo
