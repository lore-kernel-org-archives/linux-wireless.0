Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36430 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751561AbeDXRdd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Apr 2018 13:33:33 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/2,v2] mt7601u: use EWMA to calculate avg_rssi
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1523879778-6455-1-git-send-email-sgruszka@redhat.com>
References: <1523879778-6455-1-git-send-email-sgruszka@redhat.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org, Jakub Kicinski <kubakici@wp.pl>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Message-Id: <20180424173332.D7833607E1@smtp.codeaurora.org> (sfid-20180424_193423_611521_C053D3DC)
Date: Tue, 24 Apr 2018 17:33:32 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stanislaw Gruszka <sgruszka@redhat.com> wrote:

> avr_rssi is not calculated correctly as we do not divide result
> by 256 (mt76 sum avg_rssi1 and avg_rssi2 and divide by 512).
> However dividing by 256 will make avg_rssi almost the same as
> last rssi value - not really an average. So use EWMA to calculate
> avg_rssi. I've chosen weight_rcp=4 to convergence quicker on signal
> strength changes.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> Acked-by: Jakub Kicinski <kubakici@wp.pl>

2 patches applied to wireless-drivers-next.git, thanks.

b305a6ab0247 mt7601u: use EWMA to calculate avg_rssi
2019c39a2d60 mt7601u: run calibration works after finishing scanning

-- 
https://patchwork.kernel.org/patch/10342803/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
