Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:32797 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802AbbFMSph (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Jun 2015 14:45:37 -0400
Received: by wgez8 with SMTP id z8so42774675wge.0
        for <linux-wireless@vger.kernel.org>; Sat, 13 Jun 2015 11:45:36 -0700 (PDT)
Message-ID: <557C7A4E.9030008@gmail.com> (sfid-20150613_204540_105106_DF711CAC)
Date: Sat, 13 Jun 2015 20:45:34 +0200
From: Arend van Spriel <aspriel@gmail.com>
MIME-Version: 1.0
To: Luca Coelho <luca@coelho.fi>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH py80211 3/4] py80211: add sched_scan stop class
References: <1434117644-3033-1-git-send-email-luca@coelho.fi> <1434117644-3033-4-git-send-email-luca@coelho.fi>
In-Reply-To: <1434117644-3033-4-git-send-email-luca@coelho.fi>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 12-06-15 16:00, Luca Coelho wrote:
> From: Luciano Coelho <luciano.coelho@intel.com>
> 
> Add a class to stop scheduled scans.
> 
> Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>

Merged in master branch after indentation cleanup.

Regards,
Arend

> ---
>  lib/scan.py | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/lib/scan.py b/lib/scan.py
> index bfaf4da..bfaf3d2 100644
> --- a/lib/scan.py
> +++ b/lib/scan.py
> @@ -203,3 +203,18 @@ class sched_scan_start(scan_start_base):
>                  if genlh.cmd in [ nl80211.CMD_START_SCHED_SCAN ]:
>                          self.scan_busy = False
>  		return nl.NL_SKIP
> +
> +class sched_scan_stop(scan_cmd_base):
> +	def __init__(self, ifidx, level=nl.NL_CB_DEFAULT):
> +                super(sched_scan_stop, self).__init__(ifidx, level)
> +                self._nl_cmd = nl80211.CMD_STOP_SCHED_SCAN
> +
> +        def send(self):
> +                self._prepare_cmd()
> +                self._send_and_wait()
> +
> +        def handle(self, msg, arg):
> +		genlh = genl.genlmsg_hdr(nl.nlmsg_hdr(msg))
> +                if genlh.cmd in [ nl80211.CMD_SCHED_SCAN_STOPPED ]:
> +                        self.scan_busy = False
> +		return nl.NL_SKIP
> 
