Return-Path: <SRS0=Y8Bh=OQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DF49C64EB1
	for <linux-wireless@archiver.kernel.org>; Fri,  7 Dec 2018 10:50:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C7FF820892
	for <linux-wireless@archiver.kernel.org>; Fri,  7 Dec 2018 10:50:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="jScLPRqa";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Z3FhPpEC"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C7FF820892
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726006AbeLGKub (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 7 Dec 2018 05:50:31 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:49108 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbeLGKub (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Dec 2018 05:50:31 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 98C706028B; Fri,  7 Dec 2018 10:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544179830;
        bh=rMx44yr0SP+tYnnWgH/Gy6E6SRSRkoyL6ReIlTQSqdk=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=jScLPRqa4vFgtgfT+JLJaH1W40W3p5i1OC76Vi4N9/UywasK/L65hJo8VoHGBf8Ay
         oDDX5dG1+u1xutnr8mnX16EvEPLbasQDQFDAaZfcWj/1wqoD4mPNhYoBBTtVT5F1cW
         8rF6F/HL00R0gIFbGtUXXmgWY8unHoWYVBlq1KYI=
Received: from x230.qca.qualcomm.com (37-33-92-201.bb.dnainternet.fi [37.33.92.201])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 235F6601B4;
        Fri,  7 Dec 2018 10:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544179829;
        bh=rMx44yr0SP+tYnnWgH/Gy6E6SRSRkoyL6ReIlTQSqdk=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Z3FhPpECoh6ZlsiSfQ1oFQgl4+BiIz6+cgCWKxHa1u9TK2HgRnauqZC8/L4jo/J5v
         WxS1I1+D+oeG1wzw2hlyVWHcd5ddbA7jvsF+mbnpGUn1+c8j92/K8I4Lpc6eP2Y6PP
         hJmd/aQlJTfFfJySTLgQShphn97tdau2DQbpKkkQ=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 235F6601B4
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Brian Norris <briannorris@chromium.org>
Cc:     <linux-kernel@vger.kernel.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxinming820@gmail.com>,
        linux-wireless@vger.kernel.org
Subject: Re: [RFC PATCH v2 2/2] mwifiex: add NL80211_STA_INFO_RX_BITRATE support
References: <20181207001249.165477-1-briannorris@chromium.org>
        <20181207001249.165477-2-briannorris@chromium.org>
Date:   Fri, 07 Dec 2018 12:50:25 +0200
In-Reply-To: <20181207001249.165477-2-briannorris@chromium.org> (Brian
        Norris's message of "Thu, 6 Dec 2018 16:12:49 -0800")
Message-ID: <87ftv9ehla.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Brian Norris <briannorris@chromium.org> writes:

> Comparing the existing TX_BITRATE parsing code (in
> mwifiex_parse_htinfo()) with the RX bitrate histograms in debugfs.c, it
> appears that the rxpd_rate and rxpd_htinfo fields have the same format.
> At least, they give reasonable results when I parse them this way.
>
> So this patch adds support for RX_BITRATE to our station info dump.
>
> Along the way, I add legacy bitrate parsing into the same function,
> using the debugfs code (mwifiex_histogram_read() and
> mwifiex_adjust_data_rate()) as reference.
>
> Additionally, to satisfy the requirements of
> NL80211_STA_INFO_RX_BITRATE, I skip logging the bitrate of multicast
> packets. This shouldn't add a lot of overhead to the RX path, as there
> are already several similar 802.3 header checks in this same codepath.
> We can also bias the branch behavior to favor unicast, as that's the
> common performance-sensitive case.
>
> I'd consider this support somewhat experimental, as I have zero
> documentation from Marvell. But the existing driver code gives me good
> reason to think this is correct.
>
> I've tested this on a few different 802.11{a,b,g,n,ac} networks, and the
> reported bitrates look good to me.
>
> Signed-off-by: Brian Norris <briannorris@chromium.org>
> ---
> RFC: I'd appreciate it if someone from Marvell could double check my work
> here.

BTW, if we don't hear anything from Marvell I'm going to apply these
anyway.

-- 
Kalle Valo
