Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46030 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753412Ab2AIIyc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jan 2012 03:54:32 -0500
Subject: Re: [PATCH 0/4] Enable uAPSD support in AP mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Thirumalai <tpachamu@qca.qualcomm.com>
Cc: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org
In-Reply-To: <1326095083-1538-1-git-send-email-tpachamu@qca.qualcomm.com> (sfid-20120109_084754_846351_9C65331D)
References: <1326095083-1538-1-git-send-email-tpachamu@qca.qualcomm.com>
	 (sfid-20120109_084754_846351_9C65331D)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 Jan 2012 09:54:28 +0100
Message-ID: <1326099268.3451.0.camel@jlt3.sipsolutions.net> (sfid-20120109_095435_696259_F6555235)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-01-09 at 13:14 +0530, Thirumalai wrote:
> In addition to legacy power save, this series of patch adds
> support for uAPSD in AP mode.
> 
> When connected station goes into suspend state, the driver will
> start queuing pkts in the separate queue (called uapsd queue)
> until the station ask for it. 
> 
> The moment driver starting queuing, it will enable traffic indication
> bit for the client connected to indicate data availability. 
> Once station ask for the data (via Trigger frame), the driver will 
> dequeue and send pkt one by one to the station.

The way you describe this sounds incorrect, but I'll leave it to Kalle
to figure out what you're doing and whether it is correct or not ... if
only some ACs are trigger-enabled those don't influence the TIM bit.

johannes

