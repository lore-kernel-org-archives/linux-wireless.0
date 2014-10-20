Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:58453 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088AbaJTIs3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2014 04:48:29 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21572.51890.316656.229674@gargle.gargle.HOWL> (sfid-20141020_104831_674341_706D167A)
Date: Mon, 20 Oct 2014 14:11:22 +0530
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH 06/10] ath9k_hw: do not run NF and periodic calibration at the same time
In-Reply-To: <1413651732-69783-6-git-send-email-nbd@openwrt.org>
References: <1413651732-69783-1-git-send-email-nbd@openwrt.org>
	<1413651732-69783-6-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> +		if (!ar9002_hw_per_calibration(ah, chan, rxchainmask, currCal))
> +			return 0;
> +
> +		ah->cal_list_curr = currCal = currCal->calNext;
> +		if (currCal->calState == CAL_WAITING) {
> +			ath9k_hw_reset_calibration(ah, currCal);
> +			return 0;

Won't this break things if longcal is set, since other types like
PA/OLC etc. need to be run in that case.

Sujith
