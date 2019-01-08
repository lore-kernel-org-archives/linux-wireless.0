Return-Path: <SRS0=f1+T=PQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03D5AC43387
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Jan 2019 17:20:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CBD35206A3
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Jan 2019 17:20:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="KELjYcJ+";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="fMYKBcPd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728604AbfAHRUB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 8 Jan 2019 12:20:01 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:38568 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728398AbfAHRUB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Jan 2019 12:20:01 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 2891260240; Tue,  8 Jan 2019 17:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1546968000;
        bh=Z/fsdlkSrWXWnipD4yOxb0GHEOwi50y5i55k2OwF9e0=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=KELjYcJ+P4bzqEmFI7Du9uLrLRdcdmgWqq+JSvP3jI0qmBo7MyTH/NGelsHgt21fj
         KDxFOfSq9F5OzXz+oR1EFHNbWboqXqFpumMhKAHZ5+4ViNqSkBlit0Fd2vFkoKMIT1
         Ueb+swDlpBslQRQo28zaJfGIrGeh6Z/vSEPiZYd4=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E5360601D1;
        Tue,  8 Jan 2019 17:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1546967999;
        bh=Z/fsdlkSrWXWnipD4yOxb0GHEOwi50y5i55k2OwF9e0=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=fMYKBcPdrlQvtDvQLK9CwcJZ0DW0BIsslZJTwAM9eHZchFpswXQgupFLOOx9y1k5Z
         eUsN7nuSoTaBPt7Pl+qTcn+tx/Z0a8MJkHg8OZiNRQlwUXTrQJGqCMBSZwqx9uJq3m
         3YsuGFUFHI5UzRl7gbMXBARqeI247RuKWkr7AcEw=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E5360601D1
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     "Garnayak\, Sarada Prasanna" <sarada.prasanna.garnayak@intel.com>
Cc:     "Berg\, Johannes" <johannes.berg@intel.com>,
        Jouni Malinen <j@w1.fi>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org
Subject: Re: [RFC PATCH v1] cfg80211/nl80211: add support for AID assignment by driver : https://patchwork.kernel.org/patch/10726899/
References: <751CDD2CADF63344AAEAE35AACE235DCCC3BCD@BGSMSX106.gar.corp.intel.com>
Date:   Tue, 08 Jan 2019 19:19:55 +0200
In-Reply-To: <751CDD2CADF63344AAEAE35AACE235DCCC3BCD@BGSMSX106.gar.corp.intel.com>
        (Sarada Prasanna Garnayak's message of "Sat, 5 Jan 2019 13:35:08
        +0000")
Message-ID: <87a7kbqd6s.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

+ linux-wireless

"Garnayak, Sarada Prasanna" <sarada.prasanna.garnayak@intel.com> writes:

> Thank you so much for reviewing my RFC patch and here I would like to
> address the big concerns/comments about this RFC patch like=20
>
> =C3=98 What are the exact use case and potential user of this patch.
>
> =C3=98 How the Hostapd will handle this get aid and free aid.
>
> =C3=98 etc.
>
> In the current implementation in WLAN Stack, the hostapd is assigning
> the AID for a station during association.=20
>
> But we have a few WLAN hardware which is maintaining the AID in the
> WLAN hardware level itself and the firmware checking this AID in the
> hardware level according to that the firmware is taking action on
> station management
>
> like (Station DB management, BA agreement, SMPS and TM management
> frame etc....). For this reason, we need these get_aid/free_aid.=20
>
> Also here I am attaching the Hostapd RFC Patch for the same. PFA
> (hostapd patch, call flow diagram and comments on this kernel patch)
>
> Please review the call flow below:

You made few crucial mistakes:

1. You did not CC linux-wireless.

2. You submitted the message as HTML and our lists automatically filter
   those.

3. You attached a powerpoint file and I would hope that our lists
   automatically filter those as well. At least I'm not going to open
   any random powerpoint/word files I receive via email.

--=20
Kalle Valo
