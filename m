Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45243 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751542AbcJCHZy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Oct 2016 03:25:54 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Jes.Sorensen@redhat.com
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/2] rtl8xxxu: Fix memory leak in handling rxdesc16 packets
References: <1475178055-16924-1-git-send-email-Jes.Sorensen@redhat.com>
        <1475178055-16924-2-git-send-email-Jes.Sorensen@redhat.com>
Date: Mon, 03 Oct 2016 10:25:49 +0300
In-Reply-To: <1475178055-16924-2-git-send-email-Jes.Sorensen@redhat.com> (Jes
        Sorensen's message of "Thu, 29 Sep 2016 15:40:54 -0400")
Message-ID: <87wphpsxky.fsf@kamboji.qca.qualcomm.com> (sfid-20161003_092557_692399_D52793CD)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jes.Sorensen@redhat.com writes:

> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>
> A device running without RX package aggregation could return more data
> in the USB packet than the actual network packet. In this case the
> could would clone the skb but then determine that that there was no
> packet to handle and exit without freeing the cloned skb first.

s/case the/case we/? I can edit that before applying the patch.

-- 
Kalle Valo
