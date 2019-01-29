Return-Path: <SRS0=Fojl=QF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6B5EC282C7
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 12:30:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 86A312083B
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 12:30:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="o/IbU2XZ";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="OxVP4TIy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729090AbfA2Map (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 29 Jan 2019 07:30:45 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:40064 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727939AbfA2Mao (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Jan 2019 07:30:44 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 57CA660A9B; Tue, 29 Jan 2019 12:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548765043;
        bh=OsjO99YHTE2428Lj87Z2a+D+W03gg2ylYEBbHf6nhyo=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=o/IbU2XZU5JI0mxdUOf44ij4YMbDTG1a1UNGPCB+vzW3cv4o7AJqqwxQJ72rdY2u5
         xBQ2mg+p00t9UnLqmjt8cx7SpUDjHs6f/cjbNFY5hdleldHhNTYkQI0kdzi20jk2Xx
         htRlMab4pW9VSdtvyPREdQXqp6H3yUHxCcVT51tk=
Received: from purkki.adurom.net (purkki.adurom.net [80.68.90.206])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4AB2460AA2;
        Tue, 29 Jan 2019 12:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548765032;
        bh=OsjO99YHTE2428Lj87Z2a+D+W03gg2ylYEBbHf6nhyo=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=OxVP4TIyXwxDMRTFXUQjeZ7B5wogz74Jprq4yjlH/FYgF+9Cl9bJ4QWicSv9SRCBi
         eu4rWsu2xDl7kBgFwFBval+8+VZAqgQhgflpH4Wh30ylT7q1N5SNzqWxJQc6BHBSa0
         h88BW2g/pRQW87Utxj6kzoOyrc019yWHsqBctWV4=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 4AB2460AA2
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Joe Perches <joe@perches.com>, linux-wireless@vger.kernel.org,
        Randy Oostdyk <linux-kernel@oostdyk.com>,
        Tomislav =?utf-8?Q?Po=C5=BEega?= <pozega.tomislav@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Felix Fietkau <nbd@nbd.name>, Mathias Kresin <dev@kresin.me>
Subject: Re: [PATCH v2 1/3] rt2x00: use ratelimited variants dev_warn/dev_err
References: <1545318971-28351-1-git-send-email-sgruszka@redhat.com>
        <b0b97478f9b2b9b12ad7bc04a1eb0af3bad6c5f3.camel@perches.com>
        <20181221115742.GA30351@redhat.com>
Date:   Tue, 29 Jan 2019 14:30:28 +0200
In-Reply-To: <20181221115742.GA30351@redhat.com> (Stanislaw Gruszka's message
        of "Fri, 21 Dec 2018 12:57:43 +0100")
Message-ID: <874l9rtzmj.fsf@purkki.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Stanislaw Gruszka <sgruszka@redhat.com> writes:

> On Fri, Dec 21, 2018 at 03:19:31AM -0800, Joe Perches wrote:
>> On Thu, 2018-12-20 at 16:16 +0100, Stanislaw Gruszka wrote:
>> > As reported by Randy we can overwhelm logs on some USB error conditions.
>> > To avoid that use dev_warn_ratelimited() and dev_err_ratelimitd().
>> > 
>> > Reported-and-tested-by: Randy Oostdyk <linux-kernel@oostdyk.com>
>> > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
>> > ---
>> >  drivers/net/wireless/ralink/rt2x00/rt2x00.h | 9 +++++++--
>> >  1 file changed, 7 insertions(+), 2 deletions(-)
>> > 
>> > diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00.h b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
>> []
>> > @@ -65,14 +65,19 @@
>> >  /* Utility printing macros
>> >   * rt2x00_probe_err is for messages when rt2x00_dev is uninitialized
>> >   */
>> > +#define wiphy_err_ratelimited(wiphy, format, args...)		\
>> > +	dev_err_ratelimited(&(wiphy)->dev, format, ##args)
>> > +#define wiphy_warn_ratelimited(wiphy, format, args...)		\
>> > +	dev_warn_ratelimited(&(wiphy)->dev, format, ##args)
>> > +
>> 
>> These should probably be generic in include/net/cfg80211.h
>
> Since there are no other users I do not see reason for that. 
> Those macros can be easily move, if other users would show up.

I agree with Joe, these should be in cfg80211.h.

-- 
Kalle Valo
