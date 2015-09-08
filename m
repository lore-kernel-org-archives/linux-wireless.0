Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:59291 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751743AbbIHGbc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Sep 2015 02:31:32 -0400
Message-ID: <1441693888.27148.20.camel@coelho.fi> (sfid-20150908_083137_535327_E8A5BAD0)
From: Luca Coelho <luca@coelho.fi>
To: Andreas Reis <andreas.reis@gmail.com>,
	linux-wireless@vger.kernel.org
Cc: "ilw@linux.intel.com" <ilw@linux.intel.com>,
	linuxwifi <linuxwifi@intel.com>
Date: Tue, 08 Sep 2015 09:31:28 +0300
In-Reply-To: <1441690676.27148.11.camel@coelho.fi>
References: <55ED93D0.4070509@gmail.com>
	 <1441690676.27148.11.camel@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: iwlwifi: FW error in SYNC CMD MAC_CONTEXT_CMD
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adding our new list to CC.


On Tue, 2015-09-08 at 08:37 +0300, Luca Coelho wrote:
> Hi Anreas,
> 
> On Mon, 2015-09-07 at 15:40 +0200, Andreas Reis wrote:
> > Updated to
> > net.git: 46cdc9b (ie. with mac80211 2015-09-04)
> > + iwlwifi-next.git commits up to 5bff653
> > iwlwifi firmware: 16.215201.0
> > 
> > now connecting to my WPA-802.1X with a Intel 7260 fails, see dmesg.
> > 
> >  From the wifi's wpa_supplicant file (actually wicd somehow
> > accumulated 
> > different ones for this SSID, but the following should be it):
> >      proto=RSN
> >      key_mgmt=WPA-EAP
> >      pairwise=CCMP
> >      eap=PEAP
> >      phase2="auth=MSCHAPv2"
> > 
> > Meanwhile my WPA2-PSK at home still works.
> 
> According to the dmesg you attached, it seems that we're bouncing
> between two APs:
> 
> [  214.644607] wlp2s0: authenticate with 9c:1c:12:c1:26:82
> ...
> [  214.798595] wlp2s0: deauthenticated from 9c:1c:12:c1:26:82
> (Reason: 3=DEAUTH_LEAVING)
> ...
> [  218.001901] wlp2s0: authenticate with 18:64:72:26:de:22
> ...
> [  218.054498] wlp2s0: deauthenticated from 18:64:72:26:de:22
> (Reason: 3=DEAUTH_LEAVING)
> 
> It seems that your system is trying to connect to two different APs
> forth and back.  After each association succeeds, the userspace seems
> to trigger a deauth (DEAUTH_LEAVING) and goes to the other AP
> again...
> 
> This sometimes indicates that two instances of wpa_supplicant are
> competing with each other.  Can you check whether you have more than
> one wpa_supplicant instance running?
> 
> In any case, there seems to be a driver bug at some point, because we
> get a firmware SYSASSERT.  To debug that, could you follow the
> directions in our debugging wiki page [1] and create a bug in
> bugzilla?
> Please provide trace-cmd logs (as explained in the wiki) so we can
> try
> to figure out what is going on.
> 
> One final question, was this working before you upgraded to iwlwifi
> -next 5bff6536f742?
> 
> Thanks for reporting!
> 
> [1] 
> https://wireless.wiki.kernel.org/en/users/drivers/iwlwifi/debugging
> 
> --
> Cheers,
> Luca.
> --
> To unsubscribe from this list: send the line "unsubscribe linux
> -wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
