Return-Path: <SRS0=opxv=OW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60D74C65BAE
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Dec 2018 13:46:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 22F2320851
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Dec 2018 13:46:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="cZp2b6aG";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="bTcB0pFQ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 22F2320851
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729505AbeLMNqG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 13 Dec 2018 08:46:06 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:35648 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729382AbeLMNqG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Dec 2018 08:46:06 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 5F09D60312; Thu, 13 Dec 2018 13:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544708765;
        bh=+9x8nYsIljzDhcX2bvK8EJ6kF7zopScnbO+qkwYMB6w=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=cZp2b6aGHe3KAq6ljvsTNXDH1KCP73JmQbQauZIgT7UaJfy1eAa1e9ZdzOeVfCbWG
         0tfQMn8IMo4cp8461TAMMuJQh6J8kFsplEd9oNo6y9ak+/P7ZTZguSOj6tq+XNma6T
         bwYRESJuQKfQlO84xMatB8c3M5I5YgNkIdIdqOX0=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id EEAEE60237;
        Thu, 13 Dec 2018 13:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544708764;
        bh=+9x8nYsIljzDhcX2bvK8EJ6kF7zopScnbO+qkwYMB6w=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=bTcB0pFQ1Mc1H9L+/6viyBYTodLRXxdszwUUvdiBczFT6WygROEg5WlJP8kmn8V1W
         Jy+OPbDP12zBeMFvDvzdq8YcpOaf5n0boGdnMpd7S/jil/jYGbM/Psj18WbJKm9WWn
         UR9dVepMhNh4fid9bvbHLztEfRJ+VDptiZKx4k9g=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org EEAEE60237
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH wireless-drivers] brcmfmac: fix roamoff=1 modparam
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20181204182905.32267-1-stijn@linux-ipv6.be>
References: <20181204182905.32267-1-stijn@linux-ipv6.be>
To:     Stijn Tintel <stijn@linux-ipv6.be>
Cc:     linux-wireless@vger.kernel.org, arend.vanspriel@broadcom.com,
        Stable <stable@vger.kernel.org>,
        Jonas Gorski <jonas.gorski@gmail.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181213134605.5F09D60312@smtp.codeaurora.org>
Date:   Thu, 13 Dec 2018 13:46:05 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Stijn Tintel <stijn@linux-ipv6.be> wrote:

> When the update_connect_param callback is set, nl80211 expects the flag
> WIPHY_FLAG_SUPPORTS_FW_ROAM to be set as well. However, this flag is
> only set when modparam roamoff=0, while the callback is set
> unconditionally. Since commit 7f9a3e150ec7 this causes a warning in
> wiphy_register, which breaks brcmfmac.
> 
> Disable the update_connect_param callback when roamoff=0 to fix this.
> 
> Fixes: 7f9a3e150ec7 ("nl80211: Update ERP info using NL80211_CMD_UPDATE_CONNECT_PARAMS")
> Cc: Stable <stable@vger.kernel.org> # 4.19+
> Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
> Signed-off-by: Stijn Tintel <stijn@linux-ipv6.be>

Should this go to 4.20? Arend?

-- 
https://patchwork.kernel.org/patch/10712383/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

