Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87433C433EF
	for <linux-wireless@archiver.kernel.org>; Tue, 21 Sep 2021 15:09:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67CF160F13
	for <linux-wireless@archiver.kernel.org>; Tue, 21 Sep 2021 15:09:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233846AbhIUPLF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 21 Sep 2021 11:11:05 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:59523 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231196AbhIUPLA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Sep 2021 11:11:00 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1632236972; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=XuO14sWu2eKuF9+hkzN8+ZZ99ruPd5qBqWA5gJBm1qY=;
 b=LC2VYBvNcTMclZU74xkHkPnSOx3L4XIy4510QhEBbI3h81CeQmE6LwTs+hVYldyG/KLEJkj4
 mJFQRxaqgVe9NkBy9442IBGxsewqlodr1ixkwzOSG6wPdqxo6NKVc+4LFAMdK6acNHdUL+9I
 LZCJ8NKMsQhkMN5jcojWshDgKz8=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 6149f588e0f78151d65b3aad (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 21 Sep 2021 15:08:56
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 1EDFFC43616; Tue, 21 Sep 2021 15:08:56 +0000 (UTC)
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 98500C4360D;
        Tue, 21 Sep 2021 15:08:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 98500C4360D
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 01/11] wilc1000: move 'deinit_lock' lock init/destroy
 inside module probe
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210916164902.74629-2-ajay.kathat@microchip.com>
References: <20210916164902.74629-2-ajay.kathat@microchip.com>
To:     <Ajay.Kathat@microchip.com>
Cc:     <linux-wireless@vger.kernel.org>, <Claudiu.Beznea@microchip.com>,
        <Ajay.Kathat@microchip.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-Id: <20210921150856.1EDFFC43616@smtp.codeaurora.org>
Date:   Tue, 21 Sep 2021 15:08:56 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

<Ajay.Kathat@microchip.com> wrote:

> From: Ajay Singh <ajay.kathat@microchip.com>
> 
> Move initialization & deinitialization of 'deinit_lock' mutex lock inside
> wlan_init_locks() & wlan_deinit_locks() API's respectively alongside other
> locks. After the movement, the client count variable(client_count) which is
> used for lock init/deinit is removed.
> 
> Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>

11 patches applied to wireless-drivers-next.git, thanks.

c8e2036ee90b wilc1000: move 'deinit_lock' lock init/destroy inside module probe
3c719fed0f3a wilc1000: fix possible memory leak in cfg_scan_result()
0ec5408cd448 wilc1000: add new WID to pass wake_enable information to firmware
5bb9de8bcb18 wilc1000: configure registers to handle chip wakeup sequence
1bcc0879c963 wilc1000: add reset/terminate/repeat command support for SPI bus
c2dcb4766bcb wilc1000: handle read failure issue for clockless registers
aa3fda4fcf63 wilc1000: ignore clockless registers status response for SPI
29f7393e02ac wilc1000: invoke chip reset register before firmware download
cd50248de35b wilc1000: add 'initialized' flag check before adding an element to TX queue
301cfbab09fd wilc1000: use correct write command sequence in wilc_spi_sync_ext()
bb6a0d5404aa wilc1000: increase config packets response wait timeout limit

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210916164902.74629-2-ajay.kathat@microchip.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

