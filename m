Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:46712 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755341Ab1ALCxH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jan 2011 21:53:07 -0500
Received: by mail-wy0-f178.google.com with SMTP id 42so122888wyb.23
        for <linux-wireless@vger.kernel.org>; Tue, 11 Jan 2011 18:53:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <0826983CC0CB074798C42E77D8ACD07F0683E0@pdtms1.pdt.com>
References: <0826983CC0CB074798C42E77D8ACD07F067DE7@pdtms1.pdt.com>
	<AANLkTinjGLvWbSnfeNoUkoC2q4jN+uRntSYS6MAvm1vv@mail.gmail.com>
	<0826983CC0CB074798C42E77D8ACD07F0683D3@pdtms1.pdt.com>
	<0826983CC0CB074798C42E77D8ACD07F0683E0@pdtms1.pdt.com>
Date: Tue, 11 Jan 2011 20:53:04 -0600
Message-ID: <AANLkTikgPPvQP7QP5_EvBQapZ78nbcZs51mFPDKBDRoz@mail.gmail.com>
Subject: Re: What pieces are needed for wl1271..what directories, files,
 configs, etc..
From: "Krakowski, Oz" <ozk@ti.com>
To: "Brzezowski, Karen" <Karen.Brzezowski@pdt.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 11, 2011 at 1:41 PM, Brzezowski, Karen
<Karen.Brzezowski@pdt.com> wrote:
> ok, so far, I found the Makefile in the wl12xx directory from git clone git://git.kernel.org/pub/scm/linux/kernel/git/luca/wl12xx.git has 2.6.37-rc6
> in it.  so it's the 37-rc6 kernel, correct?
Yes.

>
> Can I use this "stuff" in the 2.6.31 kernel?  (I know what's said in the wiki info below..)

Yes, as long as you follow the guidelines described in the wiki page
regarding how to port the driver to older kernel versions - through
compat-wirelss and the additional patches described there.
Compat-wireless is described on the linuxwireless.org website in
length. Check it out here:
http://linuxwireless.org/en/users/Download/stable/

Regards,
Oz.

>
> I just don't know what goes where, how...
>
> :-)
> ________________________________________
> From: linux-wireless-owner@vger.kernel.org [linux-wireless-owner@vger.kernel.org] on behalf of Brzezowski, Karen [Karen.Brzezowski@pdt.com]
> Sent: Tuesday, January 11, 2011 1:05 PM
> To: Krakowski, Oz
> Cc: linux-wireless@vger.kernel.org
> Subject: RE: What pieces are needed for wl1271..what directories, files, configs, etc..
>
> Hi Oz,
>
> Thank you for your response.  I have been looking at that web page:
> http://linuxwireless.org/en/users/Drivers/wl12xx
>
> when i get the latest driver at
> git clone git://git.kernel.org/pub/scm/linux/kernel/git/luca/wl12xx.git
>
> Do I take everything that comes in this compressed file and replace it in a Linux kernel?
> Which Linux kernel is this driver code for?
>
> I'm not really sure what the compat-wireless is...we are using the Linux 2.6.31 kernel
> Do I need to get compat-wireless somehow for the 31 kernel?
>
> Then the notes say integrations needs to be gotten for SDIO, Lenient, and platform data pasing..
>
> Then the notes say I need WL127x firmware...
>
> after all that I can build the kernel?
>
> Do you have any example code that uses the interfaces for the wl1271 chip (the APIs)?
>
> I've never ported a driver in Linux before...
> I assumed all it would be is to get the driver directory corresponding to the new chip, adding or replacing it
> in the drivers directory, build it, and voila, i have a driver to test..
>
> I think I should not have assumed that, correct?
>
> ...this is why I'm confused........
> :-)
> thank you for your time!!!!!!!!!!
> Karen
>
> ________________________________________
> From: linux-wireless-owner@vger.kernel.org [linux-wireless-owner@vger.kernel.org] on behalf of Krakowski, Oz [ozk@ti.com]
> Sent: Tuesday, January 11, 2011 12:13 AM
> To: Brzezowski, Karen
> Cc: linux-wireless@vger.kernel.org
> Subject: Re: What pieces are needed for wl1271..what directories, files, configs, etc..
>
> Hi Karen,
>
> On Mon, Jan 10, 2011 at 10:44 AM, Brzezowski, Karen
> <Karen.Brzezowski@pdt.com> wrote:
>>
>> Hello all wireless gurus!!
>>
>> I've been watching the linux-wireless mailings on the wl1271...........
>>
>> I've been trying to figure out how to get the wl1271 working with
>> imx233 processor...
>>
>> I think we are moving to Linux 2.6.35 and android gingerbread (2.3)...
>>
>> I"m very confused as to what files/configs/etc..need to be grabbed to get my task going.......
>>
>> I see spi, sdio...not sure where all changes are made for the wl1271...i'm assuming
>> not just in the ...net/wireless/wl1271 directory.......... i have firmware too...........(.bins..)
>>
>> I'm quite confused about the chip and how each part will work (BT, WLAN, and FM)...
>> Do you have any documentation..(for dummies, that would be me!)
>> that would help me understand about the chip..how it communicates to the processor,
>> how it does it's job with respect to BT, WLAN, and FM, etc..
>>
>> I have NO idea where to begin.......I've been googling and reading and I have downloaded
>> your wl12xx git........
>
> If you haven't done so already, suggest you start by going through the
> following wiki page: http://linuxwireless.org/en/users/Drivers/wl12xx
> This should give you an idea of where to get the latest code, how to
> compile it to your kernel (using compat-wireless) and links to the
> relevant patches needed.
> This will get you started with WLAN.
>
>>
>> If you can help me AT ALL to get me up to speed/ to start, what i need to do to connect
>> the wl1271 to the imx233....if not imx233..that whatever you have........
>
> The wiki page does include some basic information needed in order to
> port to different hardware platforms.
>
> Regards,
> Oz.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
