Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:33247 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997Ab3IZR42 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Sep 2013 13:56:28 -0400
Message-ID: <1380218182.4592.11.camel@jlt4.sipsolutions.net> (sfid-20130926_195631_052052_CD422F8D)
Subject: Re: [PATCH 3.12] mac80211: drop spoofed packets in ad-hoc mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, thomas@net.t-labs.tu-berlin.de
Date: Thu, 26 Sep 2013 19:56:22 +0200
In-Reply-To: <1379409343-38116-1-git-send-email-nbd@openwrt.org>
References: <1379409343-38116-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-09-17 at 11:15 +0200, Felix Fietkau wrote:
> If an Ad-Hoc node receives packets with the Cell ID or its own MAC
> address as source address, it hits a WARN_ON in sta_info_insert_check()
> With many packets, this can massively spam the logs. One way that this
> can easily happen is through having Cisco APs in the area with rouge AP
> detection and countermeasures enabled.
> Such Cisco APs will regularly send fake beacons, disassoc and deauth
> packets that trigger these warnings.
> 
> To fix this issue, drop such spoofed packets early in the rx path.

Applied.

johannes

