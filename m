Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27F9CEB64DD
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Jul 2023 06:35:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231228AbjGTGfK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 20 Jul 2023 02:35:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231229AbjGTGes (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Jul 2023 02:34:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D62EA2710;
        Wed, 19 Jul 2023 23:33:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BFF7761262;
        Thu, 20 Jul 2023 06:32:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91891C433C8;
        Thu, 20 Jul 2023 06:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689834743;
        bh=kV6JsnExwwo1YJnGmJAUSTP40/eUKQgcHZroq4jZ6GQ=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Ef+VO3MInVwf2uh9WHAYjdWAB5DaACntxp1J5W3OkvBT0GyYkZLJhmpOtSOyQPYPP
         h24qjhk4fimcCHe/lQf0EajAZZlS+LHwLKqOL9vKioLroAfqS2vOjQRuTZKOUVffBn
         cSIYCBuxY2IfoVcHO1wbjO4i28jkOO7vRwIiBDtH1M5oP6YrrNvgr+1zvJtNFvZqHp
         EFrTB5w78SUu0RKQCRgPW36j2B+W29SpoAAWhohDCotNlaVt/kzkeWpjctKUaSPWFQ
         XXW6cnm7Htyc2ZiQJqTev6Fu5r4PfuxqnJYGde0WfgamXBzCwUH/t4vg7L32xFYBZS
         AjukCEIsn1zbg==
From:   Kalle Valo <kvalo@kernel.org>
To:     Minjie Du <duminjie@vivo.com>
Cc:     Gregory Greenman <gregory.greenman@intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-wireless@vger.kernel.org (open list:INTEL WIRELESS WIFI LINK
        (iwlwifi)), linux-kernel@vger.kernel.org (open list),
        opensource.kernel@vivo.com
Subject: Re: [PATCH v1] drivers: mvm: remove duplicate assignments
References: <20230705063421.9827-1-duminjie@vivo.com>
Date:   Thu, 20 Jul 2023 09:32:20 +0300
In-Reply-To: <20230705063421.9827-1-duminjie@vivo.com> (Minjie Du's message of
        "Wed, 5 Jul 2023 14:34:21 +0800")
Message-ID: <87wmyv3xfv.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Minjie Du <duminjie@vivo.com> writes:

> make link_sta->agg.max_amsdu_len avoid double assignment.
>
> Signed-off-by: Minjie Du <duminjie@vivo.com>
> ---
>  drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c | 1 -
>  1 file changed, 1 deletion(-)

The title should be:

wifi: iwlwifi: mvm: remove duplicate assignments

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
