Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.230]:29399 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937AbYI3JeL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Sep 2008 05:34:11 -0400
Received: by rv-out-0506.google.com with SMTP id k40so2776006rvb.1
        for <linux-wireless@vger.kernel.org>; Tue, 30 Sep 2008 02:34:10 -0700 (PDT)
Message-ID: <e001a6370809300234j7f84a9f0j50213e9912dd5c08@mail.gmail.com> (sfid-20080930_113419_483567_A03CF3A5)
Date: Tue, 30 Sep 2008 15:04:08 +0530
From: "Anadi Mishra" <reachanadi@gmail.com>
To: "Holger Schurig" <hs4233@mail.mn-solutions.de>
Subject: Re: Problem with Libertas USB8388 WLAN card firmware
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200809301018.31678.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <e001a6370809150258t10873497jcf04e68005db566b@mail.gmail.com>
	 <1221488871.10177.44.camel@localhost.localdomain>
	 <e001a6370809290106s57660209lf590579f11f67647@mail.gmail.com>
	 <200809301018.31678.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 30, 2008 at 1:48 PM, Holger Schurig
<hs4233@mail.mn-solutions.de> wrote:
> Your box looks hosed. I'd look into this things:
>
>> [ 230.175944] nommu_map_single: overflow 7f0000000012+1578 of
>> device mask ffffffff
>
> Why do you get this strange output all the time?

well thats the mystery......what I found out by googling is that there
seems to be a problem with PCI system on x86_64 (maybe not)

see this
http://www.ussg.iu.edu/hypermail/linux/kernel/0804.1/0222.html

Note: The same card is being detected on 32 bit machine nicely with
same driver!!!

regarding rest of the things u pointed out, its all greek to me (I am
noob). But could u plz tell me from where can i get the firmware
details of the card
USB8388??

thanks for the help.

>
>
>> [ 230.435363] libertas host: PREP_CMD: command 0x0003
>
> This seems ok (0x0003), but this:
>
> [ 230.435363] libertas leave: lbs_queue_cmd()
> [ 230.435363] libertas leave: __lbs_cmd_async(), ret ffff810037800000
>
> can't possibly be. The function returns an internet, not
> something like that.
>
>
>
> [ 230.433291] libertas DNLD_CMD: 03 00 2e 00 01 00 00 00 00 00 00 00 00 00 00 00
> [ 230.433291] libertas DNLD_CMD: ff ff ff ff ff ff 00 00 00 00 00 00 00 00 00 00
> [ 230.433291] libertas DNLD_CMD: 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>
> That hexdump looks sane at the first glance.
>
>
> [ 230.435363] usb8xxx usbd (INT): 1-8:Recv length = 0x32, Recv type = 0x160000
> [ 230.435363] usb8xxx usbd (INT): 1-8:Unknown command type 0x160000
>
> But the recv type again looks hosed. No wonder
> the driver doesn't like this command type.
>



-- 
Thanks and Regards,
Anadi Mishra,
Mumbai,
9987388960.
