Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:34971 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798AbbFMSob (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Jun 2015 14:44:31 -0400
Received: by wgbhy7 with SMTP id hy7so9530808wgb.2
        for <linux-wireless@vger.kernel.org>; Sat, 13 Jun 2015 11:44:30 -0700 (PDT)
Message-ID: <557C7A0C.5060604@gmail.com> (sfid-20150613_204434_973438_6F040F42)
Date: Sat, 13 Jun 2015 20:44:28 +0200
From: Arend van Spriel <aspriel@gmail.com>
MIME-Version: 1.0
To: Luca Coelho <luca@coelho.fi>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH py80211 2/4] py80211: scan: add sched_scan start class
References: <1434117644-3033-1-git-send-email-luca@coelho.fi> <1434117644-3033-3-git-send-email-luca@coelho.fi>
In-Reply-To: <1434117644-3033-3-git-send-email-luca@coelho.fi>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 12-06-15 16:00, Luca Coelho wrote:
> From: Luciano Coelho <luciano.coelho@intel.com>
> 
> Add a class to start scheduled scans.
> 
> Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>

Merged in the master branch with following modification:

    [aspriel@gmail.com: fixed indentation]
    [aspriel@gmail.com: only use interval member in sched_scan_start]

Regards,
Arend

> ---
>  lib/scan.py | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/lib/scan.py b/lib/scan.py
> index 5ccae55..bfaf4da 100644
> --- a/lib/scan.py
> +++ b/lib/scan.py
> @@ -123,6 +123,7 @@ class scan_start_base(scan_cmd_base):
>  		self._flags = 0
>  		self._ies = None
>                  self._nl_cmd = None
> +                self._interval = None

Deal with interval in sched_scan_start class by overriding _add_scan_attrs.

>          def _add_scan_attrs(self):
>  		if self._ssids:
> @@ -144,6 +145,9 @@ class scan_start_base(scan_cmd_base):
>  		if self._ies:
>  			nl.nla_put(self._nl_msg._msg, nl80211.ATTR_IE, self._ies)
>  
> +                if self._interval != None:
> +                        nl.nla_put_u32(self._nl_msg._msg, nl80211.ATTR_SCHED_SCAN_INTERVAL, self._interval)
> +
>  	def add_ssids(self, ssids):
>  		if self._ssids == None:
>  			self._ssids = ssids
> @@ -183,3 +187,19 @@ class scan_request(scan_start_base):
>  		if genlh.cmd in [ nl80211.CMD_SCAN_ABORTED, nl80211.CMD_NEW_SCAN_RESULTS ]:
>  			self.scan_busy = False
>  		return nl.NL_SKIP
> +
> +class sched_scan_start(scan_start_base):
> +	def __init__(self, ifidx, level=nl.NL_CB_DEFAULT):
> +                super(sched_scan_start, self).__init__(ifidx, level)
> +                self._nl_cmd = nl80211.CMD_START_SCHED_SCAN
> +
> +	def set_interval(self, interval):
> +		self._interval = interval
> +
> +        def handle(self, msg, arg):
> +		genlh = genl.genlmsg_hdr(nl.nlmsg_hdr(msg))
> +
> +                # A schedule scan is complete immediately when it gets started
> +                if genlh.cmd in [ nl80211.CMD_START_SCHED_SCAN ]:
> +                        self.scan_busy = False
> +		return nl.NL_SKIP
> 
