Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:48474 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709AbYKQThh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Nov 2008 14:37:37 -0500
Received: by nf-out-0910.google.com with SMTP id d3so1240713nfc.21
        for <linux-wireless@vger.kernel.org>; Mon, 17 Nov 2008 11:37:35 -0800 (PST)
Message-ID: <4921C7F7.9000501@gmail.com> (sfid-20081117_203741_048239_B935F780)
Date: Mon, 17 Nov 2008 19:37:27 +0000
MIME-Version: 1.0
To: Dan Williams <dcbw@redhat.com>
CC: Dave <kilroyd@googlemail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Andrey Borzenkov <arvidjaar@mail.ru>,
	orinoco-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
Subject: Re: [Orinoco-devel] Agere PCMCIA sometimes takes very long time to
 associate with 9.48 FW
References: <200810191436.13298.arvidjaar@mail.ru>	 <491349BC.8090606@gmail.com> <49134F66.4020608@gmail.com>	 <200811151115.48750.arvidjaar@mail.ru>	 <20081115145655.GB31553@tuxdriver.com>  <491FEF89.3040100@gmail.com> <1226937010.10028.28.camel@localhost.localdomain>
In-Reply-To: <1226937010.10028.28.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
From: Dave <kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Williams wrote:
> On Sun, 2008-11-16 at 10:01 +0000, Dave wrote:
>> 2. Does the driver need to send a dissociation event (or something) to
>> userspace on ifconfig down?
> 
> If the association with the AP is no longer valid, then yes.  Most of
> the other drivers do this already, I think.

I couldn't find in in mac80211, but a few (but not all) of the fullmac
drivers seem to do it.

Andrey: the attached patch may help, but given what you've written in
your other email (which I'll respond to separately), I don't think it
will fix things. Note that it's against wireless testing (+ private
changes). Should apply cleanly to an older tree after you account for
the file move.


Regards,

Dave.
---
diff --git a/drivers/net/wireless/orinoco/orinoco.c
b/drivers/net/wireless/orinoco/orinoco.c
index f8db026..007d5b8 100644
--- a/drivers/net/wireless/orinoco/orinoco.c
+++ b/drivers/net/wireless/orinoco/orinoco.c
@@ -2319,7 +2319,21 @@ int __orinoco_down(struct net_device *dev)
                hermes_set_irqmask(hw, 0);
                hermes_write_regn(hw, EVACK, 0xffff);
        }
-
+
+       /* If associated, tell userspace we're dropping it */
+       if ((priv->last_linkstatus == HERMES_LINKSTATUS_CONNECTED) ||
+           (priv->last_linkstatus == HERMES_LINKSTATUS_AP_CHANGE) ||
+           (priv->last_linkstatus == HERMES_LINKSTATUS_AP_IN_RANGE))
+       {
+               union iwreq_data wrqu;
+
+               wrqu.data.length = 0;
+               wrqu.data.flags = 0;
+               wrqu.ap_addr.sa_family = ARPHRD_ETHER;
+               memset(wrqu.ap_addr.sa_data, 0, ETH_ALEN);
+               wireless_send_event(dev, SIOCGIWAP, &wrqu, NULL);
+       }
+
        /* firmware will have to reassociate */
        netif_carrier_off(dev);
        priv->last_linkstatus = 0xffff;

