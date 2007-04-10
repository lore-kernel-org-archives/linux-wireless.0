Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:44907 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965148AbXDJMWT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Apr 2007 08:22:19 -0400
Subject: Re: mac80211 does not support WPA when used with wext
From: Dan Williams <dcbw@redhat.com>
To: dragoran <drago01@gmail.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	John Linville <linville@redhat.com>, Jiri Benc <jbenc@suse.cz>,
	ipw3945-devel@lists.sourceforge.net, jketreno@linux.intel.com
In-Reply-To: <461B3930.6040203@gmail.com>
References: <460E2B8C.4030002@gmail.com>
	 <200703311700.52792.flamingice@sourmilk.net>
	 <f6ca9fed0704081445u5536e596m4ca4caeb44f7f87@mail.gmail.com>
	 <200704081754.24937.flamingice@sourmilk.net>
	 <f6ca9fed0704081527j641a4ecat44151e107cab7342@mail.gmail.com>
	 <461B3930.6040203@gmail.com>
Content-Type: text/plain
Date: Tue, 10 Apr 2007 08:25:33 -0400
Message-Id: <1176207933.15572.11.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2007-04-10 at 09:13 +0200, dragoran wrote:
> ok I tested it again with linvilles f7 test kernel (wireless-git + your 
> patches + iwlwifi).
> again nm detect the card as wpa and it finds the wpa enabled network. 
> But it fails to connect (does not even ask for a key). So I tryed to use 
> wpa_supplicant by hand ( with a config that works fine with ipw3945 ; 
> ieee80211) . Its seems not to be related to iwlwifi but to a ioctl that 
> mac80211 does not support (when used with wext).
> ----
> Own MAC address: 00:18:de:05:f7:9e
> wpa_driver_wext_set_wpa
> wpa_driver_wext_set_key: alg=0 key_idx=0 set_tx=0 seq_len=0 key_len=0
> wpa_driver_wext_set_key: alg=0 key_idx=1 set_tx=0 seq_len=0 key_len=0
> wpa_driver_wext_set_key: alg=0 key_idx=2 set_tx=0 seq_len=0 key_len=0
> wpa_driver_wext_set_key: alg=0 key_idx=3 set_tx=0 seq_len=0 key_len=0
> wpa_driver_wext_set_countermeasures
> ioctl[SIOCSIWAUTH]: Operation not supported
> WEXT auth param 4 value 0x0 - wpa_driver_wext_set_drop_unencrypted
> ioctl[SIOCSIWAUTH]: Operation not supported
> ----
> notice the *ioctl[SIOCSIWAUTH]: Operation not supported* what is 
> SIOCSIWAUTH and how does it not being supproted affect wpa/wext support?

I'm not actually sure these are too much of a problem; some drivers
don't support all options and wpa_supplicant should be able to continue
without it.  Is there any log out put _after_ the pieces you show?

Dan


