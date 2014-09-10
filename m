Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:41323 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751285AbaIJOAL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2014 10:00:11 -0400
From: "Peer, Ilan" <ilan.peer@intel.com>
To: Jouni Malinen <j@w1.fi>, Arend van Spriel <arend@broadcom.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	brcm80211 development <brcm80211-dev-list@broadcom.com>,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>
Subject: RE: P2P_DEVICE support in Android KitKat
Date: Wed, 10 Sep 2014 14:00:05 +0000
Message-ID: <CB3B3D4774441E42AA3EA0E1BA8230A03487FB54@HASMSX106.ger.corp.intel.com> (sfid-20140910_160021_163711_B57DDCB9)
References: <540FFDFD.2070302@broadcom.com> <20140910111040.GA5269@w1.fi>
In-Reply-To: <20140910111040.GA5269@w1.fi>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

We've encountered this issue in the past, and resolved it by passing the wpa_supplicant a P2P specific configuration file using the -m option. Try using -m but do not populate it with any network blocks that are not P2P groups.

Hope this helps,

Ilan.

> -----Original Message-----
> From: linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-
> owner@vger.kernel.org] On Behalf Of Jouni Malinen
> Sent: Wednesday, September 10, 2014 14:11
> To: Arend van Spriel
> Cc: linux-wireless@vger.kernel.org; brcm80211 development;
> hostap@lists.shmoo.com
> Subject: Re: P2P_DEVICE support in Android KitKat
> 
> On Wed, Sep 10, 2014 at 09:30:05AM +0200, Arend van Spriel wrote:
> > I am running some tests on a haswell target with Android KitKat
> > (3.10.20 kernel). In this configuration our brcmfmac driver is used
> > with driver param 'p2p_device=1'. So we end up with wlan0 and
> > p2p-dev-wlan0 interfaces (can blame myself for that). The
> > configuration has a network configured, but I did not expect
> > wpa_supplicant to start association using the p2p device interface.
> > The wlan0 interface is already connected to the AP. How can I fix this
> > to assure p2p-dev-wlan0 is only used for p2p management scenarios.
> 
> Hmm.. Can you please show the wpa_supplicant command line that is used
> here and describe how that network block gets configured for the
> p2p-dev-wlan0 "interface"? I would have expected that there would never
> be a configuration with an enabled network block being passed for the P2P
> management interface.. Internally, wpa_supplicant should not add such for
> P2P groups, but I don't think there is any filtering on configuration if
> something is externally trying to make wpa_supplicant use that management
> interface for a station mode connection.
> 
> --
> Jouni Malinen                                            PGP id EFC895FA
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in the
> body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
