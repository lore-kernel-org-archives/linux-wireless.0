Return-Path: <SRS0=jiki=YB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42782C10F14
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Oct 2019 19:25:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A73C206C0
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Oct 2019 19:25:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="mzQbJBbI";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="gJR4eyoR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730165AbfJHTY6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 8 Oct 2019 15:24:58 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:45308 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726439AbfJHTY6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Oct 2019 15:24:58 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 40B806030E; Tue,  8 Oct 2019 19:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1570562697;
        bh=5FMVmAW3Ja52+ywmDhHmqFHA5eUXnJXG1gM4BXqlJyw=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=mzQbJBbIQz17z6gxE6gmUE+EEuZfrYY0Rs/LXxPo8bRRIJbBMOQa4uCzhVjAGWySO
         AcoWFUONxjPNOgQzXCCtZq4TWjfpKCRQ5Aat39DXWRXnro1S7J9MpkigmSeOz0VUji
         8f21v5DOpB2ExouEWh0ebaZRYRwuOPQnBcowTibw=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id BAF9B6070D;
        Tue,  8 Oct 2019 19:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1570562696;
        bh=5FMVmAW3Ja52+ywmDhHmqFHA5eUXnJXG1gM4BXqlJyw=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=gJR4eyoRJXE5er+uuWDdyX1HPfvoINV9QUBimRTsqF8zU8pUCE7DSyYazEZKcpsZQ
         iyfJwp8ZZw7OK//wBYQubqg35ziyewOp4M3QY8ggTwgQlDI7078DKJQUuEpEgx14W0
         mim9qJBcC8oOfolXN+qH76jifCzcc8ZDbDpku/dY=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org BAF9B6070D
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Denis Efremov <efremov@linux.com>
Subject: Re: [PATCH 1/2] Revert "rsi: fix potential null dereference in rsi_probe()"
References: <20191004144422.13003-1-johan@kernel.org>
        <87a7aes2oh.fsf@codeaurora.org> <87pnj7grii.fsf@tynnyri.adurom.net>
        <20191008164439.GA27819@localhost>
Date:   Tue, 08 Oct 2019 22:24:51 +0300
In-Reply-To: <20191008164439.GA27819@localhost> (Johan Hovold's message of
        "Tue, 8 Oct 2019 18:44:39 +0200")
Message-ID: <875zkz6nwc.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Johan Hovold <johan@kernel.org> writes:

> On Tue, Oct 08, 2019 at 06:56:37PM +0300, Kalle Valo wrote:
>> Kalle Valo <kvalo@codeaurora.org> writes:
>> 
>> > Johan Hovold <johan@kernel.org> writes:
>> >
>> >> This reverts commit f170d44bc4ec2feae5f6206980e7ae7fbf0432a0.
>> >>
>> >> USB core will never call a USB-driver probe function with a NULL
>> >> device-id pointer.
>> >>
>> >> Reverting before removing the existing checks in order to document this
>> >> and prevent the offending commit from being "autoselected" for stable.
>> >>
>> >> Signed-off-by: Johan Hovold <johan@kernel.org>
>> >
>> > I'll queue these two to v5.4.
>> 
>> Actually I'll take that back. Commit f170d44bc4ec is in -next so I have
>> to also queue these to -next.
>
> That's right. I'm assuming you don't rebase your branches, otherwise
> just dropping the offending patch might of course be an option instead
> of the revert.

Yeah, I don't rebase my trees so we have to do a revert.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
