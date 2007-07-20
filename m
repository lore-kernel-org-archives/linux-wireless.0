Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:50839 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754540AbXGTFZ7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jul 2007 01:25:59 -0400
Date: Thu, 19 Jul 2007 22:27:16 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: Michael Wu <flamingice@sourmilk.net>
Cc: cebbert@redhat.com, linville@redhat.com,
	linux-wireless@vger.kernel.org, zaitcev@redhat.com
Subject: Re: p54usb: Don't run DMA off code segment
Message-Id: <20070719222716.e4152774.zaitcev@redhat.com>
In-Reply-To: <200707180048.35762.flamingice@sourmilk.net>
References: <20070716231051.0971d9c0.zaitcev@redhat.com>
	<200707180048.35762.flamingice@sourmilk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 18 Jul 2007 00:48:31 -0700, Michael Wu <flamingice@sourmilk.net=
> wrote:

> On Monday 16 July 2007 23:10, Pete Zaitcev wrote:
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if ((err =3D p54u_bulk_m=
sg(priv, P54U_PIPE_DATA, buf, 4)) !=3D 0) {
> Please follow the style used elsewhere in this function and do it lik=
e:
>=20
>   err =3D p54u_bulk_msg(priv, P54U_PIPE_DATA, buf, 4);
>   if (err) {
>=20
> The rest of the patch looks fine. Thanks for fixing this.

How about this, then?

---

Passing a pointer into the code segment to DMA API is invalid. Most of =
the
time, you just DMA garbage into the device, but sometimes the controlle=
r
gets a bad address and then you see this:

usbcore: registered new interface driver prism54usb
usb 3-1: new full speed USB device using uhci_hcd and address 2
usb 3-1: not running at top speed; connect to a high speed hub
usb 3-1: configuration #1 chosen from 1 choice
uhci_hcd 0000:00:1d.2: host system error, PCI problems?
uhci_hcd 0000:00:1d.2: host controller halted, very bad!
uhci_hcd 0000:00:1d.2: HC died; cleaning up
p54usb: reset failed!
prism54usb: probe of 3-1:1.0 failed with error -110

See:
 https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=3D242638

Signed-off-by: Pete Zaitcev <zaitcev@redhat.com>

--- linux-2.6.23-0.15.rc0.git1.fc8/drivers/net/wireless/mac80211/p54/pr=
ism54usb.c	2007-07-16 20:16:00.000000000 -0700
+++ linux-2.6.23-0.15.rc0.git1.fc8-p54u/drivers/net/wireless/mac80211/p=
54/prism54usb.c	2007-07-19 21:46:41.000000000 -0700
@@ -375,22 +375,24 @@ static int p54u_upload_firmware_3887(str
 	struct x2_header *hdr;
 	unsigned long timeout;
=20
-	err =3D p54u_bulk_msg(priv, P54U_PIPE_DATA, start_string, 4);
-	if (err) {
-		printk(KERN_ERR "p54usb: reset failed!\n");
-		return err;
-	}
-
 	tmp =3D buf =3D kmalloc(P54U_FW_BLOCK, GFP_KERNEL);
 	if (!buf) {
 		printk(KERN_ERR "p54usb: cannot allocate firmware upload buffer!\n")=
;
-		return -ENOMEM;
+		err =3D -ENOMEM;
+		goto err_bufalloc;
+	}
+
+	memcpy(buf, start_string, 4);
+	err =3D p54u_bulk_msg(priv, P54U_PIPE_DATA, buf, 4);
+	if (err) {
+		printk(KERN_ERR "p54usb: reset failed! (%d)\n", err);
+		goto err_reset;
 	}
=20
 	err =3D request_firmware(&fw_entry, "isl3887usb_bare", &priv->udev->d=
ev);
 	if (err) {
 		printk(KERN_ERR "p54usb: cannot find firmware (isl3887usb_bare)!\n")=
;
-		return err;
+		goto err_req_fw_failed;
 	}
=20
 	p54_parse_firmware(dev, fw_entry);
@@ -499,7 +501,10 @@ static int p54u_upload_firmware_3887(str
=20
   err_upload_failed:
 	release_firmware(fw_entry);
+  err_req_fw_failed:
+  err_reset:
 	kfree(buf);
+  err_bufalloc:
 	return err;
 }
=20
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
