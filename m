Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.191]:43507 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255AbXL0TIY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Dec 2007 14:08:24 -0500
Received: by fk-out-0910.google.com with SMTP id z23so3462545fkz.5
        for <linux-wireless@vger.kernel.org>; Thu, 27 Dec 2007 11:08:22 -0800 (PST)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC v2] mac80211: add unified BSS configuration
Date: Thu, 27 Dec 2007 20:08:31 +0100
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Buesch <mb@bu3sch.de>,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Daniel Drake <dsd@gentoo.org>,
	Michael Wu <flamingice@sourmilk.net>
References: <1198700024.4103.71.camel@johannes.berg>
In-Reply-To: <1198700024.4103.71.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200712272008.32931.IvDoorn@gmail.com> (sfid-20071227_190829_082012_EF8ED681)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 26 December 2007, Johannes Berg wrote:
> This patch (based on Ron Rindjunsky's) creates a framework for
> a unified way to pass BSS configuration to drivers that require
> the information, e.g. for implementing power save mode.
> 
> A new ieee80211_bss_conf structure is embedded into each virtual
> interface structure to allow the driver to access the BSS
> configuration at any time, changes in the structure are passed
> to the driver via the new bss_info_changed() callback.
> 
> This new BSS configuration infrastructure adds the following
> new features:
>  * drivers are notified of their association AID
>  * drivers are notified of association status
> 
> and replaces the erp_ie_changed() callback. The patch also does
> the relevant driver updates for the latter change.
> 
> Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
> Before merging this needs to be amended by the correct rt2x00 change.
> Ivo, I can simply create a bss_conf structure there on the stack and
> hand that to the function, would that be an ok interim solution for you?

I couldn't apply your previous patch cleanly against latest wireless-dev. :S
Anyway, I looked into the patch and I think your fixme can be replaced with
a simple

rt2x00mac_bss_info_changed(rt2x00dev->hw,
						rt2x00dev->interface.vif,
						BSS_CHANGED_ERP_PREAMBLE);

That will make sure the behavior is the same as before, and I can implement
the  "assoc" boolean test later when this patch is merged.

> --- everything.orig/drivers/net/wireless/rt2x00/rt2x00dev.c	2007-12-23 10:41:46.025363388 +0100
> +++ everything/drivers/net/wireless/rt2x00/rt2x00dev.c	2007-12-23 11:29:14.125396538 +0100
> @@ -437,8 +437,10 @@ static void rt2x00lib_configuration_sche
>  	    container_of(work, struct rt2x00_dev, config_work);
>  	int preamble = !test_bit(CONFIG_SHORT_PREAMBLE, &rt2x00dev->flags);
>  
> -	rt2x00mac_erp_ie_changed(rt2x00dev->hw,
> +	/* !!FIXME FIXME FIXME!!
> +	rt2x00mac_bss_info_changed(rt2x00dev->hw,
>  				 IEEE80211_ERP_CHANGE_PREAMBLE, 0, preamble);
> +	*/
>  }

Ivo
