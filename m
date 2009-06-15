Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35702 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077AbZFOMYB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jun 2009 08:24:01 -0400
Subject: Re: rfkill regression in net-next-2.6
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Oliver Hartkopp <socketcan@hartkopp.net>,
	Marcel Holtmann <marcel@holtmann.org>,
	David Miller <davem@davemloft.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <20090615120422.GA2729@tuxdriver.com>
References: <20090604152011.GC2839@tuxdriver.com>
	 <20090607.033751.191866033.davem@davemloft.net>
	 <4A2BCC41.1060508@hartkopp.net> <20090607145830.GA2736@tuxdriver.com>
	 <4A2BD8A5.4040302@hartkopp.net>
	 <1244388583.23850.87.camel@localhost.localdomain>
	 <4A34BAB9.9000104@hartkopp.net>  <20090615120422.GA2729@tuxdriver.com>
Content-Type: text/plain
Date: Mon, 15 Jun 2009 14:24:46 +0200
Message-Id: <1245068686.23912.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-06-15 at 08:04 -0400, John W. Linville wrote:
> On Sun, Jun 14, 2009 at 10:54:17AM +0200, Oliver Hartkopp wrote:
> 
> > Any idea what changed in net-next-2.6 that could produce this behaviour?
> 
> The rfkill subsystem rewrite would seem suspect... :-)

Maybe this fixes it?

johannes

--- wireless-testing.orig/drivers/platform/x86/dell-laptop.c	2009-06-15 14:23:25.000000000 +0200
+++ wireless-testing/drivers/platform/x86/dell-laptop.c	2009-06-15 14:23:35.000000000 +0200
@@ -177,7 +177,7 @@ dell_send_request(struct calling_interfa
 static int dell_rfkill_set(void *data, bool blocked)
 {
 	struct calling_interface_buffer buffer;
-	int disable = blocked ? 0 : 1;
+	int disable = blocked ? 1 : 0;
 	unsigned long radio = (unsigned long)data;
 
 	memset(&buffer, 0, sizeof(struct calling_interface_buffer));


