Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:65220 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbZELXK3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 May 2009 19:10:29 -0400
Received: by ewy24 with SMTP id 24so392512ewy.37
        for <linux-wireless@vger.kernel.org>; Tue, 12 May 2009 16:10:29 -0700 (PDT)
Subject: Re: [BUG] scans can still hang with -EBUSY on iwl3945
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: reinette chatre <reinette.chatre@intel.com>,
	iwlwifi maling list <ipw3945-devel@lists.sourceforge.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1242161643.26484.2.camel@maxim-laptop>
References: <1241179203.8086.3.camel@maxim-laptop>
	 <1241193513.10498.97.camel@rc-desk> <1241208792.7082.47.camel@maxim-laptop>
	 <1241227946.5192.3.camel@maxim-laptop>
	 <1241374060.13562.37.camel@johannes.local>
	 <1241387163.10486.6.camel@maxim-laptop>
	 <1241421545.6866.2.camel@johannes.local>
	 <1242161643.26484.2.camel@maxim-laptop>
Content-Type: text/plain
Date: Wed, 13 May 2009 02:10:24 +0300
Message-Id: <1242169824.5146.31.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-05-12 at 23:54 +0300, Maxim Levitsky wrote:
> On Mon, 2009-05-04 at 09:19 +0200, Johannes Berg wrote:
> > On Mon, 2009-05-04 at 00:46 +0300, Maxim Levitsky wrote:
> > > Yes, sure
> > > For record I use iwlwifi.git commit
> > > 5a94b6d38100b7056a5a347e5c51359d924d305d
> > 
> > Ok.
> > 
> > > Logs attached.
> > > This bug can be reliably reproduced, happens every 5~10 times when I
> > > turn rfkill on/off, but today again this happened after resume from
> > > disk.
> > 
> > Ah, rfkill. Hmm, unfortunately I don't have a system with rfkill. I
> > looked at ieee80211_scan_work but can't see how it would abort the
> > scan... Could you put some debugging into that function? Especially
> > printing out the state when it enters, whether it calls
> 
> Hi,
> 
> I can't seem to reproduce that ether.
> Maybe this got fixed (I have seen few suspicios commits in
> wireless-testing... althought I think this is a wishfull thinking)
> 
> Anyway, I I have put printks in ieee80211_scan_work.

Ahaa!
Look at that:


> May 13 01:44:33 maxim-laptop kernel: [ 1093.991176] iwl3945 0000:06:00.0: Radio Frequency Kill Switch is On:
^^^^^^^^^^ Kernel notices the rfkill state
> May 13 01:44:33 maxim-laptop kernel: [ 1093.991179] Kill switch must be turned off for wireless networking to work.
> May 13 01:44:35 maxim-laptop kernel: [ 1095.789455]  ieee80211_ioctl_siwessid: called
^^^^^^^^^^ Evil NM notices Rfkill too, and sends bogus bssid to driver
> May 13 01:44:35 maxim-laptop kernel: [ 1095.789462] ieee80211_sta_req_auth: called
> May 13 01:44:35 maxim-laptop kernel: [ 1095.789498] iwl3945 0000:06:00.0: Error sending REPLY_LEDS_CMD: enqueue_hcmd failed: -5
> May 13 01:44:35 maxim-laptop kernel: [ 1095.789530] iwl3945 0000:06:00.0: Error sending REPLY_RXON: enqueue_hcmd failed: -5
> May 13 01:44:35 maxim-laptop kernel: [ 1095.789536] iwl3945 0000:06:00.0: Error clearing ASSOC_MSK on current configuration (-5).
> May 13 01:44:35 maxim-laptop kernel: [ 1095.870202] iwl3945 0000:06:00.0: Error sending REPLY_RXON: enqueue_hcmd failed: -5
> May 13 01:44:35 maxim-laptop kernel: [ 1095.870210] iwl3945 0000:06:00.0: Error clearing ASSOC_MSK on current configuration (-5).
> May 13 01:44:35 maxim-laptop kernel: [ 1095.870223] iwl3945 0000:06:00.0: Error sending REPLY_RXON: enqueue_hcmd failed: -5
> May 13 01:44:35 maxim-laptop kernel: [ 1095.870227] iwl3945 0000:06:00.0: Error clearing ASSOC_MSK on current configuration (-5).
> May 13 01:44:35 maxim-laptop kernel: [ 1095.870234] wlan0: direct probe to AP 00:0e:2e:a4:12:3e try 1
> May 13 01:44:35 maxim-laptop kernel: [ 1095.960876] cfg80211: scan requested
^^^^^^^^^^^ This results in a scan
> May 13 01:44:35 maxim-laptop kernel: [ 1095.960884] __ieee80211_start_scan: scan requested
> May 13 01:44:35 maxim-laptop kernel: [ 1096.042972] wlan0: deauthenticating by local choice (reason=3)
^^^^^^^^^^^ And deauth....
> May 13 01:44:35 maxim-laptop kernel: [ 1096.331307] ieee80211_ioctl_siwap: called
^^^^^^^^^^^ And NM sets ESSID on top of that....
> May 13 01:44:35 maxim-laptop kernel: [ 1096.331310] ieee80211_sta_req_auth: called
> 

