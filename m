Return-Path: <SRS0=f1+T=PQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AFE9C43387
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Jan 2019 16:54:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 456F32087F
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Jan 2019 16:54:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="U+q1joqg";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="AKm8OBRc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728211AbfAHQyx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 8 Jan 2019 11:54:53 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:36062 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727484AbfAHQyx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Jan 2019 11:54:53 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 7F6A260A0A; Tue,  8 Jan 2019 16:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1546966492;
        bh=RDNecznZI+LRVTFE6ZV/T1JjEhlmXD47Prxujn+FWWk=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=U+q1joqg+yVfUh5JOo88JMnDnQp2pJvCTRvCCOINcv1wYA9NPis/o/B97XRC0uI9/
         RKKhnpUhDOaR2GSO81VPz1zWvGDpCXTR4a1aMx1s4UONK2EeW/UmwERPnYYwfNSvDu
         ObtV/u8W6m4PZdz+TtHi1ibgHzchBrQf9CRLesNk=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C03EF6050D;
        Tue,  8 Jan 2019 16:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1546966491;
        bh=RDNecznZI+LRVTFE6ZV/T1JjEhlmXD47Prxujn+FWWk=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=AKm8OBRcfrUj1DuFOHU/6BbODyv4u9l3I442TOUMlYwaj2mcCrrTwe+Rc05jTD/8q
         vjuUuV+vOuUmbxXc8C/q3UMpNzWuFA9enhTDvt1oowOOuQtTtvSKK165PvO0I/jka1
         atm161Pevc/FOaMEQlhuS17csi6gkSTXFGWbAytA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C03EF6050D
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Siva Rebbagondla <siva8118@gmail.com>
Cc:     linux-wireless@vger.kernel.org, prameela.j04cs@gmail.com,
        rishikesh.basu@redpinesignals.com,
        siva.rebbagondla@redpinesignals.com
Subject: Re: [v4] rsi: add support for hardware scan offload
References: <1545902778-20205-1-git-send-email-siva8118@gmail.com>
Date:   Tue, 08 Jan 2019 18:54:47 +0200
In-Reply-To: <1545902778-20205-1-git-send-email-siva8118@gmail.com> (Siva
        Rebbagondla's message of "Thu, 27 Dec 2018 14:56:18 +0530")
Message-ID: <87muobqeco.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Siva Rebbagondla <siva8118@gmail.com> writes:

> From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
>
> With the current approach of scanning, roaming delays are observed.
> Firmware has support for back ground scanning. To get this advantage,
> mac80211 hardware scan is implemented, which decides type of scan to
> do based on connected state.
>
> When station is in not connected, driver returns with special value 1
> to trigger software scan in mac80211. In case of connected state,
> background scan will be triggered.
>
> Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
> Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
> ---
> changes in v4: renamed return value in hw_scan from "-EPERM" -> "1" [Jberg] 
> changes in v3: replaced rsi_prepare_probe_request() with ieee80211_probereq_get() [Kvalo]
> changes in v2: none

This depends on:

e9da68ddea60 mac80211: allow hardware scan to fall back to software

But that's in w-d-next now so this is safe to be apply.

-- 
Kalle Valo
