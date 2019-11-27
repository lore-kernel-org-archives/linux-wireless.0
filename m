Return-Path: <SRS0=23TN=ZT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACAF3C43215
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Nov 2019 08:31:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8979E2064B
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Nov 2019 08:31:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726292AbfK0IbU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 27 Nov 2019 03:31:20 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:40602 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbfK0IbU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Nov 2019 03:31:20 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.3)
        (envelope-from <johannes@sipsolutions.net>)
        id 1iZsis-00DxP3-29; Wed, 27 Nov 2019 09:30:54 +0100
Message-ID: <6da209ffe31744d79c1394e1f3d038db19beca51.camel@sipsolutions.net>
Subject: Re: [PATCH v2 net-next] net: core: use listified Rx for GRO_NORMAL
 in napi_gro_receive()
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Alexander Lobakin <alobakin@dlink.ru>,
        David Miller <davem@davemloft.net>
Cc:     pabeni@redhat.com, ecree@solarflare.com,
        nicholas.johnson-opensource@outlook.com.au, jiri@mellanox.com,
        edumazet@google.com, idosch@mellanox.com, petrm@mellanox.com,
        sd@queasysnail.net, f.fainelli@gmail.com,
        jaswinder.singh@linaro.org, ilias.apalodimas@linaro.org,
        linux-kernel@vger.kernel.org, emmanuel.grumbach@intel.com,
        luciano.coelho@intel.com, linuxwifi@intel.com,
        kvalo@codeaurora.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Date:   Wed, 27 Nov 2019 09:30:51 +0100
In-Reply-To: <4cb1abfb7cbd137151f024405f7b0678@dlink.ru>
References: <414288fcac2ba4fcee48a63bdbf28f7b9a5037c6.camel@sipsolutions.net>
         <b4b92c4d066007d9cb77e1645e667715c17834fb.camel@redhat.com>
         <d535d5142e42b8c550f0220200e3779d@dlink.ru>
         <20191126.155746.627765091618337419.davem@davemloft.net>
         <4cb1abfb7cbd137151f024405f7b0678@dlink.ru>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2019-11-27 at 10:47 +0300, Alexander Lobakin wrote:

> > Can I get some kind of fix in the next 24 hours?  I want to send a 
> > quick
> > follow-on pull request to Linus to deal with all of the fallout, and in
> > particular fix this regression.
> 
> If Intel guys and others will agree, I'll send a patch which will add
> manual napi->rx_list flushing in iwlwifi driver in about ~2-3 hours.

Sounds fine to me.

> Anyway, this driver should get a proper NAPI in future releases to
> prevent problems like this one.

Yeah, we'll work on that, but that might take a bit longer :)

johannes

