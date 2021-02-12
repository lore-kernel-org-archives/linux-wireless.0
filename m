Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD354C433E0
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Feb 2021 08:42:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71ECC64DEA
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Feb 2021 08:42:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230206AbhBLIm6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Feb 2021 03:42:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230143AbhBLImz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Feb 2021 03:42:55 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF357C061574;
        Fri, 12 Feb 2021 00:42:14 -0800 (PST)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lAU1i-001m8q-P3; Fri, 12 Feb 2021 09:42:10 +0100
Message-ID: <991c55472dd1f2be79438fbc11f2aa6d96ce5075.camel@sipsolutions.net>
Subject: Re: [PATCH 2/3] mac80211: Add support to trigger sta disconnect on
 hardware restart
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Youghandhar Chintala <youghand@codeaurora.org>
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kuabhs@chromium.org,
        dianders@chromium.org, briannorris@chromium.org,
        pillair@codeaurora.org
Date:   Fri, 12 Feb 2021 09:42:09 +0100
In-Reply-To: <20201215172352.5311-1-youghand@codeaurora.org>
References: <20201215172352.5311-1-youghand@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2020-12-15 at 22:53 +0530, Youghandhar Chintala wrote:
> The right fix would be to pull the entire data path into the host

> +++ b/net/mac80211/ieee80211_i.h
> @@ -748,6 +748,8 @@ struct ieee80211_if_mesh {
>   *	back to wireless media and to the local net stack.
>   * @IEEE80211_SDATA_DISCONNECT_RESUME: Disconnect after resume.
>   * @IEEE80211_SDATA_IN_DRIVER: indicates interface was added to driver
> + * @IEEE80211_SDATA_DISCONNECT_HW_RESTART: Disconnect after hardware restart
> + *	recovery

How did you model this on IEEE80211_SDATA_DISCONNECT_RESUME, but than
didn't check how that's actually used?

Please change it so that the two models are the same. You really don't
need the wiphy flag.

johannes

