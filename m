Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54884 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754019AbcJGLW6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Oct 2016 07:22:58 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/2] rtl8xxxu: Fix memory leak in handling rxdesc16 packets
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1475178055-16924-2-git-send-email-Jes.Sorensen@redhat.com>
References: <1475178055-16924-2-git-send-email-Jes.Sorensen@redhat.com>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
        stable@vger.kernel.org, Jes Sorensen <Jes.Sorensen@redhat.com>
Message-Id: <20161007112258.241FA61AD5@smtp.codeaurora.org> (sfid-20161007_132303_111943_D4A50856)
Date: Fri,  7 Oct 2016 11:22:58 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jes Sorensen <Jes.Sorensen@redhat.com> wrote:
> From: Jes Sorensen <Jes.Sorensen@redhat.com>
> 
> A device running without RX package aggregation could return more data
> in the USB packet than the actual network packet. In this case we
> could would clone the skb but then determine that that there was no
> packet to handle and exit without freeing the cloned skb first.
> 
> This has so far only been observed with 8188eu devices, but could
> affect others.
> 
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
> Cc: stable@vger.kernel.org # 4.8+

2 patches applied to wireless-drivers.git, thanks.

1e54134ccad0 rtl8xxxu: Fix memory leak in handling rxdesc16 packets
8a55698f2f29 rtl8xxxu: Fix big-endian problem reporting mactime

-- 
https://patchwork.kernel.org/patch/9356961/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
