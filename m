Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:35836 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751279AbeAWKiV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Jan 2018 05:38:21 -0500
Subject: Re: [PATCH] mt76x2: fix WMM parameter configuration
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: linux-wireless@vger.kernel.org, gaetano.catalli@gmail.com
References: <cover.1516186517.git.lorenzo.bianconi@redhat.com>
 <7554b3527fd55afa7561ffc89fb7f3bea1a902ed.1516186517.git.lorenzo.bianconi@redhat.com>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <781e466b-6d23-c8c2-efcc-d8ff864034a6@nbd.name> (sfid-20180123_113825_327477_141C83E6)
Date: Tue, 23 Jan 2018 11:38:19 +0100
MIME-Version: 1.0
In-Reply-To: <7554b3527fd55afa7561ffc89fb7f3bea1a902ed.1516186517.git.lorenzo.bianconi@redhat.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-01-17 12:01, Lorenzo Bianconi wrote:
> Fix hw queue configuration since mt76x2 devices use a reverse queue
> enumeration respect to mac80211 one:
>  - 0: AC_BE
>  - 1: AC_BK
>  - 2: AC_VI
>  - 3: AC_VO
> 
> The issue can be reproduced sending two concurrent flow using
> two separate queues:
>  - VO: 20Mbps UDP traffic
>  - BE: TCP traffic
> 
> In this scenario the UDP traffic will be blocked by the TCP one.
> Fix it configuring properly WMM hw queue parameters
> 
> Fixes: 7bc04215a66b ("mt76: add driver code for MT76x2e")
> Tested-by: Gaetano Catalli <gaetano.catalli@gmail.com>
> Signed-off-by: Gaetano Catalli <gaetano.catalli@gmail.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Acked-by: Felix Fietkau <nbd@nbd.name>
