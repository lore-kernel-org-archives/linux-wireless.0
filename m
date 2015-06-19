Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:37118 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787AbbFSIHR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Jun 2015 04:07:17 -0400
Message-ID: <5583CDB2.3040306@broadcom.com> (sfid-20150619_100728_624629_7DEA9303)
Date: Fri, 19 Jun 2015 10:07:14 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Luca Coelho <luca@coelho.fi>
CC: <aspriel@gmail.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH py80211] py80211: scan: fix call to _add_scan_attrs()
 in the sched_scan_start class
References: <1434439958-9447-1-git-send-email-luca@coelho.fi>
In-Reply-To: <1434439958-9447-1-git-send-email-luca@coelho.fi>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/16/15 09:32, Luca Coelho wrote:
> From: Luciano Coelho<luciano.coelho@intel.com>
>
> We should not pass self explicitly when calling the superclass's
> _add_scan_attrs() in the sched_scan_start class.  Fix it.

Sloppy maintainer at work ;-) My python knowledge need a refresh. I like 
the super() concept, but did not do the training yet. :-)

Thanks for the fix. Applied to py80211 master branch.

Regards,
Arend

> Signed-off-by: Luciano Coelho<luciano.coelho@intel.com>
> ---
>   lib/scan.py | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/lib/scan.py b/lib/scan.py
> index 32cb68b..3ce242e 100644
> --- a/lib/scan.py
> +++ b/lib/scan.py
> @@ -191,7 +191,7 @@ class sched_scan_start(scan_start_base):
>   		self._matches = None
>
>   	def _add_scan_attrs(self):
> -		super(sched_scan_start, self)._add_scan_attrs(self)
> +		super(sched_scan_start, self)._add_scan_attrs()
>   		if self._interval != None:
>   			nl.nla_put_u32(self._nl_msg._msg, nl80211.ATTR_SCHED_SCAN_INTERVAL, self._interval)
>

