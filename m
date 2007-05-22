Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:55195 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756431AbXEVUjJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 May 2007 16:39:09 -0400
Message-ID: <46534172.5040106@linux.intel.com>
Date: Tue, 22 May 2007 12:16:02 -0700
From: James Ketrenos <jketreno@linux.intel.com>
MIME-Version: 1.0
To: Michael Wu <flamingice@sourmilk.net>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH]  Add iwlwifi wireless drivers
References: <464B7B7C.5080800@linux.intel.com> <200705162151.32910.flamingice@sourmilk.net>
In-Reply-To: <200705162151.32910.flamingice@sourmilk.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Wu wrote:
> On Wednesday 16 May 2007 17:45, James Ketrenos wrote:
>> This patch adds the iwlwifi project directory and sources needed to
>> build the mac80211 based wireless drivers for the Intel PRO/Wireless
>> 3945ABG/BG Network Connection and Intel Wireless WiFi Link AGN adapters.
>>
> Looks much better than when I last checked. A few comments:

I've attempted to address everything not discussed below in the updated code.  That said --

> - Read and set the MAC address before calling ieee80211_register_hw.

We're calling SET_IEEE80211_PERM_ADDR before we call ieee80211_register_hw.  Is there something else we should be doing?

> - mac80211 (very recently) sets up a workqueue for the driver to use so you 
> don't need to create your own anymore.

In addition to the workqueue created when you call ieee80211_register_hw?  We need to have a workqueue for initializing the adapter and uCode before we call ieee80211_register_hw.  If ieee80211_alloc_hw created the workqueue, that would work for us (assuming there aren't going to be any side effects from us flushing the workqueue before we call ieee80211_free_hw/ieee80211_unregister_hw)

That said -- if the driver can execute in parallel to the stack for some operations, shouldn't they remain on their own workqueues so the work can be divided up vs. having *everything* routed through one singlethread workqueue?

> - Why are probe requests being dropped in adhoc mode? (assuming hardware 
> handles it.. but the message output for that doesn't sound like it)

It only drops them if the adapter is not in the associated state (the card is configured with the RXON_FLAG_ASSOC_MSK bit clear)

> - If you don't want to add a radiotap header all the time, you should check 
> the IEEE80211_CONF_RADIOTAP flag to see if a radiotap header is desired by 
> the stack. (not whether or not we're configured as IEEE80211_IF_TYPE_MNTR)

I have this on the todo list.  

Thanks for the time you spent looking over the code.

James

