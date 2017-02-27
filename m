Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout02.posteo.de ([185.67.36.142]:43686 "EHLO mout02.posteo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751341AbdB0REE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Feb 2017 12:04:04 -0500
Message-ID: <1488214923.31837.6.camel@embedded.rocks> (sfid-20170227_180408_295840_73C5B997)
Subject: Re: brcmfmac: problem using WPS with wpa_supplicant on BCM43362
From: =?ISO-8859-1?Q?J=F6rg?= Krause <joerg.krause@embedded.rocks>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: brcm80211-dev-list.pdl@broadcom.com,
        =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>
Date: Mon, 27 Feb 2017 18:02:03 +0100
In-Reply-To: <9c8e71d8-c6af-1d2b-3d91-ac791bc33327@broadcom.com>
References: <1487881302.20481.3.camel@embedded.rocks>
         <dd241eff-7e0d-26c1-1758-b3f4d51bc359@broadcom.com>
         <1487929408.3812.3.camel@embedded.rocks>
         <ce3bf3a5-2cd7-eb77-bb7d-57df8388e1ba@broadcom.com>
         <1487932016.3812.10.camel@embedded.rocks>
         <9c8e71d8-c6af-1d2b-3d91-ac791bc33327@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

On Fri, 2017-02-24 at 13:15 +0100, Arend Van Spriel wrote:
> On 24-2-2017 11:26, Jörg Krause wrote:
> > Hi Arend,
> > 
> > On Fri, 2017-02-24 at 10:58 +0100, Arend Van Spriel wrote:
> > > On 24-2-2017 10:43, Jörg Krause wrote:
> > > > Hi Arend,
> > > > 
> > > > On Fri, 2017-02-24 at 09:16 +0100, Arend Van Spriel wrote:
> > > > > 
> > > > > On 23-2-2017 21:21, Jörg Krause wrote:
> > > > > > Hi,
> > > > > > 
> > > > > > I am using Linux Kernel v4.9.9 and wpa_supplicant 2.6. When
> > > > > > running
> > > > > > 'wpa_cli wps_pin any', the following messages are printed:
> > > > > > 
> > > > > > """
> > > > > > > wps_pin any         
> > > > > > 
> > > > > > [ 4011.779108] brcmfmac: brcmf_vif_set_mgmt_ie: vndr ie set
> > > > > > error :
> > > > > > -30
> > > > > > [ 4011.786190] brcmfmac: brcmf_config_ap_mgmt_ie: Set
> > > > > > Beacon IE
> > > > > > Failed
> > > > > > """
> > > > > > 
> > > > > > .. and nothing happens. The data sheet for the BCM43362
> > > > > > states
> > > > > > that
> > > > > > the
> > > > > > module supports WPS.
> > > > > 
> > > > > Hi Jörg,
> > > > > 
> > > > > We have never tested WPS with brcmfmac. Most of it is in
> > > > > firmware
> > > > > so
> > > > > it
> > > > > might work. We had some fixes related to setting management
> > > > > IE,
> > > > > but
> > > > > it
> > > > > should be in 4.9. I did not check it (yet).
> > > > 
> > > > As it turns out, WPS does not work if a network configuration
> > > > in
> > > > wpa_supplicant has the flag `mode=2` (access point mode) set:
> > > > 
> > > > """
> > > > ctrl_interface=/var/run/wpa_supplicant
> > > > update_config=1
> > > > 
> > > > network={
> > > > 	ssid="AP"
> > > > 	key_mgmt=NONE
> > > > 	mode=2
> > > > 	id_str="ap"
> > > > }
> > > > """
> > > > 
> > > > Setting mode=2 for a network and having ap_scan=1 (default)
> > > > means
> > > > if no
> > > > APs matching to the currently enabled networks are found, a new
> > > > network
> > > >  (IBSS or AP mode operation) may be initialized (if
> > > > configured).
> > > > 
> > > > So, WPS does not work if the interface is operating in AP mode.
> > > > I
> > > > wonder, if this is a desired behavior? At least, wpa_supplicant
> > > > does
> > > > not complain, but prints "WPS-PBC-ACTIVE", but no messages are
> > > > following, until "WPS-TIMEOUT".
> > > 
> > > So what do you expect exactly? Are you trying to connect with
> > > some
> > > other
> > > device to this AP interface?
> > 
> > Sorry, I got confused. The device operating in AP mode shall be
> > connected to some other AP as a station. Of course, WPS cannot be
> > used
> > to do so as long as the interface is operation in AP mode, as the
> > device should be the WPS enrollee and not the registrar. My bad!
> > Thanks
> > for pointing that out.
> > 
> > So, to use WPS for connecting the device to another AP I have to
> > bring
> > the interface into an non-AP mode first.
> > 
> > So, I can confirm that using WPS works when the interface is
> > unconfigured. However, if the in the interface is in AP mode and
> > WPS is
> > started the error messages pop up.
> 
> You mean the message you emailed earlier as below?
> 
> [ 4011.779108] brcmfmac: brcmf_vif_set_mgmt_ie: vndr ie set
> error :
> -30
> [ 4011.786190] brcmfmac: brcmf_config_ap_mgmt_ie: Set Beacon IE
> Failed
> 
> You get firmware error -30 which is BCME_NOTFOUND. This can happen in
> firmware upon deleting an IE. However, it is hard to say what is
> exactly
> happening without knowing the message content that goes to firmware.
> You
> can enable firmware console logging to see if you get any message
> regarding this, eg. "wlc_del_ie: IE not in list". Do insmod with
> debug=0x00100000.
> 
> 	if (total_ie_buf_len) {
> 		err  = brcmf_fil_bsscfg_data_set(ifp, "vndr_ie",
> iovar_ie_buf,
> 						 total_ie_buf_len);
> 		if (err)
> 			brcmf_err("vndr ie set error : %d\n", err);
> 	}
> 
> If this happens in the .start_ap() callback the error is ignored so
> it
> should not affect AP operation although beacon may not be setup
> properly.

I loaded the brcmfmac driver with the debug setting and started wpa_cli
wps_pbc while the device operates in AP mode.

This is the log after running the command:

"""
kern.err kernel: [   73.277473] brcmfmac: brcmf_vif_set_mgmt_ie: vndr
ie set error : -30
kern.err kernel: [   73.284647] brcmfmac: brcmf_config_ap_mgmt_ie: Set
Beacon IE Failed
daemon.err wpa_supplicant[176]: Failed to set beacon parameters
daemon.notice wpa_supplicant[176]: wlan0: WPS-PBC-ACTIVE 
kern.debug kernel: [   73.298749] brcmfmac: CONSOLE: 
user.notice ACTION_WPA: WPS-PBC-ACTIVE
daemon.notice wpa_supplicant[176]: wlan0: WPS-TIMEOUT 
daemon.err wpa_supplicant[176]: Failed to set beacon parameters
kern.err kernel: [  193.319897] brcmfmac: brcmf_vif_set_mgmt_ie: vndr
ie set error : -30
kern.err kernel: [  193.333464] brcmfmac: brcmf_config_ap_mgmt_ie: Set
Beacon IE Failed
kern.debug kernel: [  193.347876] brcmfmac: CONSOLE: wl0: wlc_del_ie:
IE not in list
user.notice ACTION_WPA: WPS-TIMEOUT
"""

Note, that the first brcmfmac CONSOLE message is empty, whereas the
second one is "wl0: wlc_del_ie: IE not in list".

Best regards,
Jörg Krause