Now I press rfkill again, but scan is hung
> 
> May 13 01:44:48 maxim-laptop kernel: [ 1108.639995] Registered led device: iwl-phy0::radio
> May 13 01:44:48 maxim-laptop kernel: [ 1108.640060] Registered led device: iwl-phy0::assoc
> May 13 01:44:48 maxim-laptop kernel: [ 1108.640093] Registered led device: iwl-phy0::RX
> May 13 01:44:48 maxim-laptop kernel: [ 1108.640124] Registered led device: iwl-phy0::TX
> May 13 01:44:48 maxim-laptop kernel: [ 1108.729516] wlan0: direct probe to AP 00:0e:2e:a4:12:3e try 1
> May 13 01:44:48 maxim-laptop kernel: [ 1108.733695] wlan0 direct probe responded
> May 13 01:44:48 maxim-laptop kernel: [ 1108.733704] wlan0: authenticate with AP 00:0e:2e:a4:12:3e
> May 13 01:44:48 maxim-laptop kernel: [ 1108.735529] wlan0: authenticated
> May 13 01:44:48 maxim-laptop kernel: [ 1108.735535] wlan0: associate with AP 00:0e:2e:a4:12:3e
> May 13 01:44:48 maxim-laptop kernel: [ 1108.737684] wlan0: RX AssocResp from 00:0e:2e:a4:12:3e (capab=0x401 status=1 aid=2)
> May 13 01:44:48 maxim-laptop kernel: [ 1108.737690] wlan0: AP denied association (code=1)
> May 13 01:44:48 maxim-laptop kernel: [ 1108.808376] cfg80211: scan requested
> May 13 01:44:48 maxim-laptop kernel: [ 1108.808383] cfg80211: can't scan, already scanning
> May 13 01:44:48 maxim-laptop kernel: [ 1108.932614] wlan0: associate with AP 00:0e:2e:a4:12:3e
> May 13 01:44:48 maxim-laptop kernel: [ 1108.934760] wlan0: RX AssocResp from 00:0e:2e:a4:12:3e (capab=0x401 status=1 aid=2)
> May 13 01:44:48 maxim-laptop kernel: [ 1108.934767] wlan0: AP denied association (code=1)
> May 13 01:44:48 maxim-laptop kernel: [ 1109.130125] wlan0: associate with AP 00:0e:2e:a4:12:3e
> May 13 01:44:48 maxim-laptop kernel: [ 1109.132231] wlan0: RX AssocResp from 00:0e:2e:a4:12:3e (capab=0x401 status=1 aid=2)
> May 13 01:44:48 maxim-laptop kernel: [ 1109.132237] wlan0: AP denied association (code=1)
> May 13 01:44:48 maxim-laptop kernel: [ 1109.332611] wlan0: association with AP 00:0e:2e:a4:12:3e timed out
> May 13 01:45:08 maxim-laptop kernel: [ 1128.585712] cfg80211: scan requested
> May 13 01:45:08 maxim-laptop kernel: [ 1128.585719] cfg80211: can't scan, already scanning
> 
> 
So it looks like a race between setting the essid, when in rfkill

Yes, it is, very easy to reproduce.
Just press rfkill to turn radio off, then 'iwconfig wlan0 essid zzzz'

Which is very wrong btw, NM shouldn't touch bssid/essid, as wpa_supplicant already does that for wext, and doesn't 
(there is no need for nl80211)


Best regards,
	Maxim Levitsky

