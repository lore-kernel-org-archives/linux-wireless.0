Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:40562 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S935600AbcCQUuK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2016 16:50:10 -0400
Date: Thu, 17 Mar 2016 16:50:09 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: poma <pomidorabelisima@gmail.com>
cc: Jes Sorensen <Jes.Sorensen@redhat.com>,
	Xose Vazquez Perez <xose.vazquez@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: rtl8xxxu 4.4.5(from f23): I get a panic adding a new device to
 the driver
In-Reply-To: <56EB0D15.9040103@gmail.com>
Message-ID: <Pine.LNX.4.44L0.1603171648490.1346-100000@iolanthe.rowland.org> (sfid-20160317_215014_673662_48CABA0D)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 17 Mar 2016, poma wrote:

> On 17.03.2016 19:02, Jes Sorensen wrote:
> > Jes Sorensen <Jes.Sorensen@redhat.com> writes:
> >> Xose Vazquez Perez <xose.vazquez@gmail.com> writes:
> >>> Hi,
> >>>
> >>> If I do:
> >>> # echo "0bda 8176" > /sys/bus/usb/drivers/rtl8xxxu/new_id
> >>
> >> Hi Xose,
> >>
> >> Yes please don't do that. The rtl8xxxu driver relies on the .driver_info
> >> field in struct use_device_id to carry information for the different
> >> types of devices. If you hot add a device like above, the driver will
> >> fail because that field now contains a NULL pointer.
> >>
> >> I should probably add a check for it in the probe function, but it will
> >> simply be there to spit out a warning that it doesn't work to hot add a
> >> device like this.
> >>
> >> If you build it with CONFIG_RTL8XXXU_UNTESTED the 0bda:8176 should be
> >> included in the device list.
> >>
> >> Cheers,
> >> Jes
> > 
> > Hi Xose,
> > 
> > I added the following patch to my tree to avoid this.
> > 
> > Cheers,
> > Jes
> > 
> > commit 9202f4947aac1d60084ee79c9b5294eb42ba59dc
> > Author: Jes Sorensen <Jes.Sorensen@redhat.com>
> > Date:   Thu Mar 17 13:53:48 2016 -0400
> > 
> >     rtl8xxxu: Fix OOPS if user tries to add device via /sys
> >     
> >     This driver relies on driver_info in struct usb_device_id, hence
> >     adding a device via  /sys/bus/usb/drivers/rtl8xxxu/new_id would result
> >     in a NULL pointer dereference.
> >     
> >     Instead print a message and return -ENODEV
> >     
> >     Reported-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> >     Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
> > 
> > diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
> > index 8d893f4..55fc00e 100644
> > --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
> > +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
> > @@ -9671,6 +9671,15 @@ static int rtl8xxxu_probe(struct usb_interface *interface,
> >  
> >  	udev = usb_get_dev(interface_to_usbdev(interface));
> >  
> > +	if (!id->driver_info) {
> > +		dev_warn(&udev->dev,
> > +			 "rtl8xxxu relies on driver_info in struct usb_device_id.\n");

You should leave out this line.  It won't mean anything to the general
user.

Alan Stern

