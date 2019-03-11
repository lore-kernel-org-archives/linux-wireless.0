Return-Path: <SRS0=FsXk=RO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 495D6C4360F
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 14:03:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 16E3720657
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 14:03:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Mm28mot+";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="dp0pSymG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727652AbfCKODr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Mar 2019 10:03:47 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:41300 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727469AbfCKODr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Mar 2019 10:03:47 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id F25EB60DAD; Mon, 11 Mar 2019 14:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1552313026;
        bh=rz3hpzhYgGZX+8d6angQRiM2LfoJqX1KFo32hfT+/ho=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Mm28mot+AnDLGjzpKCpXpJhjEF0veKfewlvbznM+Qd0Q0lap1JvORB0mp9xc55SEw
         wTRbTCbY1a8olx5fMINSpPNYxxtlm5SnGQ+u86y9c+GBt/t2D//FyEt41JL7jMpQ30
         SqArGQtVZSlCSkOLnHihKCx/+dZjJuz8+Bsu8DBs=
Received: from x230.qca.qualcomm.com (87-95-203-65.bb.dnainternet.fi [87.95.203.65])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B693260CED;
        Mon, 11 Mar 2019 14:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1552313023;
        bh=rz3hpzhYgGZX+8d6angQRiM2LfoJqX1KFo32hfT+/ho=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=dp0pSymG8EmWjTv0abskzeHgYzU+W61G9wg0vpDjEUmrrGQvtV/79aqrivAOENej6
         KoBOlxtdNrVDuQSA5eA9DMRGvgiMApXcL4E6xfyF7uLtEJDEun2x7N/IK+fBaS5DM9
         dALHH7z+0rP9opgHZg+DPBSavSPmB261T/cFWu1M=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B693260CED
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     ga58taw@mytum.de
Cc:     Julius Niedworok <julius.n@gmx.net>,
        linux-wireless@vger.kernel.org, david@redhat.com, nc@net.in.tum.de,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v2] mac80211: debugfs option to force TX status frames
References: <e20962001ee10a0f90f8e2f1f8baafcf3b70e9dd.camel@sipsolutions.net>
        <20190306200206.60916-1-julius.n@gmx.net>
        <87k1hazo6r.fsf@purkki.adurom.net>
        <20190307193045.a7awwn6mycloccq5@mission-control>
Date:   Mon, 11 Mar 2019 16:03:38 +0200
In-Reply-To: <20190307193045.a7awwn6mycloccq5@mission-control>
        (ga58taw@mytum.de's message of "Thu, 7 Mar 2019 20:30:45 +0100")
Message-ID: <87h8c98q4l.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

ga58taw@mytum.de writes:

> On Thu, Mar 07, 2019 at 05:42:04PM +0200, Kalle Valo wrote:
>> > +   len = scnprintf(buf, sizeof(buf), "%d\n", (int)local->force_tx_status);
>>
>> I wonder about the cast, is it guaranteed that a bool is always of the
>> same size as an int?
>
> Why is this a problem? If a bool is smaller than an int, the compiler
> emits code that will prepend the value of force_tx_status with zeros.

Let's say that a bool is a byte and int is four bytes. If you use "%d" I
would guess that in that case scnprintf() writes 4 bytes, meaning that 3
bytes will be overwriting either padding or some other field in the
struct.

But I'm no compiler expert so I'm not going to argue about this anymore.
I just wanted to point out that that the cast looks dangerous and I
would not do it.

-- 
Kalle Valo
