Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71806C433EF
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Jul 2022 07:55:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234622AbiGVHzJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Jul 2022 03:55:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230429AbiGVHzI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Jul 2022 03:55:08 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FBEEB8F;
        Fri, 22 Jul 2022 00:55:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=bT0SRECV61FQpDU/9mgiJdmvScp2+x/xiqSm91nzE4k=;
        t=1658476506; x=1659686106; b=m+2otisFCVvRjLSB5wmfIMmnZXAMCg1XB7E7mS7tpuKe+Im
        CiJA41EbQTKvpypDwYKr8Y92bO6p6F/q1Mm95THu+nJWXvthiY4WqcgvnQh+oXvauldVe1af8xBz8
        P6XsES/NFmKAl2Af42IgsPspn5YBoR+J85+ZVfowib4Hic7Grhoq743/Z9JxzMkEbOyyjgdBYIDkJ
        okE9J0h9wM/esTcryBqTfbsBFxz8/dReZMgOy9El0uazIYpJeSh6u7GwIXkk7P6eiImqsqFdpWG/Z
        CNMADawOy4qo/zUcsuEmB/eu50sLmzPfgoS8X+GuYQ/ix7vLWEvjS+iID5p1kB8w==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1oEnUx-005DXd-0B;
        Fri, 22 Jul 2022 09:54:59 +0200
Message-ID: <0a400422546112e91e087ce285ec5a532193ada3.camel@sipsolutions.net>
Subject: Re: mac80211/ath11k regression in next-20220720
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Johan Hovold <johan@kernel.org>, Kalle Valo <kvalo@kernel.org>
Cc:     ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Fri, 22 Jul 2022 09:54:57 +0200
In-Reply-To: <YtpXNYta924al1Po@hovoldconsulting.com>
References: <YtpXNYta924al1Po@hovoldconsulting.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.3 (3.44.3-1.fc36) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 2022-07-22 at 09:52 +0200, Johan Hovold wrote:
> Hi,
>=20
> After moving from next-20220714 to next-20220720, ath11k stopped
> working here and instead spits out a bunch of warnings (see log below).
>=20
> I noticed that this series from Johannes was merged in that period:
>=20
> 	https://lore.kernel.org/all/20220713094502.163926-1-johannes@sipsolution=
s.net/
>=20
> but can't say for sure that it's related. I also tried adding the
> follow-up fixes from the mld branch:
>=20
> 	https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.g=
it/log/?h=3Dmld
>=20
> but it didn't seem to make any difference.
>=20
> Any ideas about what might be going on here?
>=20

We think the "fix" is this:

https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git/=
commit/?h=3Dmld&id=3Ddd5a559d8e90fdb9424e0580b91702c5838928dc

Do you want to try it?

Note that if that fixes it, it's still a bug in the driver, but one that
you'd otherwise not hit.

Anyway I'll do some tree shuffling today and get that in.

johannes
