Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtpout3.wanadoo.co.uk ([80.12.242.59]:43948 "EHLO
	smtpout.wanadoo.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754400Ab3DSQCn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Apr 2013 12:02:43 -0400
Date: Fri, 19 Apr 2013 18:02:38 +0200 (CEST)
From: nick@nhthomas.freeserve.co.uk
Reply-To: nick@nhthomas.freeserve.co.uk
To: Mohammed Shafi <shafi.wireless@gmail.com>,
	nick@nhthomas.freeserve.co.uk
Cc: linux-wireless@vger.kernel.org
Message-ID: <23483845.51131366387358698.JavaMail.www@wwinf3715> (sfid-20130419_180253_317200_665A1309)
In-Reply-To: <CAD2nsn3GicfGbmwNOpdFP8kKgO0X6HU1bcRBHiP89p2UaLsxxg@mail.gmail.com>
Subject: Re: ath6kl_usb - ping problems when compiled for sh4.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


I see a problem with the ath6kl driver in wmi.c.
In the ath6kl_wmi_dix_2_dot3 function there is a memcpy being used with overlapping memory pointers.

I see that skb_push is used to add 8 bytes of llc_snap header space.
Then, a memcpy is used to copy the original 14bytes of Destination MAC + Source MAC + Type fields.

But, that 14 byte block is longer than the 8 byte new area.

Effectively, what is happening is that a new block of 8 bytes is added to the head.
Then the exising eth_hdr data is moved up by 8 bytes to take up the new space, but there is ovelap of memory pointers.
And, memcpy doesn't behave properly like that.

It's causing MAC address corruption.

Anyone else agree with this?


Regards

Nick

> Message Received: Mar 22 2013, 05:28 AM
> From: "Mohammed Shafi"
> To: nick@nhthomas.freeserve.co.uk
> Cc: linux-wireless@vger.kernel.org
> Subject: Re: ath6kl_usb - ping problems when compiled for sh4.
>
> On Thu, Mar 21, 2013 at 7:55 PM, wrote:
> > Hi Mohammed,
> >
> > OK, so I added the same printks further down in that function.
> > There is a memcpy in there, and I added the same debug just after the memcpy.
> >
> > And, the eth_hdr->h_dest has been changed to a wrong MAC address - by something.
> >
> > And, it must be something wrong in skb_push .
>
> good Nick, I' ll try to analyze this.
> what platform are you using ? (is it a big/little endian)
>
> >
> >
> > Regards
> >
> > Nick
> >
> >
> >
> >
> >> Message Received: Mar 21 2013, 02:09 PM
> >> From: nick@nhthomas.freeserve.co.uk
> >> To: "Mohammed Shafi"
> >> Cc: linux-wireless@vger.kernel.org
> >> Subject: Re: ath6kl_usb - ping problems when compiled for sh4.
> >>
> >>
> >> Hi Mohammed,
> >>
> >> I've added some debug at the top of ath6kl_wmi_dix_2_dot3 function.
> >>
> >> Just after:
> >>
> >> eth_hdr = (struct ethhdr *) skb->data;
> >> type = eth_hdr->h_proto;
> >>
> >> I added some debug to print all the values of eth_hdr->h_dest and eth_hdr->h_source .
> >> And, all look correct at that point.
> >>
> >> Regards
> >>
> >> Nick
> >>
> >>
> >> > Message Received: Mar 21 2013, 01:35 PM
> >> > From: nick@nhthomas.freeserve.co.uk
> >> > To: "Mohammed Shafi"
> >> > Cc: linux-wireless@vger.kernel.org
> >> > Subject: Re: ath6kl_usb - ping problems when compiled for sh4.
> >> >
> >> > Hi Mohammed,
> >> >
> >> > What do you need to me to do on this?
> >> > I see that function in the wmi.c file.
> >> >
> >> > Do you want me to add some debug printk's in there somewhere?
> >> >
> >> > Regards
> >> >
> >> > Nick
> >> >
> >> > > Message Received: Mar 21 2013, 11:42 AM
> >> > > From: "Mohammed Shafi"
> >> > > To: nick@nhthomas.freeserve.co.uk
> >> > > Cc: linux-wireless@vger.kernel.org
> >> > > Subject: Re: ath6kl_usb - ping problems when compiled for sh4.
> >> > >
> >> > > On Wed, Mar 20, 2013 at 10:33 PM, wrote:
> >> > > >
> >> > > > Here is another example, taken from Wireshark.
> >> > > > It's an ARP response, effectively saying IP address 192.168.0.107 is at 00:03:7f:20:50:59
> >> > > >
> >> > > > This is a message coming out of the wifi adaptor, and the above numbers are the IP address, and MAC address of the wifi device.
> >> > > >
> >> > > > 7f 20 50 59 00 24 00 03 7f 20 50 59 08 06 00 01
> >> > > > 08 00 06 04 00 02 00 03 7f 20 50 59 c0 a8 00 07
> >> > > > 20 cf 30 94 83 7b c0 a8 00 65
> >> > > >
> >> > > > What we see here is the Destination MAC address is 7f:20:50:59:00:24 (first 6 bytes).
> >> > > > But that's wrong. It should be 20:cf:30:94:83:7b .
> >> > > >
> >> > > > The other parts look right though:
> >> > > > 00:03:7f:20:50:59 is the MAC of the wifi device.
> >> > > > c0 a8 00 65 is 192.168.0.101 which is the IP address of the destination.
> >> > > > c0 a8 00 07 is the IP address of the wifi adaptor itself.
> >> > >
> >> > > let us check in ath6kl_wmi_dix_2_dot3, that should give us some clue.
> >> > >
> >> > > >
> >> > > > So, where in the code is the first 6 bytes generated ?
> >> > > >
> >> > > >
> >> > > > Regards
> >> > > >
> >> > > > Nick
> >> > >
> >> > >
> >> > >
> >> > > --
> >> > > thanks,
> >> > > shafi
> >> > > --
> >> > > To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> >> > > the body of a message to majordomo@vger.kernel.org
> >> > > More majordomo info at http://vger.kernel.org/majordomo-info.html
> >> > >
> >> >
> >> > --
> >> > To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> >> > the body of a message to majordomo@vger.kernel.org
> >> > More majordomo info at http://vger.kernel.org/majordomo-info.html
> >> >
> >>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at http://vger.kernel.org/majordomo-info.html
> >>
> >
>
>
>
> --
> thanks,
> shafi
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
>

