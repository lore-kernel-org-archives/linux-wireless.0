Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46834 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757676AbYJJSV1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2008 14:21:27 -0400
Date: Fri, 10 Oct 2008 14:18:41 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-wireless@vger.kernel.org, bugme-daemon@bugzilla.kernel.org,
	zOOmER.gm@gmail.com
Subject: Re: [Bugme-new] [Bug 11728] New: 2.6.27 RTL8187b wireless driver
	missing card support 0bda:8198
Message-ID: <20081010181841.GA20509@tuxdriver.com> (sfid-20081010_202132_586960_BEA58DED)
References: <bug-11728-10286@http.bugzilla.kernel.org/> <20081010103108.7a7a3fbf.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20081010103108.7a7a3fbf.akpm@linux-foundation.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 10, 2008 at 10:31:08AM -0700, Andrew Morton wrote:
> 
> (switched to email.  Please respond via emailed reply-to-all, not via the
> bugzilla web interface).
> 
> On Fri, 10 Oct 2008 08:29:17 -0700 (PDT) bugme-daemon@bugzilla.kernel.org wrote:
> 
> > http://bugzilla.kernel.org/show_bug.cgi?id=11728
> > 
> >            Summary: 2.6.27 RTL8187b wireless driver missing card support
> >                     0bda:8198
> >            Product: Drivers
> >            Version: 2.5
> >      KernelVersion: 2.6.27
> >           Platform: All
> >         OS/Version: Linux
> >               Tree: Mainline
> >             Status: NEW
> >           Severity: normal
> >           Priority: P1
> >          Component: Network
> >         AssignedTo: jgarzik@pobox.com
> >         ReportedBy: zOOmER.gm@gmail.com
> > 
> > 
> > Hardware Environment: Toshiba Satellite L300-110 laptop (with built-in USB
> > wireless card RTL8187b, DEVICE ID 0bda:8198)
> > 
> > Problem Description:
> > 2.6.27 Kernel cannot detect wireless card.
> > 
> > Problem goes out, if in rtl8187_dev.c file i add a line with this card DEVID:
> > {USB_DEVICE(0x0bda, 0x8198), .driver_info = DEVICE_RTL8187B},
> > After this done and recompiling module, card works fine(tested it for hours
> > with WEP and without authentication)
> > 
 
From: John W. Linville <linville@tuxdriver.com>
Subject: [PATCH] rtl8187: add device ID 0bda:8198

Reported by zOOmER.gm@gmail.com to work here:

	http://bugzilla.kernel.org/show_bug.cgi?id=11728

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/rtl8187_dev.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rtl8187_dev.c b/drivers/net/wireless/rtl8187_dev.c
index ae21191..fb3309f 100644
--- a/drivers/net/wireless/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl8187_dev.c
@@ -37,6 +37,7 @@ static struct usb_device_id rtl8187_table[] __devinitdata = {
 	{USB_DEVICE(0x0bda, 0x8187), .driver_info = DEVICE_RTL8187},
 	{USB_DEVICE(0x0bda, 0x8189), .driver_info = DEVICE_RTL8187B},
 	{USB_DEVICE(0x0bda, 0x8197), .driver_info = DEVICE_RTL8187B},
+	{USB_DEVICE(0x0bda, 0x8198), .driver_info = DEVICE_RTL8187B},
 	/* Netgear */
 	{USB_DEVICE(0x0846, 0x6100), .driver_info = DEVICE_RTL8187},
 	{USB_DEVICE(0x0846, 0x6a00), .driver_info = DEVICE_RTL8187},
-- 
1.5.4.3


-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
