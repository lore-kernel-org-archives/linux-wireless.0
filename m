Return-Path: <SRS0=0pM2=P6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC183C282C5
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 10:50:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B24021019
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 10:50:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727698AbfAVKu3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 22 Jan 2019 05:50:29 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:49508 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727048AbfAVKu2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Jan 2019 05:50:28 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gltdO-0007Gx-UG; Tue, 22 Jan 2019 12:50:23 +0200
Message-ID: <10feddc47ffc96ca5cd93651731b8adfdbe16c31.camel@coelho.fi>
From:   Luca Coelho <luca@coelho.fi>
To:     Arnd Bergmann <arnd@arndb.de>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc:     Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sara Sharon <sara.sharon@intel.com>,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Lior Cohen <lior2.cohen@intel.com>,
        Shaul Triebitz <shaul.triebitz@intel.com>,
        Haim Dreyfuss <haim.dreyfuss@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 22 Jan 2019 12:50:20 +0200
In-Reply-To: <20181210203945.2147135-1-arnd@arndb.de>
References: <20181210203945.2147135-1-arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] iwlwifi: fix false-positive maybe-uninitialized warning
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, 2018-12-10 at 21:39 +0100, Arnd Bergmann wrote:
> With CONFIG_NO_AUTO_INLINE, we run into a silly warning when
> gcc fails to remember that n_profiles is constant across
> the function call to iwl_mvm_sar_set_profile:
> 
> drivers/net/wireless/intel/iwlwifi/mvm/fw.c: In function
> 'iwl_mvm_sar_get_ewrd_table':
> drivers/net/wireless/intel/iwlwifi/mvm/fw.c:746:9: error: 'ret' may
> be used uninitialized in this function [-Werror=maybe-uninitialized]
> 
> Marking that function 'inline' avoids the warning.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---

Thanks! This has been applied in our internal tree and will reach the
mainline following our normal upstreaming process.

--
Cheers,
Luca.

