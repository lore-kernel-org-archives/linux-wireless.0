Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A077ECAAA3
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Aug 2022 08:47:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245240AbiHZIrK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Aug 2022 04:47:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234424AbiHZIrJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Aug 2022 04:47:09 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F22131A39B
        for <linux-wireless@vger.kernel.org>; Fri, 26 Aug 2022 01:47:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=y53TsKjN7ZCORuB0aqtghty/cCrXs0gtBHgq5BVtAFE=;
        t=1661503629; x=1662713229; b=J6EFV3SES5NJYBSPex9B3UkbaMRj4RHMxBdRp7XFJK12lka
        cfAsZ+5M9qPFRdUuflLALmi6G8pO2WisltxoHdijBUgg7Z98BVdfGbcAbAoBu2vRRSE6BGvEz9NTC
        53nY686hcVTt93r6PPQC2cGTyWF3MZqsw0f8krSaIPUkvD1zzCWxXGPD1rPUL5dHI8L70zRtYAB5X
        Jpb/8w3nzYonmLDFic8PskJNI4ULTydma52nK2UGjMEQNu0bJwpu8JdeXCQH1fiL+h/03j7akhRDB
        htCdK0NdtCLUaNHh/y1am84pBezI4FYqoJkMOP9+Y4l0kp3fl3IIxSLwGR6yLK0Q==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1oRUza-000Ad3-2N;
        Fri, 26 Aug 2022 10:47:07 +0200
Message-ID: <27395558c865424f9b20d8b976e650926c9322dd.camel@sipsolutions.net>
Subject: Re: [PATCH 1/2] nl80211: Allow transmitting auth frames with random
 TA
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Veerendranath Jakkam <quic_vjakkam@quicinc.com>
Cc:     linux-wireless@vger.kernel.org
Date:   Fri, 26 Aug 2022 10:47:05 +0200
In-Reply-To: <20220708165212.2069149-1-quic_vjakkam@quicinc.com>
References: <20220708165212.2069149-1-quic_vjakkam@quicinc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-1.fc36) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

This patch doesn't apply now, sorry I let it linger across a lot of MLO
work.

> - To allow user space to use link address indicated by driver as
>   transmit address for authentication frames triggered by
>   NL80211_CMD_EXTERNAL_AUTH for MLO connection.

Maybe this is already covered by the changes that are actually
responsible for it not applying any more?

You can use the link address now, due to commit 6df2810ac9a9 ("wifi:
cfg80211: Allow MLO TX with link source address").


The PASN privacy thing seems something that would be desirable also for
mac80211, how would you think it would work there? Also for hwsim
testing I guess :)


>  	if (!ether_addr_equal(mgmt->sa, wdev_address(wdev))) {
> +		/* Allow random TA to be used with authentication frames if the
> +		 * driver has indicated support for this. Otherwise, only allow
> +		 * the local address to be used.
> +		 */
> +		if (ieee80211_is_auth(mgmt->frame_control) &&
> +		    wiphy_ext_feature_isset(
> +			   &rdev->wiphy,
> +			   NL80211_EXT_FEATURE_AUTH_TX_RANDOM_TA))
> +			goto out_tx;

Could use else/if instead of goto? Not sure that's better though :)

johannes
