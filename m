Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtps.newmedia-net.de ([185.84.6.167]:52725 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751314AbeBTTuA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Feb 2018 14:50:00 -0500
Subject: Re: [PATCH v7] ath10k: add LED and GPIO controlling support for
 various chipsets
To: Steve deRosier <derosier@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>, ath10k@lists.infradead.org,
        Sebastian Gottschall <s.gottschall@newmedia-net.de>
References: <20180220073259.17254-1-s.gottschall@dd-wrt.com>
 <CALLGbRLwmPLTEXDbnLy8Ba0G0CYXM2HehbgDy2HEz9BdBNx1sQ@mail.gmail.com>
 <a8958e0e-8f54-4869-d69a-2f29eae57f14@dd-wrt.com>
 <CALLGbR+GQHBcuoO=6BVJYLUhwQk=tv2juWBRDpkyrDtFedfn5Q@mail.gmail.com>
From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Message-ID: <248047fb-3805-5b49-bb98-6ace37bc31ca@dd-wrt.com> (sfid-20180220_205005_142899_451EB5E1)
Date: Tue, 20 Feb 2018 20:49:53 +0100
MIME-Version: 1.0
In-Reply-To: <CALLGbR+GQHBcuoO=6BVJYLUhwQk=tv2juWBRDpkyrDtFedfn5Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Agreed, I am also not a fan of bloat code. I wasn't suggesting you
> move it to the .h, just saying that if it were not static, that's how
> I'd suggest doing it.
>
> In this case, keep it static, keep it in the .c.  And use the blocking
> I suggested. You will get the optimizer friendly result you're looking
> for, but make it more readable and more-inline with the dominant style
> for these things.
thats what i did already in my sourcetree
>
>> true, but consider that required structures like gpio_chip (ar->gpio) and
>> led_classdev arent defined in the kernel if these CONFIG options arent
>> configured. so i may move it into a separate function ,but the guards will
>> remain.
>> thats not my fault. thats a fault of the kernel api.
>>
> Hm. I assumed the names were still valid, even if the functionality
> that uses it wasn't.  Understood.
>
> In that case, I suggest moving the code to a separate static function
> that can be guarded. It keeps the mess out of the main startup
> function, makes it easier to read as it collapses to a single
> self-documented function name, and gets rid of the label and jump.
yes but we have 2 guards. GPIOLIB and LED_CLASS
so the mess remaines in the same way with no change. the same unreadable 
code just moved (personally i think its not that unreadable since its small)

>
>>> The rest of this looks OK to me.
>> okay. i already changed some code, based on your requests but will wait for
>> reply of you and for other comments until i send out a new version
> I appreciate the extra work you've put in. I hadn't expected my
> comments would've generated so much extra work; sorry about that. It's
> looking good.
i just want it upstream. i have alot of usefull patches in my backhand 
and its now getting hard to maintain the code with new ath10k patches.
and at the end its not that much work as it seems. just a question of 
some seconds todo that changes. i can live with it.

Sebastian


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
