Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A547C636CC
	for <linux-wireless@archiver.kernel.org>; Wed, 15 Feb 2023 15:10:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229852AbjBOPKR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 15 Feb 2023 10:10:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbjBOPKQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Feb 2023 10:10:16 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72F1E25976;
        Wed, 15 Feb 2023 07:10:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=+IhXvip6E0zB3m+HmAxx505GyG5cx1vo0UJZ0GujIH0=;
        t=1676473815; x=1677683415; b=PGR/oPAmC1dCpGoSUF2uLvszQ5SfjrJGDfq+Nj6HJr+yBKM
        M9ucmRIaSTb7zvYNcMNhfASMmBgPS0r3mVupPair1PF0TObX9q5ulOiYK+zmOxPk3v2rIsTZcUihM
        rZXx7oerBqfpgnabnOvCdLu2R0qypqpV9mCwbH2PZrVJ8l2XaJ8+ULyapO8qQ44U+YcghgxAvJoQb
        dcpqlN8s2Iam3KHoa42of8R1mh2zrnEk5CkC+xRNL+tX1eNTXhfuPg9ffZ+thRStRwGBC/nAILcGB
        1ZGcdBSwa8Wf9nLTI7FQguUmUSd5XIcvK/cKKbpp9vYFOey2WE5kcO9VM/IaT3DQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1pSJQC-00D6at-0S;
        Wed, 15 Feb 2023 16:10:12 +0100
Message-ID: <0d4b99ab0a5bedc82f35bc1e548a611564b010e5.camel@sipsolutions.net>
Subject: Re: [PATCH 1/2] wifi: cfg80211: Add beacon hint notifier support
From:   Johannes Berg <johannes@sipsolutions.net>
To:     "Youghandhar Chintala (Temp)" <quic_youghand@quicinc.com>,
        ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        quic_mpubbise@quicinc.com
Date:   Wed, 15 Feb 2023 16:10:11 +0100
In-Reply-To: <96cab5d9-9090-4cb2-ff17-eadc9da12f50@quicinc.com>
References: <20221222124221.30894-1-quic_youghand@quicinc.com>
         <20221222124221.30894-2-quic_youghand@quicinc.com>
         <1df59863e78e8ddbe7eb3a74e6dd4c8f0bd7f098.camel@sipsolutions.net>
         <96cab5d9-9090-4cb2-ff17-eadc9da12f50@quicinc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> >=20
> > Why is this even needed? You should always get reg_notifier after this
> > anyway?
>=20
> Currently when channel flag changed through the beacon hints are not=20
> informed to driver.
>=20
> reg_notifier will be triggered for regdomain changes but not for channel =
flag changes due to beacon hints.
>=20

So maybe triggering reg notifier once would be sufficient, a la Wen's
patch that I recently merged?

johannes
