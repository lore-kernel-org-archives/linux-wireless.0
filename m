Return-Path: <SRS0=opxv=OW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DB99C65BAE
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Dec 2018 14:20:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5FEA620851
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Dec 2018 14:20:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="fviD7+HS";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="kl4Nq+Nt"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5FEA620851
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728613AbeLMOU1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 13 Dec 2018 09:20:27 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:33290 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728138AbeLMOU1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Dec 2018 09:20:27 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 3D8C86013C; Thu, 13 Dec 2018 14:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544710826;
        bh=dardyHtUnSbNzobrYVDHbM7LQLMawGZfoq6UV2QAJfA=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=fviD7+HSHrK6sbeXBHrrUSMoYnjWr9vTh575iIjm/zbNk3zzSYVvnK2YPewQRgshi
         5SNeRIDGM2THVKAK8PIU6YC6mwntVgcRPdjdCVgxRpqX4FyvHLvZ1BTqRa/Yh5AvTW
         2xPnO0fmFw/QgMTwYLpYru3upqNHmWBzbipDaM8k=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 34A2F6013C;
        Thu, 13 Dec 2018 14:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544710825;
        bh=dardyHtUnSbNzobrYVDHbM7LQLMawGZfoq6UV2QAJfA=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=kl4Nq+NtVs1xwGjVvKbhLKg8icy1CTk/0j+PVnfxr461snV37CMtfj5aZIz1w4f9a
         utQBaD+rrUtT2XW6eNkALAE1Zuv5ZmV2r/x3Ux9bcVySgV2UgqnSzsGytd+tKGRZQv
         Vpq1OQd5WzH5z6/qRt58Dkec7AEdzIkwM2Es9yqQ=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 34A2F6013C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mt76: fix potential NULL pointer dereference in
 mt76_stop_tx_queues
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <98cf4a8f8a7f7840803b91b7c9078d8b61febee9.1542384797.git.lorenzo.bianconi@redhat.com>
References: <98cf4a8f8a7f7840803b91b7c9078d8b61febee9.1542384797.git.lorenzo.bianconi@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     nbd@nbd.name, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181213142026.3D8C86013C@smtp.codeaurora.org>
Date:   Thu, 13 Dec 2018 14:20:26 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:

> Starting from mac80211 commit adf8ed01e4fd ("mac80211: add an optional
> TXQ for other PS-buffered frames") and commit 0eeb2b674f05 ("mac80211:
> add an option for station management TXQ") a new per-sta queue has been
> introduced for bufferable management frames.
> sta->txq[IEEE80211_NUM_TIDS] is initialized just if the driver reports
> the following hw flags:
> - IEEE80211_HW_STA_MMPDU_TXQ
> - IEEE80211_HW_BUFF_MMPDU_TXQ
> This can produce a NULL pointer dereference in mt76_stop_tx_queues
> since mt76 iterates on all available sta tx queues assuming they are
> initialized by mac80211. This issue has been spotted analyzing the code
> (it has not triggered any crash yet)
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

Patch applied to wireless-drivers.git, thanks.

7c250f4612ae mt76: fix potential NULL pointer dereference in mt76_stop_tx_queues

-- 
https://patchwork.kernel.org/patch/10686507/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

