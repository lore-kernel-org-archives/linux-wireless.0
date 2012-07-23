Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:33717 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312Ab2GWHBO (ORCPT
	<rfc822;groupwise-linux-wireless@vger.kernel.org:0:0>);
	Mon, 23 Jul 2012 03:01:14 -0400
Received: by bkwj10 with SMTP id j10so4837190bkw.19
        for <linux-wireless@vger.kernel.org>; Mon, 23 Jul 2012 00:01:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120719145430.GA4231@redhat.com>
References: <1342667903-27314-1-git-send-email-machen@suse.com>
	<20120719145430.GA4231@redhat.com>
Date: Mon, 23 Jul 2012 15:01:08 +0800
Message-ID: <CALx5=V8Sz_CiqQvX-N1hscmpYa7GTO2YfukS8BJc1YChLFmd5Q@mail.gmail.com> (sfid-20120723_090117_794484_7ABA0D71)
Subject: Re: [rt2x00-users] [PATCH] rt2x00 : fix rt3290 resuming failed.
From: Matt Chen <machen@suse.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: users@rt2x00.serialmonkey.com, kevin.chou@mediatek.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stanislaw,

2012/7/19 Stanislaw Gruszka <sgruszka@redhat.com>:
> On Thu, Jul 19, 2012 at 11:18:23AM +0800, Chen, Chien-Chia wrote:
>> +     if (rt2x00_rt(rt2x00dev,RT3290)){
> Please add space after a comma.
>
>> +             retval = rt2800_enable_wlan_rt3290(rt2x00dev);
>> +             if (retval)
>> +                     return -EBUSY;
>> +     }
> Since we enabling device here, it's probably not needed to do this on
> rt2800pci_probe_hw, or I'm wrong?
>
>> +                     if ((rt2x00_get_field32(reg, PLL_LD) == 1) &&
>> +                             (rt2x00_get_field32(reg, XTAL_RDY) == 1))
>> +                                     break;
> Use proper coding style here (see below). Seems you did not copy this
> function from rt2800pci.c, but take it form other source, so it could
> miss some other changes as well.
will fix it.
>> +
>> +                     rt2800_register_write(rt2x00dev, 0x58, 0x018);
>> +                     udelay(REGISTER_BUSY_DELAY);
>> +                     rt2800_register_write(rt2x00dev, 0x58, 0x418);
>> +                     udelay(REGISTER_BUSY_DELAY);
>> +                     rt2800_register_write(rt2x00dev, 0x58, 0x618);
> We really like to know what those black magic numbers mean.
I have no idea, Ralink gave it to me for the fixing.
>> -                     if (rt2x00_get_field32(reg, PLL_LD) &&
>> -                         rt2x00_get_field32(reg, XTAL_RDY))
>> -                             break;
> Here is how above part should look like.
Sounds good to me. :)
> Stanislaw
>



-- 
Thank you.
