Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpm-eml102.kpnxchange.com ([195.121.3.6]:61986 "EHLO
	CPSMTPM-EML102.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755118AbZJAAf0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2009 20:35:26 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-wireless@vger.kernel.org
Subject: Re: [SOLVED][.32-rc1/2] ath5k: has become unreliable with .32-rc1
Date: Thu, 1 Oct 2009 02:35:27 +0200
Cc: linux-kernel@vger.kernel.org, Bob Copeland <me@bobcopeland.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>
References: <200909300952.29106.elendil@planet.nl>
In-Reply-To: <200909300952.29106.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200910010235.28904.elendil@planet.nl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 30 September 2009, Frans Pop wrote:
> The first time I booted .32-rc1 (reboot from .31-rc5), wireless came up
> without problems, but failed to come back after suspend to RAM. I could
> only get wireless back by ejecting and re-inserting the PCMCIA card.
>
> The second and third time I booted .32-rc1 (to write this report; a cold
> boot and a ".32 to .32" reboot), wireless did not come up at all.
> See attached dmesg. The last part is after 'ifup ath0'. It seems to
> associate, but then for some reason immediately deauthenticates again.

Both issues are solved with current mainline. Probably the resume issue by 
Rafael's PCMCIA patch (the "late" config restore messages for ath5k are 
back too), the boot issue by one of Johannes' patches (I'd guess either 
4be3bd8c 'cfg80211: don't set privacy w/o key' or maybe 8bb89485
'cfg80211: always get BSS').

Still strange that iwlagn continued to work. Although, come to think of it, 
I have not cold booted that laptop recently.

Cheers,
FJP
