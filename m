Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57276 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755366AbcGHNqG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2016 09:46:06 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/2] brcmfmac: delete interface directly in code that sent fw
 request
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1467230067-3302-2-git-send-email-zajec5@gmail.com>
To: =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Franky Lin <franky.lin@broadcom.com>,
	Hante Meuleman <hante.meuleman@broadcom.com>,
	Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	linux-wireless@vger.kernel.org (open list:BROADCOM BRCM80211
	IEEE802.11n WIRELESS DRIVER),
	brcm80211-dev-list.pdl@broadcom.com (open list:BROADCOM BRCM80211
	IEEE802.11n WIRELESS DRIVER),
	netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
	linux-kernel@vger.kernel.org (open list)
Message-Id: <20160708134605.3BF7E60260@smtp.codeaurora.org> (sfid-20160708_154631_520398_63FC3969)
Date: Fri,  8 Jul 2016 13:46:05 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki wrote:
> So far when receiving event about in-firmware-interface removal our
> event worker was notifying listener and afterwards it was removing Linux
> interface.
> 
> First of all it was resulting in slightly unexpected order. The listener
> (del_virtual_intf callback) was (usually) returning with success before
> we even called unregister_netdev(ice).
> 
> Please note this couldn't be simply fixed by changing order of calls in
> brcmf_fweh_handle_if_event as unregistering interface earlier could free
> struct brcmf_if.
> 
> Another problem of current implementation are possible lockups. Focus on
> the time slot between calling event handler and removing Linux
> interface. During that time original caller may leave (unlocking rtnl
> semaphore) *and* another call to the same code may be done (locking it
> again). If that happens our event handler will stuck at removing Linux
> interface, it won't handle another event and will block process holding
> rtnl lock.
> 
> This can be simply solved by unregistering interface in a proper
> callback, right after receiving confirmation event from firmware. This
> only required modifying worker to don't unregister on its own if there
> is someone waiting for the event.
> 
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>

Thanks, 2 patches applied to wireless-drivers-next.git:

a63b09872c1d brcmfmac: delete interface directly in code that sent fw request
dba8fbc67ecd brcmfmac: support removing AP interfaces with "interface_remove"

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9206157/

