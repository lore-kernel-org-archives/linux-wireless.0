Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:56066 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbbFQJj1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2015 05:39:27 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21889.16487.258289.588207@gargle.gargle.HOWL> (sfid-20150617_113931_515282_2050CDD4)
Date: Wed, 17 Jun 2015 15:09:51 +0530
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org
Subject: Re: [RFCv2] ath9k: make rxfilter per HW
In-Reply-To: <CALhHN=ro4K6mALLHqgVRGm50UGg5hh9mnSSAnNHwZdZ5ywOk-Q@mail.gmail.com>
References: <1434520009-8824-1-git-send-email-janusz.dziedzic@tieto.com>
	<21889.11726.101648.552280@gargle.gargle.HOWL>
	<55812FB5.1070005@openwrt.org>
	<21889.14109.54454.563245@gargle.gargle.HOWL>
	<CALhHN=ro4K6mALLHqgVRGm50UGg5hh9mnSSAnNHwZdZ5ywOk-Q@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Janusz Dziedzic wrote:
> This is what I have with use_chanctx=1
> Jun 17 06:57:54 dell6430 kernel: [53297.753256] xxx ath_calcrxfilter
> filter: 0x207
> 
> 0x000000080 is for probe_req

Ok, so the probe_req filter is set before actually initiating
RoC - this appears to be the current design in wpa_s.

I am not sure if using a global filter that disregards
the opmode of a context is the right approach, though...

Sujith
