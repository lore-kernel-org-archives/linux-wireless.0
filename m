Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.26]:56314 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752358Ab1BGGIn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Feb 2011 01:08:43 -0500
Received: from nokia.com (localhost [127.0.0.1])
	by mgw-da02.nokia.com (Switch-3.4.3/Switch-3.4.3) with ESMTP id p1768d2J023343
	for <linux-wireless@vger.kernel.org>; Mon, 7 Feb 2011 08:08:40 +0200
Subject: Re: [RFC PATCH] wl12xx: Change claiming of the (SDIO) bus
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linux-wireless@vger.kernel.org
Cc: luciano.coelho@nokia.com
In-Reply-To: <1296819336-8373-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1296819336-8373-1-git-send-email-juuso.oikarinen@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Feb 2011 08:08:22 +0200
Message-ID: <1297058902.4035.69.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-02-04 at 13:35 +0200, ext juuso.oikarinen@nokia.com wrote:
> From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> 
> Currently, the SDIO bus is claimed separately for each and every SDIO
> transaction - i.e. every register write/read etc.
> 
> The SDIO claiming is a relatively heavy operation. In a worst case scenario,
> it will put the SDIO bus on suspend, stop relevant clocks etc which all can be
> extremely costly if done between each SDIO transaction. This has a dramatic
> impact on the maximum throughput achieved.
> 
> The driver already manages its access to the bus as it needs to manage
> chipset ELP. This mechanism disables ELP for the duration of the whole bus
> access, consisting of multiple transactions.
> 
> Into the IO layer, this patch implements a claim/unclaim function, which is
> used to claim access to the bus. Relevant functions are checked and updated to
> maintain correctly the claim reference counter, so that each claim is paired
> with a corresponding unclaim.
> 
> For PLT and ad-hoc modes the bus is kept claimed contantly.
> 
> For AP mode, this patch brings no change to the previous way of working,
> someone familiar with it and with the ability to test it may implement
> something similar as is done here for the other modes.
> 
> For the SPI bus, the claim/unclaim functions are not implemented, i.e. no
> change to functionality.
> 
> Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> ---

I realised there are two separate issues here in one patch. I'll need to
split this into two patches. Also, there are some other issues I need to
address.

-Juuso

