Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost03.isp.att.net ([207.115.11.53]:44469 "EHLO
	fmailhost03.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400AbZDHSFG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Apr 2009 14:05:06 -0400
Message-ID: <49DCE741.7080406@lwfinger.net> (sfid-20090408_200510_290484_59892DE0)
Date: Wed, 08 Apr 2009 13:04:49 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "eugene.sobol" <eugene.sobol@promwad.com>
CC: linux-wireless@vger.kernel.org, ivan.kuten@promwad.com,
	hintak.leung@gmail.com
Subject: Re: rtl8187 diversity
References: <200904081530.51962.eugene.sobol@promwad.com>
In-Reply-To: <200904081530.51962.eugene.sobol@promwad.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

eugene.sobol wrote:
> Hello!
> 
> We are using RTL8187L module (with 2 antenna) from Abocom on our Blackfin DSP 
> based board.
> We have to enable antenna diversity for that module.
> 
> We have done some workaround realted with it:
> I got compat-wireless archive from: 
> http://wireless.kernel.org/download/compat-wireless-2.6/compat-wireless-old.tar.bz2
> I added switch-antenna related code from rtl8187L_linux_26.1036.1105.2008 
> driver.
> I added simple logic how to evaluate quality of signal by AGC and switch 
> between antennas.
> 
> Following code shows how does swiching between antennas work (from 
> rtl8187L_linux_26.1036.1105.2008 ) :
> +           write_nic_byte(priv, 0x7f, ((0x01009b90 & 0xff000000) >> 24));
> +           write_nic_byte(priv, 0x7e, ((0x01009b90 & 0x00ff0000) >> 16));
> +           write_nic_byte(priv, 0x7d, ((0x01009b90 & 0x0000ff00) >> 8));
> +           write_nic_byte(priv, 0x7c, ((0x01009b90 & 0x000000ff) >> 0));
> +
> +           // Rx OFDM.
> +           /* original code from realtek driver */
> +           write_nic_byte(priv, 0x7f, ((0x000090a6 & 0xff000000) >> 24));
> +           write_nic_byte(priv, 0x7e, ((0x000090a6 & 0x00ff0000) >> 16));
> +           write_nic_byte(priv, 0x7d, ((0x000090a6 & 0x0000ff00) >> 8));
> +           write_nic_byte(priv, 0x7c, ((0x000090a6 & 0x000000ff) >> 0));
> +
> +           // Tx Antenna.
> +           /* original code from realtek driver */
> +           write_nic_byte(priv, ANTSEL, 0x03); // Config TX antenna.
> 
> This is code example shows switching to one of two antennas. Other code you 
> can see in attached patch.
> 
> During handling every packet, the AGC value recording to an array. Every 
> second driver calculate average value from AGC's array and makes decision 
> have to do switch to other antenna or not.
> 
> Compat drivers for chip on our board shows better results than 
> rtl8187L_linux_26.1036.1105.2008 driver,
> compat driver                                             ~ 800-1000Kbytes/sec
> rtl8187L_linux_26.1036.1105.2008 driver ~ 200Kbytes/sec
> 
> Please correct me if I chose not correct parameter for evaluating signal 
> quality information.
> 
> However while testing, the switching between antennas doesn't give any 
> download speed improvements.
> May be we missed some point.
> 

My first comment is that the patch should be in-line rather than as an
attachment. Reviewing is easier.

You should be using the wireless-testing tree to derive your patches. Otherwise,
they cannot be applied. For example, the following hunk is already in w-t:

@@ -257,6 +261,7 @@

        usb_fill_bulk_urb(urb, priv->udev, usb_sndbulkpipe(priv->udev, ep),
                          buf, skb->len, rtl8187_tx_cb, skb);
+       urb->transfer_flags |= URB_ZERO_PACKET;
        rc = usb_submit_urb(urb, GFP_ATOMIC);
        if (rc < 0) {
                usb_free_urb(urb);


I don't like the idea of having the antenna diversity as a compile-time option.
That works OK for a single user, but it fails when distros are considered. They
would have to have it on for all cases even though very few users would need it.
Does the EEPROM for your device have special encoding that indicates the
presence of multiple antennas? You should be able to compile the antenna
diversity code unconditionally and use such a special EEPROM value.
Alternatively, the USB ID's (13d1:abe6) could be used to select its execution.

You should run the patch through the scripts/checkpatch.pl routine. Yours shows
55 errors and 34 warnings.

Please split out the part that adds the new USB_DEVICE and submit it now. That
will be needed no matter what happens to the antenna diversity code.

Larry
