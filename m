Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:53500 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756567Ab3FCPUo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jun 2013 11:20:44 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <20908.45989.889590.158302@gargle.gargle.HOWL> (sfid-20130603_172048_417659_0547A758)
Date: Mon, 3 Jun 2013 20:47:57 +0530
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/7] ath9k: Enable WoW only for AR9462
In-Reply-To: <20130603150846.GB2146@redhat.com>
References: <1370231369-16241-1-git-send-email-sujith@msujith.org>
	<1370231369-16241-2-git-send-email-sujith@msujith.org>
	<20130603150846.GB2146@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stanislaw Gruszka wrote:
> Do this feature will be added back in the future? If so, when? Or there
> are some limitations regarding WoW support on older chips?

WoW hasn't been tested or verified with ath9k using AR9280 at all, so we
don't know what is missing in ath9k to handle the chip's peculiarities.

> I'm asking because, we have RHEL customer that request WoWLAN support
> for AR9280. I thought this will be matter of backport ath9k driver
> from upstream to RHEL, since we have commits that add WoW for AR9002,
> including AR9280. But since you're now removing that feature I'm a bit
> worried. Will WoW be supported on AR9280, or we should rather ask
> customer to use different chip i.e. AR9462 ?

If AR9280 is used, getting support for WoW would be difficult. AR9462 has
been through internal test-cycles for WoW, so it seems a more sensible choice.

But, the AR9002-specific code can be retained in the driver if RH needs it.

Sujith
