Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:34388 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbbFMSkb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Jun 2015 14:40:31 -0400
Received: by wibut5 with SMTP id ut5so42410761wib.1
        for <linux-wireless@vger.kernel.org>; Sat, 13 Jun 2015 11:40:30 -0700 (PDT)
Message-ID: <557C791C.5070900@gmail.com> (sfid-20150613_204036_042028_ADEA614F)
Date: Sat, 13 Jun 2015 20:40:28 +0200
From: Arend van Spriel <aspriel@gmail.com>
MIME-Version: 1.0
To: Luca Coelho <luca@coelho.fi>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH py80211 1/4] py80211: scan: spin base scan classes off
 scan_request
References: <1434117644-3033-1-git-send-email-luca@coelho.fi> <1434117644-3033-2-git-send-email-luca@coelho.fi>
In-Reply-To: <1434117644-3033-2-git-send-email-luca@coelho.fi>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12-06-15 16:00, Luca Coelho wrote:
> From: Luciano Coelho <luciano.coelho@intel.com>
> 
> Most of the scan_request code can be reused for scheduled scan, so
> spin the common part off the regular scan class.
> 
> Additionally, add one extra class that is able to send scan commands
> (for sched_scan stop, for instance) without adding any scan
> attributes.
> 
> Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>

Added to the master branch with following modifications:

    [aspriel@gmail.com: fixed indentation]
    [aspriel@gmail.com: remove redundant initialization]

> ---
>  lib/scan.py | 106 ++++++++++++++++++++++++++++++++++++------------------------
>  1 file changed, 64 insertions(+), 42 deletions(-)
> 
> diff --git a/lib/scan.py b/lib/scan.py
> index 491c0b7..5ccae55 100644
> --- a/lib/scan.py
> +++ b/lib/scan.py
> @@ -84,14 +84,65 @@ class bss_list(custom_handler):
>  			traceback.print_tb(tb)
>  		return nl.NL_SKIP
>  
> -class scan_request(custom_handler):
> +class scan_cmd_base(custom_handler):
>  	def __init__(self, ifidx, level=nl.NL_CB_DEFAULT):
> -		self._ifidx = ifidx
>  		self._access = access80211(level)
> +                self._nl_cmd = None
> +		self._ifidx = ifidx
> +
> +	def _wait_for_completion(self):
> +		while self.scan_busy:
> +			self._access._sock.recvmsgs(self._access._rx_cb)
> +
> +	def _prepare_cmd(self):
> +                if self._nl_cmd == None:
> +                        raise Exception("sub-class must set _nl_cmd")
> +
> +		flags = nlc.NLM_F_REQUEST | nlc.NLM_F_ACK
> +		self._nl_msg = self._access.alloc_genlmsg(self._nl_cmd, flags)
> +		nl.nla_put_u32(self._nl_msg._msg, nl80211.ATTR_IFINDEX, self._ifidx)
> +
> +        def _send_and_wait(self):
> +		self.scan_busy = True
> +		self._access.disable_seq_check()
> +		mcid = self._access.subscribe_multicast('scan')
> +		ret = self._access.send(self._nl_msg, self)
> +		if ret < 0:
> +			self.scan_busy = False
> +			return ret
> +
> +		self._wait_for_completion()
> +		self._access.drop_multicast(mcid)
> +		return 0
> +
> +class scan_start_base(scan_cmd_base):
> +        def __init__(self, ifidx, level=nl.NL_CB_DEFAULT):
> +                super(scan_start_base, self).__init__(ifidx, level)
>  		self._ssids = None
>  		self._freqs = None
>  		self._flags = 0
>  		self._ies = None
> +                self._nl_cmd = None

This initialization of _nl_cmd is redundant and thus removed.

