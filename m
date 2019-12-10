Return-Path: <SRS0=GVYC=2A=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B56EEC43603
	for <linux-wireless@archiver.kernel.org>; Tue, 10 Dec 2019 12:07:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 85250207FF
	for <linux-wireless@archiver.kernel.org>; Tue, 10 Dec 2019 12:07:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="LQ0NzK42";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="OM1W6M7g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727281AbfLJMH5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 10 Dec 2019 07:07:57 -0500
Received: from a27-21.smtp-out.us-west-2.amazonses.com ([54.240.27.21]:35030
        "EHLO a27-21.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727231AbfLJMH5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Dec 2019 07:07:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1575979676;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:Message-ID:MIME-Version:Content-Type;
        bh=Wq/q6Mlz+H8rCXxs1TLWDgDwCdwKysHMIE+9Z7bHhXo=;
        b=LQ0NzK4251p/vm/eghRKnev7g1/+mcgUeHCuwwGZm9rpNL5LU5HNIz0+8fVIEhem
        KfQ5SOmjrnowhgY4MT/567B8byZyNlo51ELIkANRCx0DdKCxFiSzP5lX8l6y+y+SDkf
        8gahJiHHZvPpYfb28l80svOg3bMNE354CylhMUd0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1575979676;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:Message-ID:MIME-Version:Content-Type:Feedback-ID;
        bh=Wq/q6Mlz+H8rCXxs1TLWDgDwCdwKysHMIE+9Z7bHhXo=;
        b=OM1W6M7g30FlLCMp1Nq6SYPaA/ToP1Ds95i0USpFvV4EwIychn7haBbM3/4kUN64
        +fCt6/WXVivnzKo6jbR/NvRlYoF43R8zCshqW2RHKNCjXKfSMYXLwcNdVAkmnUpK6fA
        ItUou4/lLHPsvy3SxEWcidsMJozH9p+P25uJOPtI=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6EDD0C447AA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Markus Theil <markus.theil@tu-ilmenau.de>
Cc:     nbd@nbd.name, linux-wireless@vger.kernel.org,
        lorenzo.bianconi@redhat.com, Stanislaw Gruszka <stf_xl@wp.pl>
Subject: Re: [PATCH v2] mt76: use AC specific reorder timeout
References: <20191210114949.4516-1-markus.theil@tu-ilmenau.de>
Date:   Tue, 10 Dec 2019 12:07:56 +0000
In-Reply-To: <20191210114949.4516-1-markus.theil@tu-ilmenau.de> (Markus
        Theil's message of "Tue, 10 Dec 2019 12:49:49 +0100")
Message-ID: <0101016eefb572c3-6de6eb28-6829-4c64-a773-c800e7680032-000000@us-west-2.amazonses.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-SES-Outgoing: 2019.12.10-54.240.27.21
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Markus Theil <markus.theil@tu-ilmenau.de> writes:

> Before this patch, mt76 handled rx traffic for all TIDs  equally,
> when released from reorder buffer early. This patch uses an AC specific
> reorder timeout, in order to release partial aggregated frames for voice
> or video ACs earlier. For example, ath10k also uses AC specific reorder
> timeouts (reported by firmware in that case).
>
> v2: use static const mapping arrays
>
> Signed-off-by: Markus Theil <markus.theil@tu-ilmenau.de>
> ---

Please add the changelog here, after the "---" line.

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#changelog_missing

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
