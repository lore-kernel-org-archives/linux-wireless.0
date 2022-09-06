Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 764E5ECAAA1
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Sep 2022 09:38:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231837AbiIFJiz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Sep 2022 05:38:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiIFJiy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Sep 2022 05:38:54 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6001F6581F
        for <linux-wireless@vger.kernel.org>; Tue,  6 Sep 2022 02:38:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=vXYcjz+Y/fJe/aUTYeJM0Lp4CR879uqsLpgHFd3UcTM=;
        t=1662457133; x=1663666733; b=AW07vX4Ob6NAwKzbc58kgPxRZ4HwZBqcpnH9bOkj+3MTyM5
        TTl6hBLFkQMnFT5RDwtaXaU3QtWj+8XBnHc926e8MX6JOLitY++9+J919DQUa1I+KpIs4dcg6zh2z
        A+7h0u+DUrbwGAJveySCF1joFqIjWCOohMG6bagNJgtThnMwSh7QfrIdio+8UyrTM/QclQads4Fer
        5dlRTOic3u8M2qzEVBPfoEWs+rKGlAN774zhqG8YLUB6DCtIsOQhv5hi566xzJqZb/EPzVXSQbCnd
        UrI/KvQt2lrO9T7Kfpgmn8TXFD4rMMXZ8zkq8Egdj1HsJFfJL7LMG9XgixiVKB7w==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1oVV2h-009MX7-0i;
        Tue, 06 Sep 2022 11:38:51 +0200
Message-ID: <45d9602c43c4fc7c2fe0883535499753cb4f16d3.camel@sipsolutions.net>
Subject: Re: [PATCH v3 02/12] mac80211: update TIM for S1G specification
 changes
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Kieran Frewen <kieran.frewen@morsemicro.com>
Cc:     linux-wireless@vger.kernel.org, quic_jjohnson@quicinc.com
Date:   Tue, 06 Sep 2022 11:38:50 +0200
In-Reply-To: <20220906044812.7609-3-kieran.frewen@morsemicro.com>
References: <20220906044812.7609-1-kieran.frewen@morsemicro.com>
         <20220906044812.7609-3-kieran.frewen@morsemicro.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-1.fc36) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2022-09-06 at 16:48 +1200, Kieran Frewen wrote:
> Updates to the TIM information element to match changes made in the
> IEEE Std 802.11ah-2020.
>=20
> +		if (ieee80211_get_sband(sdata)->band !=3D NL80211_BAND_S1GHZ) {
>=20

You probably should use ieee80211_get_link_sband() here now.

I'm not sure it _matters_ much since we shouldn't get here with MLO, but
it also doesn't really make a big difference for the code, and then we
won't keep thinking about whether it should be link or not :)

johannes
