Return-Path: <SRS0=P1q9=MZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A1F5C28CF8
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Oct 2018 17:18:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 01ED72064A
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Oct 2018 17:18:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="JXRf2wEh";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="jOh8vVs5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 01ED72064A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbeJNA4c (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 13 Oct 2018 20:56:32 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:43782 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726893AbeJNA4c (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 13 Oct 2018 20:56:32 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id D65A360C62; Sat, 13 Oct 2018 17:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539451114;
        bh=myOFkS25XY92C+leDIdtIo1RiQxhdPvBfgoqQy7v7yk=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=JXRf2wEhtjn6IBTnFmEJIe86e36Yn5EKZX+qN9Uj8wyQ6qP0OkmT/NV3Ro5scGhkp
         zHO5w1NBG/zsmWeDc8+e0JSS4sSBTMLHgTiBVwvsaVl8Pmxf39eAokjeKOzcQHw3wz
         XpyuyJAu+Df75I8rtUcqE5Z7TFWANHnsjnp8WRxw=
Received: from potku.adurom.net (88-114-240-228.elisa-laajakaista.fi [88.114.240.228])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C72F860A98;
        Sat, 13 Oct 2018 17:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539451114;
        bh=myOFkS25XY92C+leDIdtIo1RiQxhdPvBfgoqQy7v7yk=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=jOh8vVs5mKtrOB1aaiFqC6MyhaSqJuPulokX1FKRAPZiewo0JxftRcXG0LsbAMBHn
         Et3qHefmvD79oxhexzbjKSYPkttWsvDHxmew0O9WywF9fkKmH9Q4KOqeS1mZhGo+CY
         FqxKOwVmzLogzWvmss4eBv/aaEn7lsTZ9tMu9Na0=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C72F860A98
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3] ath10k: support NET_DETECT WoWLAN feature
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1534402113-14337-1-git-send-email-wgong@codeaurora.org>
References: <1534402113-14337-1-git-send-email-wgong@codeaurora.org>
To:     Wen Gong <wgong@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181013171834.D65A360C62@smtp.codeaurora.org>
Date:   Sat, 13 Oct 2018 17:18:34 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Wen Gong <wgong@codeaurora.org> wrote:

> For WoWLAN support it is expected to support wake up based on discovery of
> one or more known SSIDs. This is the WIPHY_WOWLAN_NET_DETECT feature,
> which shows up as an NL80211 feature flag.
> 
> This shows up in 'iw phy' as:
> 
> WoWLAN support:
> * wake up on network detection, up to 16 match sets
> 
> And it can be enabled with command:
> 
> iw phy0 wowlan enable net-detect interval 5000 delay 30 freqs 2412 matches ssid foo
> 
> Firmware will do scan by the configured parameters after suspend and
> wakeup if it found matched SSIDs. Tested with QCA6174 hw3.0 with
> firmware WLAN.RM.4.4.1-00110-QCARMSWPZ-1.
> 
> Signed-off-by: Wen Gong <wgong@codeaurora.org>
> [kvalo@codeaurora.org: fix lots of endian bugs, whitespace, commit log and style cleanup]
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

ce834e280f2f ath10k: support NET_DETECT WoWLAN feature

-- 
https://patchwork.kernel.org/patch/10567005/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

