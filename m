Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:37281 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbbFMSpm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Jun 2015 14:45:42 -0400
Received: by wifx6 with SMTP id x6so42011911wif.0
        for <linux-wireless@vger.kernel.org>; Sat, 13 Jun 2015 11:45:41 -0700 (PDT)
Message-ID: <557C7A53.3080002@gmail.com> (sfid-20150613_204545_454641_ADDA99B7)
Date: Sat, 13 Jun 2015 20:45:39 +0200
From: Arend van Spriel <aspriel@gmail.com>
MIME-Version: 1.0
To: Luca Coelho <luca@coelho.fi>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH py80211 4/4] py80211: scan: add matchsets support for
 scheduled scans
References: <1434117644-3033-1-git-send-email-luca@coelho.fi> <1434117644-3033-5-git-send-email-luca@coelho.fi>
In-Reply-To: <1434117644-3033-5-git-send-email-luca@coelho.fi>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 12-06-15 16:00, Luca Coelho wrote:
> From: Luciano Coelho <luciano.coelho@intel.com>
> 
> Modify the sched_scan_start class so that the caller can pass a list
> of matches to be used in the scheduled scan request.
> 
> Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>

Merged in master branch after indentation cleanup.

Regards,
Arend

> ---
>  lib/scan.py | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/lib/scan.py b/lib/scan.py
> index bfaf3d2..b55d148 100644
> --- a/lib/scan.py
> +++ b/lib/scan.py
> @@ -192,10 +192,34 @@ class sched_scan_start(scan_start_base):
>  	def __init__(self, ifidx, level=nl.NL_CB_DEFAULT):
>                  super(sched_scan_start, self).__init__(ifidx, level)
>                  self._nl_cmd = nl80211.CMD_START_SCHED_SCAN
> +                self._matches = None
>  
>  	def set_interval(self, interval):
>  		self._interval = interval
>  
> +        def add_matches(self, matches):
> +                self._matches = matches
> +
> +        def _add_matches_attrs(self):
> +		if self._matches:
> +			i = 0
> +
> +                        matchset = nl.nla_nest_start(self._nl_msg._msg, nl80211.ATTR_SCHED_SCAN_MATCH)
> +			for match in self._matches:
> +                                nest = nl.nla_nest_start(self._nl_msg._msg, i)
> +                                if 'ssid' in match:
> +                                        nl.nla_put(self._nl_msg._msg, nl80211.SCHED_SCAN_MATCH_ATTR_SSID, match['ssid'])
> +				i += 1
> +                                nl.nla_nest_end(self._nl_msg._msg, nest)
> +
> +                        nl.nla_nest_end(self._nl_msg._msg, matchset)
> +
> +        def send(self):
> +                self._prepare_cmd()
> +                self._add_scan_attrs()
> +                self._add_matches_attrs()
> +                self._send_and_wait()
> +
>          def handle(self, msg, arg):
>  		genlh = genl.genlmsg_hdr(nl.nlmsg_hdr(msg))
>  
> 
