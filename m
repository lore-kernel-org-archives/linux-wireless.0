Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62468 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752967AbaFDNTW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2014 09:19:22 -0400
Date: Wed, 4 Jun 2014 15:18:01 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Matthias Fend <Matthias.Fend@wolfvision.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: rt2x00: Ralink RT5572 very high peak current consumption
Message-ID: <20140604131801.GB1416@redhat.com> (sfid-20140604_151926_015982_713A84D2)
References: <CC2A85E271C1FB479D9C17305347F69A4479A6@WOLFSERVER19.wolfvision-at.intra>
 <CC2A85E271C1FB479D9C17305347F69A44D336@WOLFSERVER19.wolfvision-at.intra>
 <20140527151201.GA6131@redhat.com>
 <CC2A85E271C1FB479D9C17305347F69A44E4A7@WOLFSERVER19.wolfvision-at.intra>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CC2A85E271C1FB479D9C17305347F69A44E4A7@WOLFSERVER19.wolfvision-at.intra>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Tue, May 27, 2014 at 03:44:01PM +0000, Matthias Fend wrote:
> You just made my day! This was exactly the setting I was looking for.
> And yes, it seems that clearing the TXWI at the beacon location is not enough to completely disable beacon sending.
> Together with the already mentioned change in TXOP_HLDR_ET (use 0x0A instead of 0x82) it's looking identical to the windows setup.

I don't know why TXOP_HLDR_ET registr does matter, it seems to be
setting that is used for HCCA (Hybrid coordintanion function), which we
do not support (we do not set TXOP_HLDR_ADDR). But perhaps this setting
is also used on EDCA. Did you also tested this setting on STA mode ?

Regarding MAC_BSSID_DW1_BSS_BCN_NUM, I'll post RFC patches, please 
test them (whould be good to test them on multi-vif AP setup, to 
see if many beacons works).

Stanislaw
