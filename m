Return-Path: <SRS0=B82j=6O=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1734C8300C
	for <linux-wireless@archiver.kernel.org>; Thu, 30 Apr 2020 08:47:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A08920787
	for <linux-wireless@archiver.kernel.org>; Thu, 30 Apr 2020 08:47:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbgD3Ir1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 30 Apr 2020 04:47:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726531AbgD3Ir1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 30 Apr 2020 04:47:27 -0400
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07CC7C035494;
        Thu, 30 Apr 2020 01:47:27 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: andrzej.p)
        with ESMTPSA id 5D09E2A0A59
Subject: Re: [PATCH 2/6] thermal: core: delete thermal_notify_framework()
To:     Zhang Rui <rui.zhang@intel.com>, linux-pm@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org, daniel.lezcano@linaro.org,
        b.zolnierkie@samsung.com, luca@coelho.fi
References: <20200430063229.6182-1-rui.zhang@intel.com>
 <20200430063229.6182-3-rui.zhang@intel.com>
From:   Andrzej Pietrasiewicz <andrzej.p@collabora.com>
Message-ID: <f6d7dcae-ccf1-eee1-2ac1-eaa8472e2f87@collabora.com>
Date:   Thu, 30 Apr 2020 10:47:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200430063229.6182-3-rui.zhang@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Rui,

Thanks for the series,

W dniu 30.04.2020 o 08:32, Zhang Rui pisze:
> Delete thermal_notify_framework() as there is no user of it.
> 
> Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> ---
>   drivers/thermal/thermal_core.c | 18 ------------------
>   include/linux/thermal.h        |  4 ----
>   2 files changed, 22 deletions(-)
> 

git grep thermal_notify_framework
Documentation/driver-api/thermal/sysfs-api.rst:4.3. thermal_notify_framework

Should the documentation be still documenting a non-existent function?

BTW, get_tz_trend() is only used in drivers/thermal/step_wise.c,
but is still exported with EXPORT_SYMBOL(). Probably does not need to
be exported anymore.

Andrzej
