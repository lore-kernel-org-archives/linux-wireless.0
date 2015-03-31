Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40891 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750903AbbCaVgy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Mar 2015 17:36:54 -0400
Message-ID: <1427837830.6133.3.camel@redhat.com> (sfid-20150331_233657_607708_90552309)
Subject: Re: Intel 7265 wireless performance unstable on Linux >= 3.19
From: Dan Williams <dcbw@redhat.com>
To: Ryan Finnie <ryan.finnie@canonical.com>
Cc: Emmanuel Grumbach <egrumbach@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Seth Forshee <seth.forshee@canonical.com>
Date: Tue, 31 Mar 2015 16:37:10 -0500
In-Reply-To: <551B045C.1030400@canonical.com>
References: <551A36A5.2050300@canonical.com>
		<CANUX_P0ka+W2x=MtFRyMx6Fts8HQ-+cJxzAO85dkj6GFjQEV4A@mail.gmail.com>
	 <CANUX_P3nsHyGNA6iS=v0=67ALHkUf1LY_os5qpzwNnJyEqpsDA@mail.gmail.com>
	 <551B045C.1030400@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-03-31 at 13:32 -0700, Ryan Finnie wrote:
> On 03/31/2015 02:15 AM, Emmanuel Grumbach wrote:
> >> Please open a bug on bugzilla.kernel.org and CC
> >> ilw@linux.intel.com to the bug. Attach your syslog output as
> >> well.
> 
> Done: https://bugzilla.kernel.org/show_bug.cgi?id=95901
> 
> >> It seems that the supplicant is deauthenticating. What is your
> >> supplicant version?
> 
> wpasupplicant 2.1-0ubuntu7 from Ubuntu vivid.  From the syslog output,
> it appears the wpa_supplicant output is reacting to the kernel event,
> with nothing relevant preceding it:
> 
> Mar 31 13:15:11 linda systemd[1]: Started Stop ureadahead data collection.
> Mar 31 13:15:20 linda kernel: [   72.442153] wlan0: deauthenticating
> from 38:2c:4a:5c:7f:e4 by local choice (Reason: 3=DEAUTH_LEAVING)
> Mar 31 13:15:20 linda kernel: [   72.457967] cfg80211: Calling CRDA to
> update world regulatory domain
> Mar 31 13:15:20 linda wpa_supplicant[902]: wlan0:
> CTRL-EVENT-DISCONNECTED bssid=38:2c:4a:5c:7f:e4 reason=3
> locally_generated=1
> Mar 31 13:15:20 linda NetworkManager[815]: <warn> Connection
> disconnected (reason -3)

I've looked through the log for relevant NetworkManager stuff, since
reason=3/locally-generated disconnections are often a result of NM's
association attempt timing out or moving to a new network.  In this
case, I cannot find any evidence of NetworkManager disconnecting
intentionally, it seems to come out of nowhere.

Dan

> > One idea came through my mind. Can you try this?
> > 
> > diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c 
> > b/drivers/net/wireless/iwlwifi/mvm/mac80211.c index
> > 302c8cc..7c12c9f 100644 ---
> > a/drivers/net/wireless/iwlwifi/mvm/mac80211.c +++
> > b/drivers/net/wireless/iwlwifi/mvm/mac80211.c @@ -525,7 +525,7 @@
> > int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm) else 
> > hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
> > 
> > -       if (IWL_UCODE_API(mvm->fw->ucode_ver) >= 10) { +       if
> > (IWL_UCODE_API(mvm->fw->ucode_ver) >= 10 && false) { 
> > hw->wiphy->flags |= WIPHY_FLAG_SUPPORTS_SCHED_SCAN; 
> > hw->wiphy->max_sched_scan_ssids = PROBE_OPTION_MAX; 
> > hw->wiphy->max_match_sets = IWL_SCAN_MAX_PROFILES;
> 
> Sorry, it didn't appear to have any effect; DEAUTH_LEAVING would still
> occur every ~60 seconds.
> 
> RF
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


