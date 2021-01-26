Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07014C433E6
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Jan 2021 13:04:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B060C207D8
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Jan 2021 13:04:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S313823AbhAZWqt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Jan 2021 17:46:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:38928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729476AbhAZUdD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Jan 2021 15:33:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8BE89221FC;
        Tue, 26 Jan 2021 20:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611693129;
        bh=cSdZtKZsW51uAUJiVU9AGkB2IOj2VA0ZWXMUsghugfo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BXLLSgTXwowzKcsbR3yjYHfqv6zoKfoXIl8aXpIa58a7B42F+gRQQ3qHcm1n1tVxR
         2BwjGLA9ymelqnm6dlj0tilKMGeeCsuQMnK9UzISvyB8expRGHsqPWRgcErEiW5Ap4
         Yv7fx8DrQv3NY+IKN07sYYUx/N4/0QPzGNI6jKRP7wVOFO8sfQhWn8I8Cx1SKWdK78
         J0P8HEz+FMJyVXHcBz0pvvaB7fwbEvnM2Lg1r9J35w6INKjo0qBatU9mwwwe7+z8kk
         FYK91MdF8o/j3GwFqNPEJVKtimEDcyD8g6ZJN1rXjFmsjtEJ/Prsaarcumc+D05P8F
         /xVtAdJDNCURA==
Date:   Tue, 26 Jan 2021 12:32:07 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Ben Greear <greearb@candelatech.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH net] iwlwifi: provide gso_type to GSO packets
Message-ID: <20210126123207.5c79f4c0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210125150949.619309-1-eric.dumazet@gmail.com>
References: <20210125150949.619309-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, 25 Jan 2021 07:09:49 -0800 Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> net/core/tso.c got recent support for USO, and this broke iwlfifi
> because the driver implemented a limited form of GSO.
> 
> Providing ->gso_type allows for skb_is_gso_tcp() to provide
> a correct result.
> 
> Fixes: 3d5b459ba0e3 ("net: tso: add UDP segmentation support")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Ben Greear <greearb@candelatech.com>
> Bisected-by: Ben Greear <greearb@candelatech.com>
> Tested-by: Ben Greear <greearb@candelatech.com>
> Cc: Luca Coelho <luciano.coelho@intel.com>
> Cc: linux-wireless@vger.kernel.org
> Cc: Johannes Berg <johannes@sipsolutions.net>

Johannes, Eric tagged this for net, are you okay with me taking it?
No strong preference here.
