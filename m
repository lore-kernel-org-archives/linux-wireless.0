Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dhost002-57.dex002.intermedia.net ([64.78.21.226]:17042 "EHLO
	dhost002-57.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753050AbXDIWab (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Apr 2007 18:30:31 -0400
From: "Jouni Malinen" <jkm@devicescape.com>
Date: Mon, 9 Apr 2007 15:30:36 -0700
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Jouni Malinen <j@w1.fi>, wireless <linux-wireless@vger.kernel.org>
Subject: Re: Problem with wpa_supplicant on bcm43xx-mac80211
Message-ID: <20070409223036.GJ22114@devicescape.com>
References: <461AB589.20405@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <461AB589.20405@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 09, 2007 at 04:52:09PM -0500, Larry Finger wrote:

> logger: WPA: Sending EAPOL-Key 2/4
> 
> At this point, the two cases diverge. The bad example has a 4 second delay, 
> then I get the following:
> 
> kernel: eth1: RX deauthentication from 00:14:bf:85:49:fa (reason=15)
> kernel: eth1: deauthenticated
> logger: WPA: TX EAPOL-Key - hexdump(len=123): 01 03 00 77 fe 01 09 00 20 00 

> Do you know why the supplicant waits the 4 seconds between the "sending key 
> 2/4" message and the actual transmission of it? Do you think that is 
> important, or is it a false lead? I would appreciate any debugging leads 
> you might offer.

This looks very odd.. There is not really any blocking operations in
wpa_supplicant between the places that print "WPA: Sending EAPOL-Key
2/4" and "WPA: TX EAPOL-Key"... How do you generate these syslog
messages? Could there be something buffering the TX EAPOL-Key message
and the delay would actually happen only after that? This could be
caused by send() getting blocked by something and the receiption of
deauthentication triggering unblocking somehow..

-- 
Jouni Malinen                                            PGP id EFC895FA
