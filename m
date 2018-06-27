Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59730 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754644AbeF0QQB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Jun 2018 12:16:01 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/9] mt76: fix beacon timer drift
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180621091801.41184-1-nbd@nbd.name>
References: <20180621091801.41184-1-nbd@nbd.name>
To: Felix Fietkau <nbd@nbd.name>
Cc: linux-wireless@vger.kernel.org
Message-Id: <20180627161601.33DF36024C@smtp.codeaurora.org> (sfid-20180627_181605_426758_EF752F3E)
Date: Wed, 27 Jun 2018 16:16:01 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau <nbd@nbd.name> wrote:

> The beacon timer drifts by 1 microsecond every TBTT. After 20 minutes
> with a beacon interval of 100, the drift will be almost 12 ms, enough to
> cause weird issues for devices in powersave mode.
> 
> Since the beacon timer is configured in units of 1/16 TU (64 us), we
> need to adjust it once every 64 beacons and only for one beacon.
> 
> Signed-off-by: Felix Fietkau <nbd@nbd.name>

9 patches applied to wireless-drivers-next.git, thanks.

aea38272920c mt76: fix beacon timer drift
9afef0fddaa1 mt76: fix threshold for gain adjustment
6cdb9614a818 mt76: fix swapped values for RXO-18 in gain control
929211687197 mt76: adjust AGC control register 26 based on gain for VHT80
fa967b586031 mt76: clear false CCA counters after changing gain settings
8e31f0d35a88 mt76: fix variable gain adjustment range
108ec4dafd61 mt76: add a debugfs file to dump agc calibration information
32e49efe0f15 mt76: track ewma rssi for gain adjustment per station
c3ae2103e069 mt76: improve gain adjustment in noisy environments

-- 
https://patchwork.kernel.org/patch/10479537/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
