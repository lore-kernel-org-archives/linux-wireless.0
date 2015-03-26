Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:39614 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbbCZBQR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Mar 2015 21:16:17 -0400
From: Marek Vasut <marex@denx.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] rtlwifi: rtl8192cu: Add new device ID
Date: Thu, 26 Mar 2015 02:13:42 +0100
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Chaoming Li <chaoming_li@realsil.com.cn>
References: <1427318311-5690-1-git-send-email-marex@denx.de> <551357F3.4020406@lwfinger.net>
In-Reply-To: <551357F3.4020406@lwfinger.net>
MIME-Version: 1.0
Message-Id: <201503260213.42322.marex@denx.de> (sfid-20150326_021645_542488_8F26D499)
Content-Type: Text/Plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday, March 26, 2015 at 01:50:59 AM, Larry Finger wrote:
> On 03/25/2015 04:18 PM, Marek Vasut wrote:
> > Add new ID for ASUS N10 WiFi dongle.
> > 
> > Signed-off-by: Marek Vasut <marex@denx.de>
> > Cc: Larry Finger <Larry.Finger@lwfinger.net>
> > Cc: John W. Linville <linville@tuxdriver.com>
> > Cc: Chaoming Li <chaoming_li@realsil.com.cn>
> > ---
> > 
> >   drivers/net/wireless/rtlwifi/rtl8192cu/sw.c | 1 +
> >   1 file changed, 1 insertion(+)
> > 
> > Bus 001 Device 004: ID 0b05:17ba ASUSTek Computer, Inc.
> > 
> > Device Descriptor:
> >    bLength                18
> >    bDescriptorType         1
> >    bcdUSB               2.00

[...]

> > diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
> > b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c index 90a714c..d451d2b
> > 100644
> > --- a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
> > +++ b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
> > @@ -360,6 +360,7 @@ static struct usb_device_id rtl8192c_usb_ids[] = {
> > 
> >   	{RTL_USB_DEVICE(0x04f2, 0xaffb, rtl92cu_hal_cfg)}, /*Xavi*/
> >   	{RTL_USB_DEVICE(0x04f2, 0xaffc, rtl92cu_hal_cfg)}, /*Xavi*/
> >   	{RTL_USB_DEVICE(0x2019, 0x1201, rtl92cu_hal_cfg)}, /*Planex-Vencer*/
> > 
> > +	{RTL_USB_DEVICE(0x0b05, 0x17ba, rtl92cu_hal_cfg)}, /*ASUS-Edimax*/
> > 
> >   	/****** 8192CU ********/
> >   	{RTL_USB_DEVICE(0x050d, 0x1004, rtl92cu_hal_cfg)}, /*Belcom-SurfN300*/

Hi!

> The full dump from lsusb is a bit much for a commit message. All you need
> is the one line from lsusb with no switches set.

That's why I added it below the diffstat, so that it doesn't polute the commit 
message.

> According to the Vendor driver, which the comment indicates as the source
> of part of your patch,

In fact, the comment came from that same source file, from 0b05:17ab line.
The vendor is the same though, so I kept the comment.

> this particular device belongs in the "Customer ID"
> section under 8188CU, not where you placed it. In addition, I like to keep
> the USB IDs in numerical order within each section. Accordingly, your new
> ID should be between 0846:9041 and 0bda:5088.

OK.

> I am assuming that you have such a device. A statement that this change
> allows it to work should be in the commit message. If you have not tested,
> then you need to state that.

I have one and I tested it, I mostly checked the other commit messages and
wrote the same thing. It's a rather mindless change afterall.
