Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965200Ab2CPPIT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Mar 2012 11:08:19 -0400
Date: Fri, 16 Mar 2012 15:37:31 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] iwlwifi: do not nulify ctx->vif on reset
Message-ID: <20120316143730.GA11278@redhat.com> (sfid-20120316_160823_174889_ADCD3B3D)
References: <1331651434-4370-1-git-send-email-sgruszka@redhat.com>
 <1331651730.3329.6.camel@jlt3.sipsolutions.net>
 <20120314062549.GA2788@redhat.com>
 <1331708304.3376.0.camel@jlt3.sipsolutions.net>
 <20120314070748.GB2788@redhat.com>
 <20120314081424.GC2788@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120314081424.GC2788@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 14, 2012 at 09:14:24AM +0100, Stanislaw Gruszka wrote:
> On Wed, Mar 14, 2012 at 08:07:48AM +0100, Stanislaw Gruszka wrote:
> > I'll update and recheck again.
> 
> On updated tree (head 035364916f75151b4b91ea53968c6beba7545317) devices
> stop working here on any forced reset during TX as well. There are
> messages like below in dmesg:
> 
> wlan3: dropped data frame to not associated station 00:00:00:00:00:00
> 
> And one time crash happened too, in:
> 
> (gdb) l *(iwl_remove_dynamic_key+0x1f0)
> 0x15e20 is in iwl_remove_dynamic_key (drivers/net/wireless/iwlwifi/iwl-agn-sta.c:1105).
> 1100		/*
> 1101		 * The device expects GTKs for station interfaces to be
> 1102		 * installed as GTKs for the AP station. If we have no
> 1103		 * station ID, then use the ap_sta_id in that case.
> 1104		 */
> 1105		if (vif->type == NL80211_IFTYPE_STATION && vif_priv->ctx)
> 1106			return vif_priv->ctx->ap_sta_id;
> 1107	
> 1108		return IWL_INVALID_STATION;
> 1109	}
> 
> To reproduce problems, I'm doing "ping -f 192.168.1.1" on one console
> and run script [1] on other console.

So what we do here? Patch fix possible crash on firmware restart.
We have a few places where ctx->vif is dereferences without a NULL
check. Perhaps those places should be verified instead. What protects
to dereference ctx->vif after iwl_mac_remove_interface() ?

Regarding restart, this apparently is broken - hung the adapter such the
module reload is needed. To mitigate the problems You just disable
watchdog on various adapters.

I do not think restart should be fixed. I think better would be disable
restart by default (set fw_restart=0) and start to solve real problems :-)

This is of course not easy, but perhaps could be done using tracing. It
offer a nice feature that allow to enable and disable logging on
runtime, (tracing_on(), tracing_off() functions). So offer a compile
option to make IWL_DEBUG use trace_printk(), start tracing on module
load, disable it on microcode error or queue stuck. All of that should
help with debugging inimitable problems, as ftrace log data into memory
and use ring buffer, hence allow to see (lot of) latest actions before
the problem occurs. I could write the patches, but since you are
constantly refactoring the iwlwifi driver better if you will do this.
How about that?

Stanislaw

