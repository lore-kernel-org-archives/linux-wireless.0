Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45748 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758085Ab3AIRbB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jan 2013 12:31:01 -0500
Message-ID: <1357752686.9757.18.camel@jlt4.sipsolutions.net> (sfid-20130109_183113_442290_F27C58B4)
Subject: Re: Q: how to update platform power state for the network driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 09 Jan 2013 18:31:26 +0100
In-Reply-To: <6929081.7c7blFVDp4@lx-vladimir> (sfid-20130109_182029_783210_FC7FE104)
References: <6929081.7c7blFVDp4@lx-vladimir>
	 (sfid-20130109_182029_783210_FC7FE104)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-01-09 at 19:20 +0200, Vladimir Kondratiev wrote:
> Hi,
> 
> in 60g spec (802.11ad, references to this doc.), station should set "power source" bit in the:
> 
> 8.4.2.130.3 DMG PCP/AP Capability Information field
> 
> This information used to construct "PCP factor" that used in:
> 
> 10.1.4.3.4 PCP selection in a PBSS
> 
> This procedure replaces GO negotiation in P2P. "power source" bit above specified as:
> 
> The Power Source field is set to 0 if the STA is battery powered, and is set to 1 otherwise.
> 
> What is the best way to obtain this info in the network driver?

You can't really do that very well. Set it in wpa_supplicant according
to the configuration. It might even query the power source on a laptop,
but I suspect this is a somewhat different use case anyway.

johannes

