Return-Path: <SRS0=bi0l=ZN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9A9BC432C3
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Nov 2019 20:15:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9BD452068F
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Nov 2019 20:15:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="l6C0T9oX";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="a9OeBl95"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbfKUUPa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 21 Nov 2019 15:15:30 -0500
Received: from a27-188.smtp-out.us-west-2.amazonses.com ([54.240.27.188]:38162
        "EHLO a27-188.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726554AbfKUUPa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Nov 2019 15:15:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1574367329;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:Message-ID:MIME-Version:Content-Type;
        bh=1HXlq7Mr01PGrt5PiQ2A70tXorZ4xGR30tGnBxlb/Yk=;
        b=l6C0T9oXch0CuvMcG1srk9SzsyntwhZaZL7HsrSirB5Ho9ZAO86mLOIL6HoI1XkG
        F03zJODcrOC2jYyZs6odo86vPV0T5MAXwaoFvgeLS0PEj0z57Opp3X7u7ZAMvEI1EJF
        Z8In2mzdOj/1jlNzxPgBCPMnTkWD9HU1QP2jp5So=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1574367329;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:Message-ID:MIME-Version:Content-Type:Feedback-ID;
        bh=1HXlq7Mr01PGrt5PiQ2A70tXorZ4xGR30tGnBxlb/Yk=;
        b=a9OeBl954f/Uh62LYeFbX9MS7sjSgCWuPUf4KEcCWWruAjjMPtuPQ1qi62IAdYV5
        LrzCxy2F+ARxjc6tEOdwb3NorY1sbEfhASKbgcXxzGAsFTuoLDB0kcgKp3eceGzoh7F
        GbyG14AX5LETwjlbujCuEfCOs42LO2ichihlGvXs=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 48197C447A6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Cc:     "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Mikhail Karpenko <mkarpenko@quantenna.com>
Subject: Re: [PATCH 2/2] qtnfmac: add support for the new revision of QSR10g chip
References: <20191121135324.21715-1-sergey.matyukevich.os@quantenna.com>
        <20191121135324.21715-3-sergey.matyukevich.os@quantenna.com>
Date:   Thu, 21 Nov 2019 20:15:29 +0000
In-Reply-To: <20191121135324.21715-3-sergey.matyukevich.os@quantenna.com>
        (Sergey Matyukevich's message of "Thu, 21 Nov 2019 13:53:35 +0000")
Message-ID: <0101016e8f9afb9b-7e5241a3-3145-45dd-a178-8f4c9d5ff83e-000000@us-west-2.amazonses.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-SES-Outgoing: 2019.11.21-54.240.27.188
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com> writes:

> Add support for the new minor revision of QSR10g chip. Major changes from
> the driver perspective include PCIe data path modifications. Setup is now
> more complicated, but finally more things have been offloaded to hardware.
> As a result, less driver boilerplate operations are needed after Tx/Rx
> descriptors queues have been configured. Besides, restrictions on
> descriptors queue lengths have been relaxed.
>
> Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>

What about the firmware, is that available for this new revision?

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
