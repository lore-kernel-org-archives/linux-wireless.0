Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E602C83027
	for <linux-wireless@archiver.kernel.org>; Thu,  2 Sep 2021 16:40:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A219610CC
	for <linux-wireless@archiver.kernel.org>; Thu,  2 Sep 2021 16:40:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346446AbhIBQlX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 2 Sep 2021 12:41:23 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:32575 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346432AbhIBQlS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Sep 2021 12:41:18 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1630600819; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=b5QlStr7auelzeh/1q3A9R4DYZnn0Ni6Hgl51XDk6OA=;
 b=RbqkzvA1Wyr98vGR2M2vLCboF6Y9n5hZUVK9OuCCzw3xAF5418uY/alFwpTeqva12GwkyLE2
 fJrgznF5fArLMQ8V+cpGQjFRIXYimwBqk8FUfcYw912vvPp5G9mlUd+5RW2hZTzbiWgnYnEg
 RVCkahFm2G//eUD4tH4VQuzcT0w=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 6130fe666fc2cf7ad9c25d5a (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 02 Sep 2021 16:40:06
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 22EFBC4360C; Thu,  2 Sep 2021 16:40:06 +0000 (UTC)
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id CBA9BC4338F;
        Thu,  2 Sep 2021 16:40:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org CBA9BC4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: iwlwifi: bump FW API to 66 for AX devices
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210901101412.300012-1-luca@coelho.fi>
References: <20210901101412.300012-1-luca@coelho.fi>
To:     Luca Coelho <luca@coelho.fi>
Cc:     luca@coelho.fi, linux-wireless@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-Id: <20210902164006.22EFBC4360C@smtp.codeaurora.org>
Date:   Thu,  2 Sep 2021 16:40:06 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Luca Coelho <luca@coelho.fi> wrote:

> From: Luca Coelho <luciano.coelho@intel.com>
> 
> Start supporting API version 66 for AX devices.
> 
> Th iwlwifi FW API is frozen every 6 weeks, so we need to bump the
> newest version number that the driver supports accordingly.  In this
> specific case, support for new HW will only be possible with the new
> FW version.  This change still keeps backwards compatibility with
> older FW API versions for existing devices.
> 
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>

Patch applied to wireless-drivers.git, thanks.

851c8e761c39 iwlwifi: bump FW API to 66 for AX devices

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210901101412.300012-1-luca@coelho.fi/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

