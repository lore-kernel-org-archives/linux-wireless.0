Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:31924 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752008AbZENVHo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 May 2009 17:07:44 -0400
Subject: Re: [BUG] scans can still hang with -EBUSY on iwl3945
From: reinette chatre <reinette.chatre@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
	iwlwifi maling list <ipw3945-devel@lists.sourceforge.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1242169934.14227.16.camel@johannes.local>
References: <1241179203.8086.3.camel@maxim-laptop>
	 <1241193513.10498.97.camel@rc-desk> <1241208792.7082.47.camel@maxim-laptop>
	 <1241227946.5192.3.camel@maxim-laptop>
	 <1241374060.13562.37.camel@johannes.local>
	 <1241387163.10486.6.camel@maxim-laptop>
	 <1241421545.6866.2.camel@johannes.local>
	 <1242161643.26484.2.camel@maxim-laptop>
	 <1242169824.5146.31.camel@maxim-laptop>
	 <1242169934.14227.16.camel@johannes.local>
Content-Type: text/plain
Date: Thu, 14 May 2009 14:14:18 -0700
Message-Id: <1242335658.32358.112.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-05-12 at 16:12 -0700, Johannes Berg wrote:
> On Wed, 2009-05-13 at 02:10 +0300, Maxim Levitsky wrote:
> 
> > > May 13 01:44:33 maxim-laptop kernel: [ 1093.991176] iwl3945 0000:06:00.0: Radio Frequency Kill Switch is On:
> > ^^^^^^^^^^ Kernel notices the rfkill state
> > > May 13 01:44:33 maxim-laptop kernel: [ 1093.991179] Kill switch must be turned off for wireless networking to work.
> > > May 13 01:44:35 maxim-laptop kernel: [ 1095.789455]  ieee80211_ioctl_siwessid: called
> > ^^^^^^^^^^ Evil NM notices Rfkill too, and sends bogus bssid to driver
> > > May 13 01:44:35 maxim-laptop kernel: [ 1095.789462] ieee80211_sta_req_auth: called
> > > May 13 01:44:35 maxim-laptop kernel: [ 1095.789498] iwl3945 0000:06:00.0: Error sending REPLY_LEDS_CMD: enqueue_hcmd failed: -5
> > > May 13 01:44:35 maxim-laptop kernel: [ 1095.789530] iwl3945 0000:06:00.0: Error sending REPLY_RXON: enqueue_hcmd failed: -5
> > > May 13 01:44:35 maxim-laptop kernel: [ 1095.789536] iwl3945 0000:06:00.0: Error clearing ASSOC_MSK on current configuration (-5).
> > > May 13 01:44:35 maxim-laptop kernel: [ 1095.870202] iwl3945 0000:06:00.0: Error sending REPLY_RXON: enqueue_hcmd failed: -5
> > > May 13 01:44:35 maxim-laptop kernel: [ 1095.870210] iwl3945 0000:06:00.0: Error clearing ASSOC_MSK on current configuration (-5).
> > > May 13 01:44:35 maxim-laptop kernel: [ 1095.870223] iwl3945 0000:06:00.0: Error sending REPLY_RXON: enqueue_hcmd failed: -5
> > > May 13 01:44:35 maxim-laptop kernel: [ 1095.870227] iwl3945 0000:06:00.0: Error clearing ASSOC_MSK on current configuration (-5).
> > > May 13 01:44:35 maxim-laptop kernel: [ 1095.870234] wlan0: direct probe to AP 00:0e:2e:a4:12:3e try 1
> > > May 13 01:44:35 maxim-laptop kernel: [ 1095.960876] cfg80211: scan requested
> > ^^^^^^^^^^^ This results in a scan
> > > May 13 01:44:35 maxim-laptop kernel: [ 1095.960884] __ieee80211_start_scan: scan requested
> > > May 13 01:44:35 maxim-laptop kernel: [ 1096.042972] wlan0: deauthenticating by local choice (reason=3)
> > ^^^^^^^^^^^ And deauth....
> > > May 13 01:44:35 maxim-laptop kernel: [ 1096.331307] ieee80211_ioctl_siwap: called
> > ^^^^^^^^^^^ And NM sets ESSID on top of that....
> > > May 13 01:44:35 maxim-laptop kernel: [ 1096.331310] ieee80211_sta_req_auth: called
> > > 
> > 
> > Now I press rfkill again, but scan is hung
> 
> So it's a bug in iwlwifi, it neither rejects nor executes a scan when in
> rfkill.

I am not convinced. When mac80211 requests a scan from the driver
checking if rfkill is enabled is the first thing it does and it will
return an error in this case. See iwl_mac_hw_scan().

Maxim, please ensure your driver is compiled with debug support
(CONFIG_IWLWIFI_DEBUG) and load the driver with debug=0x2. We should see
debug messages that will guide us here.

Reinette


