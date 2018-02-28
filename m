Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56532 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752436AbeB1O7B (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Feb 2018 09:59:01 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] mt7601u: make write with mask access atomic
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <4a8ec536fda4741ef88618493d0641fbd497314c.1518819577.git.lorenzo.bianconi@redhat.com>
References: <4a8ec536fda4741ef88618493d0641fbd497314c.1518819577.git.lorenzo.bianconi@redhat.com>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: kubakici@wp.pl, linux-wireless@vger.kernel.org
Message-Id: <20180228145900.EDFC1607B9@smtp.codeaurora.org> (sfid-20180228_155904_584721_7466E5ED)
Date: Wed, 28 Feb 2018 14:59:00 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:

> Introduce __mt7601u_rr and __mt7601u_vendor_single_wr routines in order
> to make mt7601u_rmw and mt7601u_rmc atomic. This patch does not fix a
> reported issue but makes the usb access more robust to concurrent
> operations on the same register since it is theoretically possible that
> read and write accesses of mt7601u_rmw/mt7601u_rmc can be interleaved with
> a different write operation on the same register.
> Moreover using __mt7601u_rr and __mt7601u_vendor_single_wr in
> mt7601u_rmw/mt7601u_rmc allows to grab vendor_req_mutex mutex once
> instead of twice
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> Acked-by: Jakub Kicinski <kubakici@wp.pl>

Patch applied to wireless-drivers-next.git, thanks.

fee05843801c mt7601u: make write with mask access atomic

-- 
https://patchwork.kernel.org/patch/10225849/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
