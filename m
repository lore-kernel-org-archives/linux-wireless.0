Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60144 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753174AbcKYJvY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Nov 2016 04:51:24 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/7] rtl8xxxu: Fix memory leak in handling rxdesc16 packets
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1479505468-29383-2-git-send-email-Jes.Sorensen@redhat.com>
References: <1479505468-29383-2-git-send-email-Jes.Sorensen@redhat.com>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
        Jes Sorensen <Jes.Sorensen@redhat.com>
Message-Id: <20161125095123.B271E61271@smtp.codeaurora.org> (sfid-20161125_105146_089023_301024E7)
Date: Fri, 25 Nov 2016 09:51:23 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jes Sorensen <Jes.Sorensen@redhat.com> wrote:
> From: Jes Sorensen <Jes.Sorensen@redhat.com>
> 
> A device running without RX package aggregation could return more data
> in the USB packet than the actual network packet. In this case the
> could would clone the skb but then determine that that there was no
> packet to handle and exit without freeing the cloned skb first.
> 
> This has so far only been observed with 8188eu devices, but could
> affect others.
> 
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>

7 patches applied to wireless-drivers-next.git, thanks.

a0aba89763f8 rtl8xxxu: Fix memory leak in handling rxdesc16 packets
cf7cfef06462 rtl8xxxu: Fix big-endian problem reporting mactime
b9af93551127 rtl8xxxu: Fix rtl8723bu driver reload issue
5d03f882c2fc rtl8xxxu: Fix rtl8192eu driver reload issue
a748a11038f8 rtl8xxxu: Obtain RTS rates from mac80211
b4c3d9cfb607 rtl8xxxu: Pass tx_info to fill_txdesc in order to have access to retry count
13e1349aff82 rtl8xxxu: Fix non static symbol warning

-- 
https://patchwork.kernel.org/patch/9437419/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
