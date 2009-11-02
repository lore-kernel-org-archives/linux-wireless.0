Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1454 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756760AbZKBTk6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2009 14:40:58 -0500
Subject: Re: Incorrect signal levels reported using wpa_supplicant's
 driver_nl80211
From: Dan Williams <dcbw@redhat.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: "hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	networkmanager-list <networkmanager-list@gnome.org>
In-Reply-To: <1256953837.9681.13.camel@maxim-laptop>
References: <1256953837.9681.13.camel@maxim-laptop>
Content-Type: text/plain
Date: Mon, 02 Nov 2009 11:40:33 -0800
Message-Id: <1257190833.1027.4.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2009-10-31 at 03:50 +0200, Maxim Levitsky wrote:
> Sorry for cross-posting, but this issue really spans all three systems.
> 
> I anylized why I get 100% quality on all access points except currently
> connected, when I used driver_nl80211 of wpa_supplcant.
> 
> First, when NetworkManager plans to switch to this driver?

Soon.  We've got some patches for this, but we'll also need tons of
testing.  The WEXT stuff is pretty baked while nl80211 is still under
some flux.  But of course the only way we bake nl80211 is by switching
to it...

> For me it gives me faster association speeds, especially when I toggle
> wireless with rfkill button.
> 
> 
> this is what happens on the kernel side:
> --> n80211 encodes only dBm data. It does so in, nl80211_send_bss.
> 	(or it can encode unspecified data, which has little use...)
> 
> --> kernel also gives maximum ranges in, cfg80211_wext_giwrange, which is used by NM:
> 	range->max_qual.updated = IW_QUAL_NOISE_INVALID | IW_QUAL_DBM | IW_QUAL_QUAL_UPDATED | IW_QUAL_LEVEL_UPDATED ;
> 	range->max_qual.level = -110;
> 	range->max_qual.qual = 70;
> Thus it reports that it can't report noise.
> 
> 
> driver_nl80211 side:
> 
> --> sends data as is, done in bss_info_handler:
> 	r->level = nla_get_u32(bss[NL80211_BSS_SIGNAL_MBM]);
> 	r->level /= 100; /* mBm to dBm */
> 	r->flags |= WPA_SCAN_LEVEL_DBM | WPA_SCAN_QUAL_INVALID;
> 
> Again explicitly says that has no quality data, sends only dBm or unspecified data;
> 
> 
> 
> NM side:
> 
> --> three strategies used (in wireless_qual_to_percent)
> 	--> quality: (used with driver_wext), not reported by nl80211
> 
> 	--> dbm: used only if:
> 		* valid and zero max_qual->level (but now set to -110....) 

IIRC non-zero max_qual->level was the indication that the driver wanted
to use RSSI, not dBm.  Since the real "max" dBm is around 0 (ie, that's
the highest signal strength you'll ever really see), max_qual->level
meant the driver was reporting signal strength in dBm.  max_qual->level
== -110 is kinda wrong, because that's the _minimum_ level, not the max.
The noise floor is almost always around -100 dBm so setting
max_qual->level is pretty useless.

This is *exactly* why 'qual' is there: so that the driver itself can
figure out what the hell it's signal level is, and so that NM doesn't
have to go around assuming stuff.

For WEXT reporting, mac80211 should really be constructing a 'qual'
instead of leaving it 0.  Then we don't have ambiguities with dBm, RSSI,
unspec, etc.

Dan

> 		* valid level (OK)
> 		* valid positive max_qual->noise OR valid positive current noise (noise set to invalid and not reported even by my driver...)
> 
> 	--> RSSI: (device reports numbers from 0 to max_qual.level):
> 		* nonzero valid max_qual->level, and it is assumed to be positive too...
> 		* valid level
> 		
> 
> currently RSSI path is taken and results in 100% quality.
> 
> 
> I think that dBm strategy should be revised, and in addtion to that.
> 
> Of course whole NM currently depends on WEXT, for exmple it would get signal level for current AP via WEXT, and thus use quality level
> as reported by driver. 
> 
> Thus there are differences between NM dBm quality calculation and driver ones, and therefore NM will report different quality levels... sigh...
> 
> 
> Best regards,
> 	Maxim Levitsky
> 
> 
> PS: I want signal quality bars back in NM....
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

