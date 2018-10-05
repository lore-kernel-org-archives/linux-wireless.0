Return-Path: <SRS0=2ErG=MR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1427BC65BA7
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 11:05:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD4E4206B2
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 11:05:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="mNeZNPU5";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="OK8DddtW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CD4E4206B2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727974AbeJESDR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 Oct 2018 14:03:17 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:45726 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727581AbeJESDQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Oct 2018 14:03:16 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 7A2CC60A98; Fri,  5 Oct 2018 11:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538737499;
        bh=cWKOgHE1uYM9UcRLkctlaWtVjAnPfb53D58kXgxXvVQ=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=mNeZNPU5bjqEon5r6unbHSbFWmgGoylKd26FyGxxbf0beJMWMUtuFya5QHmBUlTg0
         XqOKZGoZXjKlpqH4smDP5Ln2Wf3deDG/ciDxsG5W9LaPwRfifR451el+25mmHisKqk
         mKBqZzb6/AtQlKdLstkkXwrazSuI/afgDs/B8X58=
Received: from potku.adurom.net (88-114-240-52.elisa-laajakaista.fi [88.114.240.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1B1846079C;
        Fri,  5 Oct 2018 11:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538737499;
        bh=cWKOgHE1uYM9UcRLkctlaWtVjAnPfb53D58kXgxXvVQ=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=OK8DddtWOo6WNJvDodOchdgSp0nudcXpJw7amM/DO32JOvQ3M7cTEZwWCPZV+i46c
         QUwh4IdcOuYktg6GXCnPUTU1eC+6EfCPuxHmpADBOSR2oQVpc87Y9M3dm6lbExNLv1
         S/qgF0FP9h9bXiTbrdZtZXzNM7MX3Jbo2S7I6UDQ=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 1B1846079C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 01/13] qtnfmac: do not track STA states in driver
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20181005101114.3013-2-sergey.matyukevich.os@quantenna.com>
References: <20181005101114.3013-2-sergey.matyukevich.os@quantenna.com>
To:     Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181005110459.7A2CC60A98@smtp.codeaurora.org>
Date:   Fri,  5 Oct 2018 11:04:59 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com> wrote:

> Remove STA connection states tracking from driver.
> Leave it wireless core on host and to firmware.
> 
> Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>

13 patches applied to wireless-drivers-next.git, thanks.

263ee96b77a7 qtnfmac: do not track STA states in driver
d5f693bc4bb9 qtnfmac: generate local disconnect event in disconnect callback
92246b126ebf qtnfmac: request userspace to do OBSS scanning if FW can not
75001bbc0765 qtnfmac: do not initialize per-MAC data multiple times
c6ed298ffe09 qtnfmac: cleanup and unify command error handling
aaa981406f4f qtnfmac: do not cancel scan in disconnect callback
d5657b709e2a qtnfmac: pass sgi rate info flag to wireless core
ab1c64a1d349 qtnfmac: inform wireless core about supported extended capabilities
35da3fe63b86 qtnfmac: drop error reports for out-of-bounds key indexes
6d85930f2653 qtnfmac: add support for scan flush
2525f188f7fd qtnfmac: add support for scan dwell time configuration
8804ea9e15a3 qtnfmac: drop redundant data copy in control path
e1c02eb16a9c qtnfmac: implement dump_station support for STA mode

-- 
https://patchwork.kernel.org/patch/10627791/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

