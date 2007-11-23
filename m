Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:26850 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751905AbXKWCtS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2007 21:49:18 -0500
From: bruno randolf <bruno@thinktube.com>
To: linux-wireless@vger.kernel.org
Subject: signal quality names
Date: Fri, 23 Nov 2007 11:49:25 +0900
Cc: Larry.Finger@lwfinger.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200711231149.26047.bruno@thinktube.com> (sfid-20071123_024930_846319_CC1C2CCC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun Apr 15 06:22:46 CEST 2007 Larry Finger wrote:
> The variables in mac80211 are confusing and should be renamed; however,
> that may take, some time to reach a consensus. 

this was seven month ago. has there been any consensus reached?

the current names are very misleading:

/**
 * struct ieee80211_rx_status - receive status
 * [...]
 * @ssi: signal strength when receiving this frame
 * @signal: used as 'qual' in statistics reporting
 * @noise: PHY noise when receiving this frame

no units are specified. so this increases the confusion we have already 
because of poorly defined wireless extensions. please let's not repeat this 
mistake and let's try to standardize the reporting of signal and noise values 
across drivers at least up to mac80211.

i see that most of the drivers already try to report signal and noise ('ssi' 
and 'noise' according to the current naming) in dBm values and calculate a 
quality percentage (current name: 'signal') based on different factors.

so may i suggest to use variable names like

signal_dbm
noise_dbm

then? or leave them as 'signal' and 'noise' and make it clear in the kerneldoc 
that we expect dBm.

if there are drivers which cannot convert their internal values into dBm, we 
could provide an alternative 'ssi' (or similar, positive, unit-less, 
un-defined) to allow for that and handle the differences in reporting (to 
wext and for the radiotap headers) inside mac80211.

and could we move the quality calculation up into mac80211 to have consistency 
and comparable values across drivers?

i am willing to do the work.

bruno
