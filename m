Return-Path: <SRS0=MtVb=O3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3D61C43387
	for <linux-wireless@archiver.kernel.org>; Tue, 18 Dec 2018 16:17:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8068121841
	for <linux-wireless@archiver.kernel.org>; Tue, 18 Dec 2018 16:17:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Hs3NC+ju";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="kermxCWN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727100AbeLRQRn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 18 Dec 2018 11:17:43 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:49088 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726789AbeLRQRn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Dec 2018 11:17:43 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 4EA7B60159; Tue, 18 Dec 2018 16:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545149862;
        bh=UQqGHLqmRJ4dxLhYfDDijJsVIWUFUBbv6biMe0zyvjw=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Hs3NC+juum8mOBiUUiHN4laNVG6A2b/6KEAmhAoPFi1u6RWOYRDgRTNC/IjVXHqyB
         anRHEVI3BcdBMF5i6pwEExwA9+tAVIMBfYLBDM9UOlvgafr1xhVRypuF7yiZWw+HfV
         aWLxao3LVq6qN6tQsuRxZ9q6hkKTLfmvA2xryUMY=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9C1F8605A5;
        Tue, 18 Dec 2018 16:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545149858;
        bh=UQqGHLqmRJ4dxLhYfDDijJsVIWUFUBbv6biMe0zyvjw=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=kermxCWNyExzoeaLbI0ReChcSTQDJfTDlCK67L2JrXMe92604hhnAhwBGYQuhnbsi
         Gghd+y7Eo8YqV2HoilnHZUBknxiYkZJprefPRqKSpz8FyhmZmawgqUJ5bSuVNkmzqy
         FTKaMUbDiBrgbdWCaUUQChxubn+ifo1e1134+pc8=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 9C1F8605A5
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Luca Coelho <luca@coelho.fi>
Cc:     linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Subject: Re: [PATCH 06/18] [BUGFIXiwlwifi: make MVM and DVM depend on MAC80211
References: <20181214202945.32375-1-luca@coelho.fi>
        <20181214202945.32375-7-luca@coelho.fi>
Date:   Tue, 18 Dec 2018 18:17:35 +0200
In-Reply-To: <20181214202945.32375-7-luca@coelho.fi> (Luca Coelho's message of
        "Fri, 14 Dec 2018 22:29:33 +0200")
Message-ID: <87y38mx10g.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Luca Coelho <luca@coelho.fi> writes:

> From: Luca Coelho <luciano.coelho@intel.com>
>
> It's not the iwlwifi module that depends on mac80211, but iwlmvm and
> iwldvm.  To reflect this better, make MVM and DVM Kconfig options
> depend on MAC80211 instead.
>
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>

The subject is broken, stray "[BUGFIX". I think you are offline already
so I can fix it myself but I need to rebase the patches. I assume that's
ok unless someone from Intel objects :)

-- 
Kalle Valo
