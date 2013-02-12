Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48055 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932151Ab3BLRvs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2013 12:51:48 -0500
Message-ID: <1360691503.29913.10.camel@jlt4.sipsolutions.net> (sfid-20130212_185153_245404_75537EBA)
Subject: Re: pull-request: iwlwifi-next 2012-02-12
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 12 Feb 2013 18:51:43 +0100
In-Reply-To: <20130212174131.GD2086@tuxdriver.com>
References: <1360684891.29913.4.camel@jlt4.sipsolutions.net>
	 <20130212173750.GC2086@tuxdriver.com> <20130212174131.GD2086@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-02-12 at 12:41 -0500, John W. Linville wrote:
> On Tue, Feb 12, 2013 at 12:37:50PM -0500, John W. Linville wrote:
> > On Tue, Feb 12, 2013 at 05:01:31PM +0100, Johannes Berg wrote:
> > > John,
> > > 
> > > We continue work on our new driver, but I also have a WoWLAN and AP mode
> > > improvement for the previous driver and a change to use threaded
> > > interrupts to prepare us for working with non-PCIe devices.
> > > 
> > > Please pull.
> > > 
> > > Thanks,
> > > johannes
> > > 
> > > 
> > > 
> > > The following changes since commit 8457703f1e86aaf0f134402dd1e09e1f13e65222:
> > > 
> > >   ath6kl: provide 64-bit per-station byte counters (2013-02-11 15:34:58 -0500)
> > > 
> > > are available in the git repository at:
> > > 
> > >   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git for-john
> > > 
> > > for you to fetch changes up to 36eed56a8f7e1bd7fb5014ea0e702708e1702f30:
> > > 
> > >   iwlwifi: mvm: beautify code in rx_handlers (2013-02-12 16:52:26 +0100)
> > 
> > Pulling now...
> 
> Hmmm...
> 
>   CC [M]  drivers/net/wireless/iwlwifi/mvm/mac80211.o
> drivers/net/wireless/iwlwifi/mvm/mac80211.c: In function ‘iwl_mvm_mac_setup_register’:
> drivers/net/wireless/iwlwifi/mvm/mac80211.c:116:1: error: expected expression before ‘<<’ token
> drivers/net/wireless/iwlwifi/mvm/mac80211.c:120:9: error: exponent has no digits

I think you didn't resolve the merge conflict:

        hw->flags = IEEE80211_HW_SIGNAL_DBM |
                    IEEE80211_HW_SPECTRUM_MGMT |
                    IEEE80211_HW_REPORTS_TX_ACK_STATUS |
                    IEEE80211_HW_QUEUE_CONTROL |
                    IEEE80211_HW_WANT_MONITOR_VIF |
<<<<<<< HEAD
                    IEEE80211_HW_NEED_DTIM_BEFORE_ASSOC |
=======
                    IEEE80211_HW_SCAN_WHILE_IDLE |
>>>>>>> iwlwifi-next/for-john
                    IEEE80211_HW_SUPPORTS_PS |
                    IEEE80211_HW_SUPPORTS_DYNAMIC_PS |
                    IEEE80211_HW_AMPDU_AGGREGATION;

My mac80211-next tree removed HW_SCAN_WHILE_IDLE, iwlwifi-next removes
NEED_DTIM_BEFORE_ASSOC.

Sorry about that!

johannes

