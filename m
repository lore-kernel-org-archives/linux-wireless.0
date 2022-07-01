Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2CAEC433EF
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Jul 2022 08:49:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233946AbiGAItS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 1 Jul 2022 04:49:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236058AbiGAItB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Jul 2022 04:49:01 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C84E713F7B
        for <linux-wireless@vger.kernel.org>; Fri,  1 Jul 2022 01:48:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=S324yo1MkAPJlZC8tKhqLTQi/sUxJhGGunT/Ix/iSlk=;
        t=1656665324; x=1657874924; b=yIonJ9OGTnl7BWHtbgzGmEDXeLtKrRLQTsWZuNv1LLxAPFD
        tn7lW3x3y/vke9Nio2WZ8t76+t0kG7WgrpnT3kWz5M22zSI0zzw1rUWgcVUUhJwTMGqxa/stlF/me
        pT6whjGAxCluRy8lPR4n0ax0+bGp5RvcHf+ZSDaRbaHX10y0KxZOuQ9pB1ja/NaDqmCUWnW6+8ADH
        X8mFesqLmVjvocX6Zj1AL/OPZvnjAVUg0a4Ld1/XYRzVeRlZcmxChEzDTRqnBIcrPcSdiabsXwE5v
        rQjzoAx5gDmDpPWd9SO2syTcOIBlTyrluRvnHBHpgtkAvihVFn/HUBgNu30BvXzA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1o7CKQ-003PLA-SG;
        Fri, 01 Jul 2022 10:48:42 +0200
Message-ID: <98e3a2743ab770fbd3f14dca14b62105c8457bf6.camel@sipsolutions.net>
Subject: Re: [PATCH 0/3] Mesh Fast xmit support
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Sriram R <quic_srirrama@quicinc.com>
Cc:     linux-wireless@vger.kernel.org
Date:   Fri, 01 Jul 2022 10:48:42 +0200
In-Reply-To: <1654857639-12346-1-git-send-email-quic_srirrama@quicinc.com>
References: <1654857639-12346-1-git-send-email-quic_srirrama@quicinc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.2 (3.44.2-1.fc36) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

>=20
> Sriram R (3):
>   cfg80211: increase mesh config attribute bitmask size
>   cfg80211: Add provision for changing mesh header cache size
>=20

Is there really that much point in making that configurable? I have no
idea how a user could possibly set this to a reasonable value?

Maybe it would make more sense to auto-size it somehow depending on
memory? Or just pick a reasonable upper bound and leave it at that?

johannes
