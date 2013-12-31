Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:23722 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753230Ab3LaPdS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Dec 2013 10:33:18 -0500
From: "Peer, Ilan" <ilan.peer@intel.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH 2/2] [RFC] mac80211: Add all enabled channels to the
 supported channels element
Date: Tue, 31 Dec 2013 15:33:14 +0000
Message-ID: <CB3B3D4774441E42AA3EA0E1BA8230A03334F7BB@HASMSX106.ger.corp.intel.com> (sfid-20131231_163322_160318_B55F8E52)
References: <1388503946-25862-1-git-send-email-ilan.peer@intel.com>
 <1388503946-25862-3-git-send-email-ilan.peer@intel.com>
In-Reply-To: <1388503946-25862-3-git-send-email-ilan.peer@intel.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> In the current implementation, in case that the AP supports spectrum
> management, the supported channels information element added to the
> association and re-association frames includes only the channels that where
> in the same band as that of the operating channel of the AP.
> However, the 80211-2012 specification defines in 8.4.2.20 that the supported
> channels information element should contain a list of the channel subbands
> in which the station is capable to operate.
> 
> +
> +			if (first_chan == 0) {
> +				/* first subband */
> +				first_chan = chan;
> +				count = 1;
> +			} else if (first_chan + count == chan) {
> +				/* continue the subband.
> +				 * TODO: this is really only useful for 2.4,
> +				 * need to add spacing considerations for
> other
> +				 * bands as well (the definition of a subband
> +				 * in the 802.11 spec. is a bit vague).
> +				 */

Any suggestions on how to better handle this? 

Thanks in advance :)

Ilan.
