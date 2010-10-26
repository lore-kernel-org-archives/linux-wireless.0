Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mgw-sa02.ext.nokia.com ([147.243.1.48]:29555 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932384Ab0JZMCe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Oct 2010 08:02:34 -0400
Subject: Re: [PATCH 1/2] wl1271: Fix scan failure detection
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Johannes Berg <johannes@sipsolutions.net>
Cc: "Coelho Luciano (Nokia-MS/Helsinki)" <Luciano.Coelho@nokia.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1288093257.3761.59.camel@jlt3.sipsolutions.net>
References: <1288092279-31272-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1288093257.3761.59.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Oct 2010 15:01:57 +0300
Message-ID: <1288094517.2607.33.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-10-26 at 13:40 +0200, ext Johannes Berg wrote:
> On Tue, 2010-10-26 at 14:24 +0300, juuso.oikarinen@nokia.com wrote:
> 
> >  	mutex_lock(&wl->mutex);
> >  
> > +	if (wl->state == WL1271_STATE_OFF) {
> > +		/*
> > +		 * We cannot return -EBUSY here because mac80211 will expect
> > +		 * a call to ieee80211_scan_completed if we do - in this case
> > +		 * there won't be any call.
> > +		 */
> 
> ???
> 
> johannes
> 

I'll try explain what this is about. In net/wireless/sme.c you'll find
this:


                } else {
                        /* otherwise we'll need to scan for the AP first
*/
                        err = cfg80211_conn_scan(wdev);
                        /*
                         * If we can't scan right now, then we need to
scan again
                         * after the current scan finished, since the
parameters
                         * changed (unless we find a good AP anyway).
                         */
                        if (err == -EBUSY) {
                                err = 0;
                                wdev->conn->state =
CFG80211_CONN_SCAN_AGAIN;
                        }
                }

In this code, if the driver ends up returning -EBUSY, the cfg80211 ends
up waiting for a ieee80211_scan_complete call from the driver to proceed
in the connection setting.  If the scan is invoked while the driver is
not ready, returning -EBUSY in this scenario will cause the cfg80211 to
wait forever.

Obviously, cfg80211 would normally never call scan while the driver is
not initialized. This patch is about a corner case - if the wl1271
hardware crashes just before user-space requests a connection, hardware
recovery can be running while the connection is set up. To recover the
hardware, it is powered down and then mac80211 is asked to reconfigure
it.

This is the window in which the connection setup may stall. Returning an
error code other than -EBUSY for this corner case causes the error code
to be retruned to user-space, and user-space can retry the connection.

-Juuso

