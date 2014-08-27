Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:44562 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932914AbaH0J6M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Aug 2014 05:58:12 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21501.43966.806614.922280@gargle.gargle.HOWL> (sfid-20140827_115815_998368_492F6C3F)
Date: Wed, 27 Aug 2014 15:28:22 +0530
To: Felix Fietkau <nbd@openwrt.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: Re: [PATCH 2/4] ath9k: Disable fastcc for channel context mode
In-Reply-To: <53FD9958.90806@openwrt.org>
References: <1409121445-11484-1-git-send-email-sujith@msujith.org>
	<1409121445-11484-3-git-send-email-sujith@msujith.org>
	<53FD9958.90806@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> > +	if (ath9k_is_chanctx_enabled())
> > +		fastcc = false;
> > +
> Why?

Constant switching of HW channels (and bgscan) appear to make things
go deaf after some time. We have never really tested fastcc and as
a preemptive measure, it can be disabled for MCC.

Sujith
