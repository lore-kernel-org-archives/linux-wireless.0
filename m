Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:44414 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757205Ab3BSChw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2013 21:37:52 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <20770.58671.383019.745225@gargle.gargle.HOWL> (sfid-20130219_033754_712888_D039FE28)
Date: Tue, 19 Feb 2013 08:06:31 +0530
To: Ben Greear <greearb@candelatech.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: Re: 3.7.6+:  ath9k:  tx logic locks up after taking attenuation very
 high.
In-Reply-To: <20770.57339.20017.225929@gargle.gargle.HOWL>
References: <511935F2.8080103@candelatech.com>
	<20761.34987.125000.908722@gargle.gargle.HOWL>
	<511BC243.8010409@candelatech.com>
	<20770.57339.20017.225929@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith Manoharan wrote:
> xmit.c would be a good place. Can you also post the kernel log with some
> debugging information ? debug=0x8f49 would be good.

We came across an issue where slowly reducing attenuation would eventually
cause transmission to fail. This was seen only with the ath9k rate control module
and was fixed by the commit: "ath9k: Fix TX filter usage". With minstrel_ht,
things were smooth. Can you also try changing the RC and see if the issue is still seen ?

Sujith
