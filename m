Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.172]:33614 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbYK1Jbb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Nov 2008 04:31:31 -0500
Received: by ug-out-1314.google.com with SMTP id 39so1914192ugf.37
        for <linux-wireless@vger.kernel.org>; Fri, 28 Nov 2008 01:31:29 -0800 (PST)
To: Zhu Yi <yi.zhu@intel.com>
Subject: Re: [Ipw2100-devel] [PATCH] ipw2200: rework scan handling while associated
Date: Fri, 28 Nov 2008 10:31:04 +0100
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"ipw2100-devel@lists.sourceforge.net"
	<ipw2100-devel@lists.sourceforge.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Cahill, Ben M" <ben.m.cahill@intel.com>
References: <200811261805.39953.helmut.schaa@gmail.com> <1227862298.2558.107.camel@debian.sh.intel.com>
In-Reply-To: <1227862298.2558.107.camel@debian.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200811281031.04996.helmut.schaa@gmail.com> (sfid-20081128_103135_870721_D8F838BD)
From: Helmut Schaa <helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Freitag, 28. November 2008 schrieb Zhu Yi:
> On Thu, 2008-11-27 at 01:05 +0800, Helmut Schaa wrote:
> > Could somebody please review the patch?
> > Should I split the patch into three single patches?
> 
> Thank you for your patch. See my comments below.
> 
> > diff --git a/drivers/net/wireless/ipw2x00/ipw2200.c b/drivers/net/wireless/ipw2x00/ipw2200.c
> > index c73173a..f17b5b2 100644
> > --- a/drivers/net/wireless/ipw2x00/ipw2200.c
> > +++ b/drivers/net/wireless/ipw2x00/ipw2200.c
> > @@ -2310,10 +2310,10 @@ static void ipw_scan_check(void *data)
> >  {
> >  	struct ipw_priv *priv = data;
> >  	if (priv->status & (STATUS_SCANNING | STATUS_SCAN_ABORTING)) {
> > -		IPW_DEBUG_SCAN("Scan completion watchdog resetting "
> > -			       "adapter after (%dms).\n",
> > +		IPW_DEBUG_SCAN("Scan completion watchdog: aborting "
> > +			       "scan after (%dms).\n",
> >  			       jiffies_to_msecs(IPW_SCAN_CHECK_WATCHDOG));
> > -		queue_work(priv->workqueue, &priv->adapter_restart);
> > +		queue_work(priv->workqueue, &priv->abort_scan);
> >  	}
> >  }
> 
> We need something like the network Tx watchdog to prevent the firmware
> stick forever when something is wrong during scan. At this time, no
> command (include ABORT_SCAN) is going to be processed.

Hmm, I was able to reproduce the firmware looping endlessly reasonably
reliable (turned off the beacon-miss-cancels-scan-behaviour and increased the
scan watchdog timeout) and the ABORT_SCAN command was processed in that case
and canceled the scan which resulted in a
HOST_NOTIFICATION_STATUS_SCAN_COMPLETED notification with status 2 (not sure
if it really was 2). So, at least the failure I noticed here could be corrected
by aborting the scan instead of restarting the adapter.

What about the following:
After the first scan timeout we try to cancel the scan and if that does not
succeed in a few seconds we can still restart the fw.

> We need something 
> can really move the firmware back to the correct state, that is the
> adapter_restart. If you do see the watchdog files a lot, increasing
> IPW_SCAN_CHECK_WATCHDOG should be the way to go.

I see the timeout because the firmware will never stop scanning until either
the beacon miss notification cancels the scan or the IPW_SCAN_CHECK_WATCHDOG
timeout restarts the adapter. I already tried a scan timeout of 25 seconds but
the firmware insists on scanning the first passive channel (in my setup 52)
over and over again.

> > @@ -4346,7 +4346,8 @@ static void ipw_handle_missed_beacon(struct ipw_priv *priv,
> >  		return;
> >  	}
> >  
> > -	if (priv->status & STATUS_SCANNING) {
> > +	if (priv->status & STATUS_SCANNING &&
> > +	    missed_count > priv->cancel_scan_threshold) {
> >  		/* Stop scan to keep fw from getting
> >  		 * stuck (only if we aren't roaming --
> >  		 * otherwise we'll never scan more than 2 or 3
> 
> I'm OK with this. Since you don't change priv->cancel_scan_threadhold
> anywhere, can you use IPW_MB_SCAN_CANCEL_THRESHOLD directly? 

Right.

> > @@ -6281,6 +6282,18 @@ static void ipw_add_scan_channels(struct ipw_priv *priv,
> >  	}
> >  }
> >  
> > +static int ipw_passive_dwell_time(struct ipw_priv *priv)
> > +{
> > +	/* staying on passive channels longer than the beacon interval causes
> > +	 * the firmware to enter an infinite loop. Hence, don't stay on passive
> > +	 * longer than the beacon interval.
> > +	 */
> > +	if (priv->status & STATUS_ASSOCIATED && priv->assoc_network->beacon_interval > 10)
> > +		return priv->assoc_network->beacon_interval - 10;
> > +	else
> > +		return 120;
> > +}
> 
> Is it still a problem with the above IPW_MB_SCAN_CANCEL_THRESHOLD used?

Yes, it is. If the passive channel dwell time is larger than the beacon
interval the firmware will be stuck at the first passive channel. Thus the
scan will never succeed.

> We assume most APs use 100ms beacon interval. But in case you are
> associated with an AP which uses 20ms beacon interval, do you want to
> set the passive_dwell time to 10ms here? 

Yes, either that or just leaving all channels out that need to be scanned
for a longer period than the beacon interval. In case of a 20ms beacon interval
I'm pretty sure the active scan on all other channels will results in a
endless scan loop in the fw too.

> 120ms makes sure we can at 
> least receive a beacon for normal APs.

Yes, but I'd favour a successful scan that does not find every AP on passive
channels over a canceled scan.

> BTW, another thing might help to resolve the scan-while-associate
> problem. Currently we scan 5GHz band channels first, then 2.4GHz band
> (see ipw_add_scan_channels). Normally most channels in 5GHz band are
> passive ones. Thus they use longer dwell time. If we change to scan
> 2.4GHz band channels first, we can get more scan result before a scan
> abort. Can you please try it?

That's true but in case the scan is canceled the results are not forwarded
to user space as they may be incomplete.

Thanks,
Helmut
