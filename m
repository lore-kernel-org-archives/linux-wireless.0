Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:50986 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752533AbYLIQLX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2008 11:11:23 -0500
Message-ID: <493E98A9.4070601@lwfinger.net> (sfid-20081209_171129_610966_CD069600)
Date: Tue, 09 Dec 2008 10:11:21 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@web.de>
CC: linux-wireless@vger.kernel.org,
	John W Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH v2] p54usb: rewriting rx/tx routines to make use of usb_anchor's
 facilities
References: <200812091514.37634.chunkeey@web.de> <493E92B5.90803@lwfinger.net>
In-Reply-To: <493E92B5.90803@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger wrote:
> Christian Lamparter wrote:
>> Alan Stern found several flaws in p54usb's implementation and annotated: 
>> "usb_kill_urb() and similar routines do not expect an URB's completion
>> routine to deallocate it.  This is almost obvious -- if the URB is deallocated
>> before the completion routine returns then there's no way for usb_kill_urb
>> to detect when the URB actually is complete."
>>
>> This patch addresses all known limitations in the old implementation and fixes
>> khub's "use-after-freed" hang, when SLUB debug's poisoning option is enabled.
>>
>> Signed-off-by: Christian Lamparter <chunkeey@web.de>
>> Cc: stable@kernel.org
>> ---
> 
> Tested-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---

For reference, the Bugzilla Entry for the p54usb problem is #12186. On my system
without the patch, 'modprobe -r p54usb' just hangs. There is no crash dump and
the process can be killed.

Larry
