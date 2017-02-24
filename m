Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout02.posteo.de ([185.67.36.142]:47617 "EHLO mout02.posteo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751296AbdBXJnd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Feb 2017 04:43:33 -0500
Message-ID: <1487929408.3812.3.camel@embedded.rocks> (sfid-20170224_104526_543931_3B109155)
Subject: Re: brcmfmac: problem using WPS with wpa_supplicant on BCM43362
From: =?ISO-8859-1?Q?J=F6rg?= Krause <joerg.krause@embedded.rocks>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: brcm80211-dev-list.pdl@broadcom.com,
        =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>
Date: Fri, 24 Feb 2017 10:43:28 +0100
In-Reply-To: <dd241eff-7e0d-26c1-1758-b3f4d51bc359@broadcom.com>
References: <1487881302.20481.3.camel@embedded.rocks>
         <dd241eff-7e0d-26c1-1758-b3f4d51bc359@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

On Fri, 2017-02-24 at 09:16 +0100, Arend Van Spriel wrote:
> 
> On 23-2-2017 21:21, Jörg Krause wrote:
> > Hi,
> > 
> > I am using Linux Kernel v4.9.9 and wpa_supplicant 2.6. When running
> > 'wpa_cli wps_pin any', the following messages are printed:
> > 
> > """
> > > wps_pin any         
> > 
> > [ 4011.779108] brcmfmac: brcmf_vif_set_mgmt_ie: vndr ie set error :
> > -30
> > [ 4011.786190] brcmfmac: brcmf_config_ap_mgmt_ie: Set Beacon IE
> > Failed
> > """
> > 
> > .. and nothing happens. The data sheet for the BCM43362 states that
> > the
> > module supports WPS.
> 
> Hi Jörg,
> 
> We have never tested WPS with brcmfmac. Most of it is in firmware so
> it
> might work. We had some fixes related to setting management IE, but
> it
> should be in 4.9. I did not check it (yet).

As it turns out, WPS does not work if a network configuration in
wpa_supplicant has the flag `mode=2` (access point mode) set:

"""
ctrl_interface=/var/run/wpa_supplicant
update_config=1

network={
	ssid="AP"
	key_mgmt=NONE
	mode=2
	id_str="ap"
}
"""

Setting mode=2 for a network and having ap_scan=1 (default) means if no
APs matching to the currently enabled networks are found, a new network
 (IBSS or AP mode operation) may be initialized (if configured).

So, WPS does not work if the interface is operating in AP mode. I
wonder, if this is a desired behavior? At least, wpa_supplicant does
not complain, but prints "WPS-PBC-ACTIVE", but no messages are
following, until "WPS-TIMEOUT".

Jörg
