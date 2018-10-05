Return-Path: <SRS0=2ErG=MR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 127E6C00449
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 06:00:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CAFCB20834
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 06:00:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="VutF82Yf";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="fobbn11v"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CAFCB20834
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727670AbeJEM5m (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 Oct 2018 08:57:42 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:59566 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726979AbeJEM5m (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Oct 2018 08:57:42 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id CA294607A2; Fri,  5 Oct 2018 06:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538719231;
        bh=474H3jlSxufe7PU2oyiGaC4NdtYROAR5gCLVpkM1Qt0=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=VutF82YfsAuwLVFZdoTqeTzL3mjLMHtY1SnTxxTVOwEMnuEfCn+PeVZja6aNPBd8X
         ev856jq03Ql7GoXII7L+tKBd1rm5CCzEi19NuvsGwjujnZ9cljYSUVlWVpyeNGHLNH
         rHUMRPifglYLJAUC9CIWYi6cALKttPGYaVHC6ISs=
Received: from potku.adurom.net (88-114-240-52.elisa-laajakaista.fi [88.114.240.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 05821607A2;
        Fri,  5 Oct 2018 06:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538719231;
        bh=474H3jlSxufe7PU2oyiGaC4NdtYROAR5gCLVpkM1Qt0=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=fobbn11v6xZvTMa6TilnRrys/QSw4fLPr865YBCOwl1I9zSlMaJCweWb1D7rny75u
         Em15Qlhf27i8Rt17ye/KOw8LYMu6T3bl2tW9uCKZZskuS5seYHK7YOF092GtX/2e5X
         CWNrhSGU7sfzOEko/cqGiFDZzmh+Ue0RJz9GrMlk=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 05821607A2
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [RFC 2/2] ath10k: Add QCA vendor command/attr support to
 filterneighbor BSS frames
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1530791512-6915-3-git-send-email-periyasa@codeaurora.org>
References: <1530791512-6915-3-git-send-email-periyasa@codeaurora.org>
To:     Karthikeyan Periyasamy <periyasa@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Karthikeyan Periyasamy <periyasa@codeaurora.org>,
        johannes@sipsolutions.net
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181005060031.CA294607A2@smtp.codeaurora.org>
Date:   Fri,  5 Oct 2018 06:00:31 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Karthikeyan Periyasamy <periyasa@codeaurora.org> wrote:

> Add operations to allow an AP to capture frames from stations that
> are active on the operating channel, but not associated to the current AP.
> Operations include add/delete the filter and get the statistics
> information of the unassociated stations.
> 
> User can able to add/delete two type of filters,
> 	1. BSSID
> 	2. STA MAC address
> 
> BSSID filter achieved by HW through vdev_set_neighbor_rx_param WMI command.
> Local device able to capture all frames of the specified BSS using the above
> WMI command. STA filter achieved by SW through RX addr2 matching with
> unassociated station rhash table list keyed by MAC address. rhash table used
> for efficient search. rhash table can grow/shrink by the add/delete STA
> filter request.
> 
> Hardware tested: QCA9984, QCA4019 and QCA9888
> Firmware tested: 10.4-3.6-xxxxx
> 
> NOTE: Tested with debug firmware
> 
> Signed-off-by: Karthikeyan Periyasamy <periyasa@codeaurora.org>

So I'm not sure what to do with this. A bpf type of filtering system in
mac80211 would be nice but then again we cannot benefit from HW offloading.
Johannes, what do you think?

Here are the full patches:

https://patchwork.kernel.org/patch/10508821/

https://patchwork.kernel.org/patch/10508823/

-- 
https://patchwork.kernel.org/patch/10508823/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

