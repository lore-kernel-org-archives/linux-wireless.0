Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49328 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864Ab1JTDiW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Oct 2011 23:38:22 -0400
Received: by iaek3 with SMTP id k3so2897609iae.19
        for <linux-wireless@vger.kernel.org>; Wed, 19 Oct 2011 20:38:21 -0700 (PDT)
Message-ID: <4E9F97B4.5010304@lwfinger.net> (sfid-20111020_053827_050299_1E35F272)
Date: Wed, 19 Oct 2011 22:38:28 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: v4mp <gaigo88@hotmail.it>
CC: linux-wireless@vger.kernel.org
Subject: Re: Alfa AWUS036NHR with RTL8188RU chipset
References: <4E77F631.3030202@googlemail.com> <loom.20110930T160704-310@post.gmane.org> <4E85DDA9.3090300@lwfinger.net> <loom.20110930T195810-426@post.gmane.org> <loom.20111006T181210-236@post.gmane.org> <4E8E2659.3060808@lwfinger.net> <loom.20111008T181929-517@post.gmane.org> <4E907FB8.1040101@lwfinger.net> <CA+XFjio+on2rUymoSZNxOWKMX9  xOn5hutA6q01r0yBeOXz0ivw@mail.gm ail.com> <loom.20111009T161348-133@post.gmane.org> <4E91B400.1020305@lwfinger.net> <loom.20111015T1  61652-440@post.gmane.org> <4E9A4647.60901@lwfinger.net> <loom.20111017T115802-634@post.gmane.org > <4E9C42CF.5010702@lwfinger.net> <loom.20111017T190430-717@post.gmane.org> <4E9CF13A.7060102@lwf inger.net> <loom.20111018T143746-420@post.gmane.org> <loom.201110 18T150303-359@post.gmane.org> <4E9D9953.3020601@lwfinger.net> <loom.20111018T233233-298@post.gmane.org> <4E9E052F.8090705@lwfinger.net> <loom.20111019T101621-921@post.gmane.org> <4E9EBDD3.6060907@lwfinger.net> <loom.20111019T162518-352@post.gmane.org>
In-Reply-To: <loom.20111019T162518-352@post.gmane.org>
Content-Type: multipart/mixed;
 boundary="------------030306040105090502060304"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030306040105090502060304
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 10/19/2011 09:37 AM, v4mp wrote:
>
>
> ok, i've done what you asked me with usbmon,
> but i'm not sure that is what you want
>
> i've redone dumping dmesg trying to grab the information you are lookin for
>
> i can't upload it on pastebin cause it's too large, i uploaded logs on megaupload
>
> http://www.megaupload.com/?d=3D0QS1MX

I got the data. Thanks. It will take a while to analyze the usbmon data, but 
there is something I would like you to try. It will involve getting the kernel 
source for some recent kernel, and applying the attached patch. With it, 
xhci-hcd will dump the stack whenever the "short transfer on control ep" or "no 
room on ep ring" errors occur. Send me those parts of the dmesg output, but 
again do the dump early before the buffer wrap around happens.

Larry


--------------030306040105090502060304
Content-Type: text/plain;
 name="xhci_debug"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="xhci_debug"

Index: wireless-testing-new/drivers/usb/host/xhci-ring.c
===================================================================
--- wireless-testing-new.orig/drivers/usb/host/xhci-ring.c
+++ wireless-testing-new/drivers/usb/host/xhci-ring.c
@@ -1616,6 +1616,7 @@ static int process_ctrl_td(struct xhci_h
 	int ep_index;
 	struct xhci_ep_ctx *ep_ctx;
 	u32 trb_comp_code;
+	static int count;
 
 	slot_id = TRB_TO_SLOT_ID(le32_to_cpu(event->flags));
 	xdev = xhci->devs[slot_id];
@@ -1641,6 +1642,8 @@ static int process_ctrl_td(struct xhci_h
 		break;
 	case COMP_SHORT_TX:
 		xhci_warn(xhci, "WARN: short transfer on control ep\n");
+		if (count++ < 5)
+			dump_stack();
 		if (td->urb->transfer_flags & URB_SHORT_NOT_OK)
 			*status = -EREMOTEIO;
 		else
@@ -2429,6 +2432,7 @@ static void queue_trb(struct xhci_hcd *x
 static int prepare_ring(struct xhci_hcd *xhci, struct xhci_ring *ep_ring,
 		u32 ep_state, unsigned int num_trbs, gfp_t mem_flags)
 {
+	static int count;
 	/* Make sure the endpoint has been added to xHC schedule */
 	switch (ep_state) {
 	case EP_STATE_DISABLED:
@@ -2459,6 +2463,8 @@ static int prepare_ring(struct xhci_hcd
 	if (!room_on_ring(xhci, ep_ring, num_trbs)) {
 		/* FIXME allocate more room */
 		xhci_err(xhci, "ERROR no room on ep ring\n");
+		if (count++ < 5)
+			dump_stack();
 		return -ENOMEM;
 	}
 

--------------030306040105090502060304--
