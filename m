Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f180.google.com ([209.85.214.180]:42130 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932633Ab3CVF2W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Mar 2013 01:28:22 -0400
Received: by mail-ob0-f180.google.com with SMTP id wo10so1342747obc.39
        for <linux-wireless@vger.kernel.org>; Thu, 21 Mar 2013 22:28:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20245141.2361363875942985.JavaMail.www@wwinf3717>
References: <17341425.1561363874986481.JavaMail.www@wwinf3717>
	<20245141.2361363875942985.JavaMail.www@wwinf3717>
Date: Fri, 22 Mar 2013 10:58:21 +0530
Message-ID: <CAD2nsn3GicfGbmwNOpdFP8kKgO0X6HU1bcRBHiP89p2UaLsxxg@mail.gmail.com> (sfid-20130322_062843_728519_F228A325)
Subject: Re: ath6kl_usb - ping problems when compiled for sh4.
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: nick@nhthomas.freeserve.co.uk
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 21, 2013 at 7:55 PM,  <nick@nhthomas.freeserve.co.uk> wrote:
> Hi Mohammed,
>
> OK, so I added the same printks further down in that function.
> There is a memcpy in there, and I added the same debug just after the memcpy.
>
> And, the eth_hdr->h_dest has been changed to a wrong MAC address - by something.
>
> And, it must be something wrong in skb_push .

good Nick, I' ll try to analyze this.
what platform are you using ? (is it a big/little endian)

>
>
> Regards
>
> Nick
>
>
>
>
>> Message Received: Mar 21 2013, 02:09 PM
>> From: nick@nhthomas.freeserve.co.uk
>> To: "Mohammed Shafi"
>> Cc: linux-wireless@vger.kernel.org
>> Subject: Re: ath6kl_usb - ping problems when compiled for sh4.
>>
>>
>> Hi Mohammed,
>>
>> I've added some debug at the top of ath6kl_wmi_dix_2_dot3 function.
>>
>> Just after:
>>
>> eth_hdr = (struct ethhdr *) skb->data;
>> type = eth_hdr->h_proto;
>>
>> I added some debug to print all the values of eth_hdr->h_dest and eth_hdr->h_source .
>> And, all look correct at that point.
>>
>> Regards
>>
>> Nick
>>
>>
>> > Message Received: Mar 21 2013, 01:35 PM
>> > From: nick@nhthomas.freeserve.co.uk
>> > To: "Mohammed Shafi"
>> > Cc: linux-wireless@vger.kernel.org
>> > Subject: Re: ath6kl_usb - ping problems when compiled for sh4.
>> >
>> > Hi Mohammed,
>> >
>> > What do you need to me to do on this?
>> > I see that function in the wmi.c file.
>> >
>> > Do you want me to add some debug printk's in there somewhere?
>> >
>> > Regards
>> >
>> > Nick
>> >
>> > > Message Received: Mar 21 2013, 11:42 AM
>> > > From: "Mohammed Shafi"
>> > > To: nick@nhthomas.freeserve.co.uk
>> > > Cc: linux-wireless@vger.kernel.org
>> > > Subject: Re: ath6kl_usb - ping problems when compiled for sh4.
>> > >
>> > > On Wed, Mar 20, 2013 at 10:33 PM, wrote:
>> > > >
>> > > > Here is another example, taken from Wireshark.
>> > > > It's an ARP response, effectively saying IP address 192.168.0.107 is at 00:03:7f:20:50:59
>> > > >
>> > > > This is a message coming out of the wifi adaptor, and the above numbers are the IP address, and MAC address of the wifi device.
>> > > >
>> > > > 7f 20 50 59 00 24 00 03 7f 20 50 59 08 06 00 01
>> > > > 08 00 06 04 00 02 00 03 7f 20 50 59 c0 a8 00 07
>> > > > 20 cf 30 94 83 7b c0 a8 00 65
>> > > >
>> > > > What we see here is the Destination MAC address is 7f:20:50:59:00:24 (first 6 bytes).
>> > > > But that's wrong. It should be 20:cf:30:94:83:7b .
>> > > >
>> > > > The other parts look right though:
>> > > > 00:03:7f:20:50:59 is the MAC of the wifi device.
>> > > > c0 a8 00 65 is 192.168.0.101 which is the IP address of the destination.
>> > > > c0 a8 00 07 is the IP address of the wifi adaptor itself.
>> > >
>> > > let us check in ath6kl_wmi_dix_2_dot3, that should give us some clue.
>> > >
>> > > >
>> > > > So, where in the code is the first 6 bytes generated ?
>> > > >
>> > > >
>> > > > Regards
>> > > >
>> > > > Nick
>> > >
>> > >
>> > >
>> > > --
>> > > thanks,
>> > > shafi
>> > > --
>> > > To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> > > the body of a message to majordomo@vger.kernel.org
>> > > More majordomo info at http://vger.kernel.org/majordomo-info.html
>> > >
>> >
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at http://vger.kernel.org/majordomo-info.html
>> >
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>>
>



-- 
thanks,
shafi
