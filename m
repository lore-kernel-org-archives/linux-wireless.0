Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17AF8EB64DB
	for <linux-wireless@archiver.kernel.org>; Wed, 14 Jun 2023 08:03:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238164AbjFNIDR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 14 Jun 2023 04:03:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243018AbjFNIC4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Jun 2023 04:02:56 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9709426B0;
        Wed, 14 Jun 2023 01:02:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=dVSXEn0iiAGSkxkpTSrJSP4GcGEkjq1CULMPAClVb+k=;
        t=1686729742; x=1687939342; b=hIrxg+jlyKYbkzXDBkSYr81cpv3/Zri/jGdpVwA3+zUdytb
        wor943IT1iiwrbm3MplqSy/hEdshWXnZbrOp83MBqGaj+xMfd4Kv667pJiTaTcaxNxuDfFwK0hhup
        JTK47WL6k9BQ2H07mDSmL3w8YA7pH3s8UMa56/V7ey/itDqQh2Xx/kdguTRjIjUN9mmeAQXxYeFye
        4ioWu5Op1oIo5jI/i8pSsXmBC86SNHYuxZYCO3caVp6tpgf8ucrTlvfm/owhbpL/GyyisfB5e/taS
        y6+ETyzqmtKgAENmT2L969+WMho3qnfWVeC60ofWKPXrgdnnvYZbouBWwVCwCXDw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1q9LSE-005zlN-31;
        Wed, 14 Jun 2023 10:02:11 +0200
Message-ID: <12c1079d6e73f8f62c33b8a53dff7ff4de0728dc.camel@sipsolutions.net>
Subject: Re: [PATCH] b43legacy: Remove unneeded variable
From:   Johannes Berg <johannes@sipsolutions.net>
To:     wuyonggang001@208suo.com, Larry.Finger@lwfinger.net,
        kvalo@kernel.org
Cc:     linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 14 Jun 2023 10:02:10 +0200
In-Reply-To: <194e8e87fda5f02664fcfac3717458f2@208suo.com>
References: <20230614075250.29097-1-zhanglibing@cdjrlc.com>
         <194e8e87fda5f02664fcfac3717458f2@208suo.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.3 (3.48.3-1.fc38) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2023-06-14 at 15:55 +0800, wuyonggang001@208suo.com wrote:
> Fix the following coccicheck warning:
>=20
> drivers/net/wireless/broadcom/b43legacy/debugfs.c:68:9-14: Unneeded=20
> variable: "count".

Hey, no. Please stop it already. This won't even _compile_. Just don't.
There's really not much value in cleaning up those coccicheck warnings
in the first place. You're just wasting everyone's time (including your
own).

johannes
