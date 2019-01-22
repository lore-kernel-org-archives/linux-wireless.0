Return-Path: <SRS0=0pM2=P6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47F11C282C4
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 10:16:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 15FAA2085A
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 10:16:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727539AbfAVKP5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 22 Jan 2019 05:15:57 -0500
Received: from mga17.intel.com ([192.55.52.151]:62344 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726231AbfAVKP5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Jan 2019 05:15:57 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Jan 2019 02:15:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,505,1539673200"; 
   d="scan'208";a="110060785"
Received: from cmicsa-mobl1.ti.intel.com ([10.252.18.12])
  by orsmga006.jf.intel.com with ESMTP; 22 Jan 2019 02:15:04 -0800
Message-ID: <ef50896ee3ecc895c72a9fbdedca65ac6433fef2.camel@intel.com>
Subject: Re: [for next][PATCH] iwlwifi: Fix unmet dependency error for
 IWLWIFI_LEDS
From:   Luciano Coelho <luciano.coelho@intel.com>
To:     Sinan Kaya <okaya@kernel.org>, linux-next@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:INTEL WIRELESS WIFI LINK (iwlwifi)" 
        <linux-wireless@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Date:   Tue, 22 Jan 2019 12:15:03 +0200
In-Reply-To: <20190121233102.13705-1-okaya@kernel.org>
References: <20190121233102.13705-1-okaya@kernel.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, 2019-01-21 at 23:31 +0000, Sinan Kaya wrote:
> There is an unresolved dependency as follows:
> 
> IWLWIFI_LEDS selects MAC80211_LEDS.
> MAC80211_LEDS depends on MAC80211.
> 
> It is possible to choose MAC80211_LEDS (y) but not choose MAC80211
> (n)
> 
> WARNING: unmet direct dependencies detected for MAC80211_LEDS
>   Depends on [n]: NET [=y] && WIRELESS [=y] && MAC80211 [=n] &&
> LEDS_CLASS [=y]
>   Selected by [y]:
>   - IWLWIFI_LEDS [=y] && NETDEVICES [=y] && WLAN [=y] &&
> WLAN_VENDOR_INTEL [=y] && IWLWIFI [=y] && (LEDS_CLASS [=y]=y ||
> LEDS_CLASS [=y]=IWLWIFI [=y])
> 
> Move the MAC80211 dependency into IWLWIFI_LEDS so that we avoid this
> configuration.
> 
> Signed-off-by: Sinan Kaya <okaya@kernel.org>
> ---

Thanks for your patch! But we already have another patch to fix this
issued queued for 5.0-rc4 (it's currently in wireless-drivers.git):

https://patchwork.kernel.org/patch/10762079/

--
Cheers,
Luca.

