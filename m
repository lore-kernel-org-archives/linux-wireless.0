Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:2657 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030457AbXDJHNf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Apr 2007 03:13:35 -0400
Received: by ug-out-1314.google.com with SMTP id 44so20809uga
        for <linux-wireless@vger.kernel.org>; Tue, 10 Apr 2007 00:13:34 -0700 (PDT)
Message-ID: <461B3930.6040203@gmail.com>
Date: Tue, 10 Apr 2007 09:13:52 +0200
From: dragoran <drago01@gmail.com>
MIME-Version: 1.0
To: dragoran dragoran <drago01@gmail.com>
CC: Michael Wu <flamingice@sourmilk.net>,
	Dan Williams <dcbw@redhat.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	John Linville <linville@redhat.com>, Jiri Benc <jbenc@suse.cz>,
	ipw3945-devel@lists.sourceforge.net, jketreno@linux.intel.com
Subject: Re: mac80211 does not support WPA when used with wext
References: <460E2B8C.4030002@gmail.com>	 <200703311700.52792.flamingice@sourmilk.net>	 <f6ca9fed0704081445u5536e596m4ca4caeb44f7f87@mail.gmail.com>	 <200704081754.24937.flamingice@sourmilk.net> <f6ca9fed0704081527j641a4ecat44151e107cab7342@mail.gmail.com>
In-Reply-To: <f6ca9fed0704081527j641a4ecat44151e107cab7342@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ok I tested it again with linvilles f7 test kernel (wireless-git + your 
patches + iwlwifi).
again nm detect the card as wpa and it finds the wpa enabled network. 
But it fails to connect (does not even ask for a key). So I tryed to use 
wpa_supplicant by hand ( with a config that works fine with ipw3945 ; 
ieee80211) . Its seems not to be related to iwlwifi but to a ioctl that 
mac80211 does not support (when used with wext).
----
Own MAC address: 00:18:de:05:f7:9e
wpa_driver_wext_set_wpa
wpa_driver_wext_set_key: alg=0 key_idx=0 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=1 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=2 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=3 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_countermeasures
ioctl[SIOCSIWAUTH]: Operation not supported
WEXT auth param 4 value 0x0 - wpa_driver_wext_set_drop_unencrypted
ioctl[SIOCSIWAUTH]: Operation not supported
----
notice the *ioctl[SIOCSIWAUTH]: Operation not supported* what is 
SIOCSIWAUTH and how does it not being supproted affect wpa/wext support?

