Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtps.newmedia-net.de ([185.84.6.167]:34831 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755599AbeBPQ5e (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Feb 2018 11:57:34 -0500
Subject: Re: [PATCH] v2 ath10k: add LED and GPIO controlling support for
 various chipsets
To: Steve deRosier <derosier@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>, ath10k@lists.infradead.org,
        Sebastian Gottschall <s.gottschall@newmedia-net.de>
References: <20180216103020.5009-1-s.gottschall@dd-wrt.com>
 <CALLGbRKVpXwZ12BbntX__OGhS3VLBNvRYRnuDGwTKMzu_eiK5Q@mail.gmail.com>
From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Message-ID: <8191f271-b217-66de-5d23-7adf30c088a9@dd-wrt.com> (sfid-20180216_175748_304291_6CB8A1EC)
Date: Fri, 16 Feb 2018 17:57:25 +0100
MIME-Version: 1.0
In-Reply-To: <CALLGbRKVpXwZ12BbntX__OGhS3VLBNvRYRnuDGwTKMzu_eiK5Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 16.02.2018 um 17:33 schrieb Steve deRosier:
> On Fri, Feb 16, 2018 at 2:30 AM,  <s.gottschall@dd-wrt.com> wrote:
>> From: Sebastian Gottschall <s.gottschall@newmedia-net.de>
>>
>> Adds LED and GPIO Control support for 988x, 9887, 9888, 99x0, 9984 and ipq4019 based chipsets with on chipset connected led's
>> using WMI Firmware API.
>> The LED device will get available named as "ath10k-phyX" at sysfs and can be controlled with various triggers.
>> adds also debugfs interface for gpio control.
>>
> Hi Sebastian,
>
> First off, let me say I love this and the effort to make the gpios
> hanging off the wifi chip as proper system gpios. Years ago I had to
> do a hack to make some wifi-chip provided pins available to a customer
> who needed more GPIOs on our SoM. It would have been nice if provided
> hardware functionality had already been properly supported by the
> driver.
>
> In looking through, it looks like you're hooking into the standard
> gpio-chip driver interface. Which is great. So, why are you providing
> a separate out-of-band debugfs access interface for gpio control?
this was developed first before the real gpio interface. that way you 
can poke manually values for testing
like gpio interrupt etc. which isnt exposed by the gpio and led 
interface. its only for diagnostic and is not neccessary, but
it was in my initial code so i did include it in that patch
> Seems to me to be a duplicate of the interface in sysfs that provides
> gpio access (`/sys/class/gpio`). My preference is we don't duplicate
> functionality and that we use the standard provided features. That way
> we don't possibly confuse users, and we also reduce our maintenance
> effort.
its not a duplicate as i said before it offers more flags which arent 
used by the rest
gpio config has 4 values. gpio num, input/output, pull_type, interrupt mode

but not all is used by the gpio controller driver
>
> Additionally, what happens when the relevant GPIO configuration
> options aren't enabled? Do we have a compilation issue?
you mean if led and gpio is not selected. mmh you get a compile error 
for sure. its unlikelly that its not enabled, but i can
take care of it in the next patch version
> I'm more
> familiar with being a _consumer_ of gpiolib in my drivers and I know
> if CONFIG_GPIOLIB isn't checked I end up with problems. I'm unsure
> what happens when you're presenting a gpio-chip interface without the
> relevant CONFIG_ being enabled. Note that I didn't test this, I'm just
> asking the question to be sure we don't forget anything.
you're absolutelly right. i will add these checks. i can say that i 
tested it on 9984, 998x and 988x devices so far
and the gpio and led code gets only registered on known to be working 
chipsets

Sebastian
>
> - Steve
>

-- 
Mit freundlichen Grüssen / Regards

Sebastian Gottschall / CTO

NewMedia-NET GmbH - DD-WRT
Firmensitz:  Stubenwaldallee 21a, 64625 Bensheim
Registergericht: Amtsgericht Darmstadt, HRB 25473
Geschäftsführer: Peter Steinhäuser, Christian Scheele
http://www.dd-wrt.com
email: s.gottschall@dd-wrt.com
Tel.: +496251-582650 / Fax: +496251-5826565
