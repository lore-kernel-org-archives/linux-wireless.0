Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 697D6E7C4CA
	for <linux-wireless@archiver.kernel.org>; Wed,  4 Oct 2023 14:58:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243050AbjJDO6s (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 4 Oct 2023 10:58:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233695AbjJDO6r (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Oct 2023 10:58:47 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:242:246e::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7939CAB;
        Wed,  4 Oct 2023 07:58:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=ItaLEz8yYofv11YCURyJNHQx1l8I20bDLTqN6Rxdd18=;
        t=1696431523; x=1697641123; b=V8UOdtE6xNiCDdn57mg2rZW1wknmRZhcWWKzURhlpGXn0xL
        AP+N0SPBViYfmIxwNOBfLsMIrBRI/ripJk1Yc1mUSP5CZr71arfZ/xOC4zA4u0U+1ibnGg7zlZQVJ
        AW19LyyeftKStRpcvyC0aTjt705Z76vNyGTJT05u0OZz67X4ljGOJqZZXSPvnTEobvAv6Unwbp9N2
        PnpCvbNDUJNphgHzz5dmekHS94tqQ0djiZ4HhA6cLXornbbYq5HFgw/9BJbF3rYXb1OxqwU7RuRxg
        Plhh3Y+3Tuz6QTMDXJbCY7FIymIV1KxF11LxiaVKfJo5lJqjR/TaiypI50rfXsAg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1qo3KV-0040mn-30;
        Wed, 04 Oct 2023 16:58:28 +0200
Message-ID: <3ba8e3902ade7483a82bd305a35a236744ffba25.camel@sipsolutions.net>
Subject: Re: [lvc-project] [PATCH] wifi: mac80211: fix buffer overflow in
 ieee80211_rx_get_bigtk()
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Igor Artemiev <Igor.A.Artemiev@mcst.ru>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
Date:   Wed, 04 Oct 2023 16:58:26 +0200
In-Reply-To: <20231004143740.40933-1-Igor.A.Artemiev@mcst.ru>
References: <20231004143740.40933-1-Igor.A.Artemiev@mcst.ru>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2023-10-04 at 17:37 +0300, Igor Artemiev wrote:
> If 'idx' is 0

And ... how exactly do you propose that is going to happen?

johannes
