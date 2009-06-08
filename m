Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.moondrake.net ([212.85.150.166]:54510 "EHLO
	mx1.mandriva.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753303AbZFHRjc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jun 2009 13:39:32 -0400
To: Forest Bond <forest@alittletooquiet.net>
Cc: =?iso-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>,
	Greg KH <greg@kroah.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH] Add vt6656 driver to drivers/staging.
References: <20090414105200.GE25746@storm.local.network>
	<69e28c910906010935n28f69921xd589a945e982ca1@mail.gmail.com>
	<20090601165207.GA12481@alittletooquiet.net>
From: Olivier Blin <blino@mandriva.com>
Date: Mon, 08 Jun 2009 19:08:14 +0200
In-Reply-To: <20090601165207.GA12481@alittletooquiet.net> (Forest Bond's message of "Mon\, 1 Jun 2009 12\:52\:07 -0400")
Message-ID: <m3prdeac1t.fsf@dynamo.mandriva.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Forest Bond <forest@alittletooquiet.net> writes:

> Hi,
>
> On Mon, Jun 01, 2009 at 06:35:35PM +0200, Gábor Stefanik wrote:
>> On Tue, Apr 14, 2009 at 12:52 PM, Forest Bond
>> <forest@alittletooquiet.net> wrote:
>> > This patch adds the vt6656 driver to drivers/staging.  This code was literally
>> > copied from the upstream source archive, available here:
>> >
>> >  http://www.viaarena.com/Driver/VT6656_Linux_src_v1.19_12_x86.zip
>> >
>> > Copyright: VIA Networking Technologies, Inc.
>> > License: GPL
>> > Authors: Jerry Chen, Kyle Hsu, Lucas Lin, Lyndon Chen, Tevin Chen, Warren Hsu,
>> >         Yiching Chen
>> > Signed-off-by: Forest Bond <forest@alittletooquiet.net>
>> >
>> > Patch: http://www.alittletooquiet.net/media/code/0002-Add-vt6656-driver-to-drivers-staging.patch.gz
>> > Signature: http://www.alittletooquiet.net/media/code/0002-Add-vt6656-driver-to-drivers-staging.patch.gz.sig
>> 
>> Did this patch (along with the vt6655 one) somehow get lost? I can't
>> see it in drivers/staging.
>
> vt6655 is in drivers/staging on linux-next, although I have three more patches
> that I'll be sending to Greg sometime tonight.  He has been applying them for
> me.
>
> vt6656 is currently delayed a bit.  I may be able to get a start on that
> tonight, as well, but there is likelihood of further delay.

By the way, are you sure about the hook below about wpactl.c in commit
8f2c32b86b3ac16ba4c93bf0c2b766089644d9d1 ?

If I do the same in vt6656, it is freezing the kernel, or causing random
crashes. Removing the netdev priv assignation makes the driver ok.
I don't think the wpa priv was really useful, but I fail to see where it
was used, and why it caused the hang.

Don't you have the same issue with vt6655?

BTW, I have some patches to send for vt6656, what is the proper place to
submit them since vt6656 is not in staging for now?

diff --git a/drivers/staging/vt6655/wpactl.c b/drivers/staging/vt6655/wpactl.c
index ee7109d..cc4f0ad 100644 (file)
--- a/drivers/staging/vt6655/wpactl.c
+++ b/drivers/staging/vt6655/wpactl.c
@@ -112,14 +112,17 @@ static void wpadev_setup(struct net_device *dev)
 
 static int wpa_init_wpadev(PSDevice pDevice)
 {
+    PSDevice wpadev_priv;
        struct net_device *dev = pDevice->dev;
          int ret=0;
 
-       pDevice->wpadev = alloc_netdev(0, "vntwpa", wpadev_setup);
+       pDevice->wpadev = alloc_netdev(sizeof(PSDevice), "vntwpa", wpadev_setup);
        if (pDevice->wpadev == NULL)
                return -ENOMEM;
 
-       pDevice->wpadev->priv = pDevice;
+    wpadev_priv = netdev_priv(pDevice->wpadev);
+    *wpadev_priv = *pDevice;
+
        memcpy(pDevice->wpadev->dev_addr, dev->dev_addr, U_ETHER_ADDR_LEN);
          pDevice->wpadev->base_addr = dev->base_addr;
        pDevice->wpadev->irq = dev->irq;

-- 
Olivier Blin (blino) - Mandriva
