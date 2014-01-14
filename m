Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.w1.fi ([212.71.239.96]:45723 "EHLO
	li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751492AbaANQaa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jan 2014 11:30:30 -0500
Date: Tue, 14 Jan 2014 18:30:27 +0200
From: Jouni Malinen <j@w1.fi>
To: Arend van Spriel <arend@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: wpa_supplicant and driver reload
Message-ID: <20140114163027.GA23034@w1.fi> (sfid-20140114_173033_382929_DC52C353)
References: <52A82A1D.80409@broadcom.com>
 <2323CBC6-B7B3-49FF-882F-66B9F0B9A879@w1.fi>
 <52AD7335.1090101@broadcom.com>
 <52D55C5C.8010402@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <52D55C5C.8010402@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 14, 2014 at 04:48:44PM +0100, Arend van Spriel wrote:
> On 12/15/2013 10:15 AM, Arend van Spriel wrote:
> Found the problem in the way brcmfmac does cleanup upon unload. With
> that fixed I notice some other behaviour. After 3 driver reloads (within
> 1 minute) wpa_supplicant requests a scheduled scan. I fixed that by
> resetting wpa_s->normal_scans to zero upon entering
> WPA_INTERFACE_DISABLED state.

Patch welcome..

> The only thing left is that after each
> reload the delay before requesting a scan increases with 1 second. This
> is caused by the fact that in wpa_supplicant_driver_init() the delay is
> determined by a static counter that increments upon each call (if there
> are enabled networks). I think this is mainly intended for wpa_s startup
> so scans for each interface are not colliding. Not sure what the best
> way is to solve that.

Finishing this stalled discussion:
http://patchwork.ozlabs.org/patch/245486/

And yes, this was added very much for the case of initial start only, so
doing a clean change to limit it for that case should be fine.

-- 
Jouni Malinen                                            PGP id EFC895FA
