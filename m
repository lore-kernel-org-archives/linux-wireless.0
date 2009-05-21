Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:44158 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753986AbZEUPsX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2009 11:48:23 -0400
From: Michael Buesch <mb@bu3sch.de>
To: matthieu castet <castet.matthieu@free.fr>
Subject: Re: b43 : under high load, ack are lost
Date: Thu, 21 May 2009 17:47:43 +0200
Cc: linux-wireless@vger.kernel.org
References: <loom.20090517T085823-487@post.gmane.org> <loom.20090520T203218-265@post.gmane.org> <loom.20090520T210546-24@post.gmane.org>
In-Reply-To: <loom.20090520T210546-24@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200905211747.43882.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 20 May 2009 23:09:47 matthieu castet wrote:
> I see also some period were the AP seem to drop all packet.
> I am wondering if it can be due to slow recalibration.
> Do you now how much take calibration were mac is down ?

I think you should try without QoS.
Try specifying the qos=0 module parameter to b43.
If that does not work, additionally apply the following patch.
I think there are some problems with QoS and I think somebody reported some bugs
some time ago. I think they are still not addressed.

If I try with this patch and QoS disabled, the monitor log looks a bit better.
But the connection still doesn't work correctly. However, I only have applied
that patch to the AP. I will also apply it to the station, soon...

In any case, I think this patch is a good thing, as it will completely disable
QoS, if the user requested so.


Index: compat-wireless-2009-05-21/drivers/net/wireless/b43/main.c
===================================================================
--- compat-wireless-2009-05-21.orig/drivers/net/wireless/b43/main.c	2009-05-21 17:16:49.000000000 +0200
+++ compat-wireless-2009-05-21/drivers/net/wireless/b43/main.c	2009-05-21 17:20:48.000000000 +0200
@@ -3064,6 +3064,9 @@
 	int bslots, tmp;
 	unsigned int i;
 
+	if (!b43_modparam_qos)
+		return;
+
 	bslots = b43_read16(dev, B43_MMIO_RNG) & p->cw_min;
 
 	memset(&params, 0, sizeof(params));
@@ -3109,6 +3112,9 @@
 	struct b43_qos_params *params;
 	unsigned int i;
 
+	if (!b43_modparam_qos)
+		return;
+
 	BUILD_BUG_ON(ARRAY_SIZE(b43_qos_shm_offsets) !=
 		     ARRAY_SIZE(wl->qos_params));
 
@@ -3126,6 +3132,9 @@
 	struct b43_qos_params *params;
 	unsigned int i;
 
+	if (!b43_modparam_qos)
+		return;
+
 	/* Initialize QoS parameters to sane defaults. */
 
 	BUILD_BUG_ON(ARRAY_SIZE(b43_qos_shm_offsets) !=
@@ -3168,6 +3177,15 @@
 /* Initialize the core's QOS capabilities */
 static void b43_qos_init(struct b43_wldev *dev)
 {
+	if (!b43_modparam_qos) {
+		/* Disable QOS support. */
+		b43_hf_write(dev, b43_hf_read(dev) & ~B43_HF_EDCF);
+		b43_write16(dev, B43_MMIO_IFSCTL,
+			    b43_read16(dev, B43_MMIO_IFSCTL)
+			    & ~B43_MMIO_IFSCTL_USE_EDCF);
+		return;
+	}
+
 	/* Upload the current QOS parameters. */
 	b43_qos_upload_all(dev);
 


-- 
Greetings, Michael.