> +
> +        def _add_scan_attrs(self):
> +		if self._ssids:
> +			i = 0
> +			nest = nl.nla_nest_start(self._nl_msg._msg, nl80211.ATTR_SCAN_SSIDS)
> +			for ssid in self._ssids:
> +				nl.nla_put(self._nl_msg._msg, i, ssid)
> +				i += 1
> +			nl.nla_nest_end(self._nl_msg._msg, nest)
> +		if self._freqs:
> +			i = 0
> +			nest = nl.nla_nest_start(self._nl_msg._msg, nl80211.ATTR_SCAN_FREQUENCIES)
> +			for freq in self._freqs:
> +				nl.nla_put_u32(self._nl_msg._msg, i, freq)
> +				i += 1
> +			nl.nla_nest_end(self._nl_msg._msg, nest)
> +		if self._flags != 0:
> +			nl.nla_put_u32(self._nl_msg._msg, nl80211.ATTR_SCAN_FLAGS, self._flags)
> +		if self._ies:
> +			nl.nla_put(self._nl_msg._msg, nl80211.ATTR_IE, self._ies)
>  
>  	def add_ssids(self, ssids):
>  		if self._ssids == None:
> @@ -115,49 +166,20 @@ class scan_request(custom_handler):
>  	def set_flags(self, flags):
>  		self._flags = flags
>  
> -	def wait_for_scan_completion(self):
> -		while self.scan_busy:
> -			self._access._sock.recvmsgs(self._access._rx_cb)
> -
> -	def send(self):
> -		flags = nlc.NLM_F_REQUEST | nlc.NLM_F_ACK
> -		m = self._access.alloc_genlmsg(nl80211.CMD_TRIGGER_SCAN, flags)
> -		nl.nla_put_u32(m._msg, nl80211.ATTR_IFINDEX, self._ifidx)
> +        def send(self):
> +                self._prepare_cmd()
> +                self._add_scan_attrs()
> +                self._send_and_wait()
>  
> -		if self._ssids:
> -			i = 0
> -			nest = nl.nla_nest_start(m._msg, nl80211.ATTR_SCAN_SSIDS)
> -			for ssid in self._ssids:
> -				nl.nla_put(m._msg, i, ssid)
> -				i += 1
> -			nl.nla_nest_end(m._msg, nest)
> -		if self._freqs:
> -			i = 0
> -			nest = nl.nla_nest_start(m._msg, nl80211.ATTR_SCAN_FREQUENCIES)
> -			for freq in self._freqs:
> -				nl.nla_put_u32(m._msg, i, freq)
> -				i += 1
> -			nl.nla_nest_end(m._msg, nest)
> -		if self._flags != 0:
> -			nl.nla_put_u32(m._msg, nl80211.ATTR_SCAN_FLAGS, self._flags)
> -		if self._ies:
> -			nl.nla_put(m._msg, nl80211.ATTR_IE, self._ies)
> -
> -		self.scan_busy = True
> -		self._access.disable_seq_check()
> -		mcid = self._access.subscribe_multicast('scan')
> -		ret = self._access.send(m, self)
> -		if ret < 0:
> -			self.scan_busy = False
> -			return ret
> -
> -		self.wait_for_scan_completion()
> -		self._access.drop_multicast(mcid)
> -		return 0
> +class scan_request(scan_start_base):
> +	def __init__(self, ifidx, level=nl.NL_CB_DEFAULT):
> +                super(scan_request, self).__init__(ifidx, level)
> +                self._nl_cmd = nl80211.CMD_TRIGGER_SCAN
>  
> -	def handle(self, msg, arg):
> +        def handle(self, msg, arg):
>  		genlh = genl.genlmsg_hdr(nl.nlmsg_hdr(msg))
> +
> +                # A regular scan is complete when we get scan results
>  		if genlh.cmd in [ nl80211.CMD_SCAN_ABORTED, nl80211.CMD_NEW_SCAN_RESULTS ]:
>  			self.scan_busy = False
>  		return nl.NL_SKIP
> -
> 
