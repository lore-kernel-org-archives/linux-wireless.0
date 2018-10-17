Return-Path: <SRS0=hbYo=M5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C797C04EB9
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Oct 2018 06:44:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE40F2151D
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Oct 2018 06:44:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DE40F2151D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727249AbeJQOi4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Oct 2018 10:38:56 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:59006 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727080AbeJQOi4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Oct 2018 10:38:56 -0400
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gCfZU-0003n9-Uk; Wed, 17 Oct 2018 09:44:45 +0300
Message-ID: <9f63350e8f853254adeb5eb6c280ec3cfe99409e.camel@coelho.fi>
From:   Luca Coelho <luca@coelho.fi>
To:     =?ISO-8859-1?Q?R=E9my_Gr=FCnblatt?= <remy@grunblatt.org>,
        linux-wireless@vger.kernel.org
Cc:     linuxwifi@intel.com
Date:   Wed, 17 Oct 2018 09:44:43 +0300
In-Reply-To: <b403d919-57dd-aa2a-24f2-09d857cada5b@grunblatt.org>
References: <b403d919-57dd-aa2a-24f2-09d857cada5b@grunblatt.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.1-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] Minor corrections of comments in the iwlwifi mvm rate
 scaling source
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2018-09-13 at 13:07 +0200, Rémy Grünblatt wrote:
> Hi,
> 
> I believe some comments in the rate scaling source of the iwlwifi mvm
> are wrong, as we have #define RATE_MCS_SGI_POS  13 and #define
> RATE_MCS_SGI_MSK  (1 << RATE_MCS_SGI_POS)

Hi Remy,

Sorry for the delay, your patch was not correctly formatted and since
this is a minor fix in a comment, it slipped through my fingers.

I have made a different patch to fix this, changing the hex values for
the tables instead, because in the example we say this is about SGI, so
I just set the SGI bit:

- * rate[0] 0x400D019 VHT | ANT: AB BW: 80Mhz MCS: 9 NSS: 2 SGI
- * rate[1] 0x400D019 VHT | ANT: AB BW: 80Mhz MCS: 9 NSS: 2 SGI
- * rate[2] 0x400D018 VHT | ANT: AB BW: 80Mhz MCS: 8 NSS: 2 SGI
- * rate[3] 0x400D018 VHT | ANT: AB BW: 80Mhz MCS: 8 NSS: 2 SGI
- * rate[4] 0x400D017 VHT | ANT: AB BW: 80Mhz MCS: 7 NSS: 2 SGI
- * rate[5] 0x400D017 VHT | ANT: AB BW: 80Mhz MCS: 7 NSS: 2 SGI
+ * rate[0] 0x400F019 VHT | ANT: AB BW: 80Mhz MCS: 9 NSS: 2 SGI
+ * rate[1] 0x400F019 VHT | ANT: AB BW: 80Mhz MCS: 9 NSS: 2 SGI
+ * rate[2] 0x400F018 VHT | ANT: AB BW: 80Mhz MCS: 8 NSS: 2 SGI
+ * rate[3] 0x400F018 VHT | ANT: AB BW: 80Mhz MCS: 8 NSS: 2 SGI
+ * rate[4] 0x400F017 VHT | ANT: AB BW: 80Mhz MCS: 7 NSS: 2 SGI
+ * rate[5] 0x400F017 VHT | ANT: AB BW: 80Mhz MCS: 7 NSS: 2 SGI


This is now queued in our internal tree and will reach the mainline at
some point, following our normal process.

Thanks for reporting.

--
Cheers,
Luca.

