Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:44786 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698Ab3FFEIm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jun 2013 00:08:42 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <20912.2720.990590.284874@gargle.gargle.HOWL> (sfid-20130606_060846_588831_95B39904)
Date: Thu, 6 Jun 2013 09:35:52 +0530
To: Ben Greear <greearb@candelatech.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, stable@vger.kernel.org,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] ath9k: Use minstrel rate control by default
In-Reply-To: <51B006AE.6080309@candelatech.com>
References: <1370488216-11626-1-git-send-email-sujith@msujith.org>
	<51B006AE.6080309@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear wrote:
> If you will just delete that code above, then you can compile in both ath9k
> and minstrel rate controls and select at run-time by twiddling the mac80211
> rate control module option.

I am not sure if a user is going to change the rate control at run-time by
reloading mac80211 and what would be point in using ath9k RC which has basic
connectivity problems ?

> Last I tested there were still advantages to ath9k rate control in our environment,
> (including when running through an attenuator and over-the-air),
> so I think it should be left in to keep minstrel honest if nothing else.

ath9k RC shows slightly higher throughput numbers in an _ideal_ environment,
but that is hardly the case in real-world usage. I agree that the code can
be left in the driver, it will be useful for comparison with minstrel.

Sujith

