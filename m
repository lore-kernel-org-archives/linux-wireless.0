Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:26827 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757591AbZJaBuv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Oct 2009 21:50:51 -0400
Received: by fg-out-1718.google.com with SMTP id d23so70987fga.1
        for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2009 18:50:55 -0700 (PDT)
Subject: Incorrect signal levels reported using wpa_supplicant's
 driver_nl80211
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: "hostap@lists.shmoo.com" <hostap@lists.shmoo.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	networkmanager-list <networkmanager-list@gnome.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 31 Oct 2009 03:50:37 +0200
Message-ID: <1256953837.9681.13.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sorry for cross-posting, but this issue really spans all three systems.

I anylized why I get 100% quality on all access points except currently
connected, when I used driver_nl80211 of wpa_supplcant.

First, when NetworkManager plans to switch to this driver?
For me it gives me faster association speeds, especially when I toggle
wireless with rfkill button.


this is what happens on the kernel side:
--> n80211 encodes only dBm data. It does so in, nl80211_send_bss.
	(or it can encode unspecified data, which has little use...)

--> kernel also gives maximum ranges in, cfg80211_wext_giwrange, which is used by NM:
	range->max_qual.updated = IW_QUAL_NOISE_INVALID | IW_QUAL_DBM | IW_QUAL_QUAL_UPDATED | IW_QUAL_LEVEL_UPDATED ;
	range->max_qual.level = -110;
	range->max_qual.qual = 70;
Thus it reports that it can't report noise.


driver_nl80211 side:

--> sends data as is, done in bss_info_handler:
	r->level = nla_get_u32(bss[NL80211_BSS_SIGNAL_MBM]);
	r->level /= 100; /* mBm to dBm */
	r->flags |= WPA_SCAN_LEVEL_DBM | WPA_SCAN_QUAL_INVALID;

Again explicitly says that has no quality data, sends only dBm or unspecified data;



NM side:

--> three strategies used (in wireless_qual_to_percent)
	--> quality: (used with driver_wext), not reported by nl80211

	--> dbm: used only if:
		* valid and zero max_qual->level (but now set to -110....) 
		* valid level (OK)
		* valid positive max_qual->noise OR valid positive current noise (noise set to invalid and not reported even by my driver...)

	--> RSSI: (device reports numbers from 0 to max_qual.level):
		* nonzero valid max_qual->level, and it is assumed to be positive too...
		* valid level
		

currently RSSI path is taken and results in 100% quality.


I think that dBm strategy should be revised, and in addtion to that.

Of course whole NM currently depends on WEXT, for exmple it would get signal level for current AP via WEXT, and thus use quality level
as reported by driver. 

Thus there are differences between NM dBm quality calculation and driver ones, and therefore NM will report different quality levels... sigh...


Best regards,
	Maxim Levitsky


PS: I want signal quality bars back in NM....

