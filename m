Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61868 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850Ab1BHHfv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Feb 2011 02:35:51 -0500
Date: Tue, 8 Feb 2011 08:35:41 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	linux-wireless@vger.kernel.org,
	Intel Linux Wireless <ilw@linux.intel.com>
Subject: Re: [RFC] iwl3945: remove check_plcp_health
Message-ID: <20110208073540.GB2298@redhat.com>
References: <20110125093507.GA6429@redhat.com>
 <20110125151445.GA2927@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110125151445.GA2927@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 25, 2011 at 10:14:46AM -0500, John W. Linville wrote:
> On Tue, Jan 25, 2011 at 10:35:28AM +0100, Stanislaw Gruszka wrote:
> > This patch helps some users currently complaining about iwl3945
> > performance.
> > 
> > https://bugzilla.redhat.com/show_bug.cgi?id=654599
> > https://bugs.launchpad.net/ubuntu/maverick/+source/linux/+bug/621265/+index?comments=all
> > 
> > Patch does not helps all users, but they seems to be affected
> > by different bug or bugs.
> > 
> > Patch effectively reverts commit a29576a7844326c5223f4d4adbfd3f4d64173d4c
> > "iwl3945: add plcp error checking". It is minimal fix intended to
> > -stable posting. I will post cleaning up patch, if fix will be accepted.
> > 
> > ---
> >  drivers/net/wireless/iwlwifi/iwl-3945.c |    1 -
> >  1 files changed, 0 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
> > index 8cacb4e..eb916d7 100644
> > --- a/drivers/net/wireless/iwlwifi/iwl-3945.c
> > +++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
> > @@ -2832,7 +2832,6 @@ static struct iwl_lib_ops iwl3945_lib = {
> >  	.config_ap = iwl3945_config_ap,
> >  	.manage_ibss_station = iwl3945_manage_ibss_station,
> >  	.recover_from_tx_stall = iwl_bg_monitor_recover,
> > -	.check_plcp_health = iwl3945_good_plcp_health,
> >  
> >  	.debugfs_ops = {
> >  		.rx_stats_read = iwl3945_ucode_rx_stats_read,
> 
> Did you experiment with different values for
> IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF for iwl3945?

For fedora user increasing threshold help as well. Ubuntu
crowd gave some confusing testing results.

Anyway, after further investigation done in 
https://bugzilla.redhat.com/show_bug.cgi?id=671366
we discovered that hw scanning during association
sometimes put hardware in state when it is not able
to receive frames at higher rates.

Hw scan can be requested by plcp check or by NM, both
cases may cause troubles.

Also tx rates can be low, using common rate scaling code
helps.

My plan to fix performance problems on 3945:
- send patch to stable for increase plcp threshold on 3945
- make sw scan default on upstream
- add module option to disable plcp_check at all 
- remove custom rate scaling algorithm

Stanislaw
