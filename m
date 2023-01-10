Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14533C54EBC
	for <linux-wireless@archiver.kernel.org>; Tue, 10 Jan 2023 11:19:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231455AbjAJLTc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 10 Jan 2023 06:19:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231254AbjAJLTX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Jan 2023 06:19:23 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D94CC32E9C
        for <linux-wireless@vger.kernel.org>; Tue, 10 Jan 2023 03:19:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=tcsF9TIMC9ldeudeDdAxgoPCWacET2ZdjuAZwZxID2U=;
        t=1673349562; x=1674559162; b=lsaZRihZXbjWINKLCrMTW+7h1B8cv0VVhKB4nwfups2JFJr
        hilbZBYRSf0hXp8m7XAoAgXXTgleJwuB5OCj6a/Meu7r5Y0ZqRRgaAJarAKLHWJNuKu49Sqcd9npl
        sRyPJcSoj+7eZFwPqomXDhpQFGIQaSX8MIhQyEmbj0PsBxPcwHLOSzj0vbc3d/raAGAMVW7FyI+Sh
        K/W+3eongEvrRrCWnTLYJeFV9Ul8JOWBmQ9DPtjMBkiVgpcmxLSWJ+j+9iyF6YKyZZNVB4pVfUKc+
        D2D7UpOkpf+HfMmmrSys0TBeP5m2O55KjXzbwNKjuU5jPz5rzfRRoAAhLxEB6xnQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1pFCf2-00FCnJ-12;
        Tue, 10 Jan 2023 12:19:20 +0100
Message-ID: <e41d9701282ba434871e3c3e28798fa4f16c582b.camel@sipsolutions.net>
Subject: Re: [PATCH] wifi: mac80211: add support for scanning in ap mode
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Nick <vincent@systemli.org>, linux-wireless@vger.kernel.org
Cc:     nbd@nbd.name, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Date:   Tue, 10 Jan 2023 12:19:18 +0100
In-Reply-To: <cc230245-2599-7665-3785-150dee0bf873@systemli.org>
References: <20230110110524.511258-1-vincent@systemli.org>
         <a7ccf0e6a1481f592fa9ff81f7b6545a4f4a653f.camel@sipsolutions.net>
         <cc230245-2599-7665-3785-150dee0bf873@systemli.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2023-01-10 at 12:18 +0100, Nick wrote:
> Thanks for your feedback. Can you suggest a better way to do this?
>=20

Well there already is NL80211_SCAN_FLAG_AP?

johannes
