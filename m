Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:13091 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603AbXJUBiq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Oct 2007 21:38:46 -0400
Received: by ug-out-1314.google.com with SMTP id z38so768811ugc
        for <linux-wireless@vger.kernel.org>; Sat, 20 Oct 2007 18:38:45 -0700 (PDT)
To: rt2400-devel@lists.sourceforge.net
Subject: Re: [Rt2400-devel] rt73usb: support for wireless in Kohjinsha subnotebook
Date: Sun, 21 Oct 2007 00:12:36 +0200
Cc: Pavel Machek <pavel@ucw.cz>,
	kernel list <linux-kernel@vger.kernel.org>,
	linux-wireless@vger.kernel.org, mwallis@serialmonkey.com
References: <20071020184100.GA11640@elf.ucw.cz>
In-Reply-To: <20071020184100.GA11640@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200710210012.37547.IvDoorn@gmail.com> (sfid-20071021_023916_379625_6C0CF417)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> Kohjinsha subnotebook seems to contain wifi with USB IDs 0x18e8,
> 0x6206... I hope that to be compatible with
> net/wireless/rt2x00/rt73usb.c .

Is there any reason you assume it is a rt73usb device,
or are you just making wild guesses about what the chipset is?

> [Sidenote: could we add some real author info into rt73usb.c?]

You mean expanding the project name to the full list of developers in
the project? I don't see any need for that.

> I did this on 2.6.23-rc8-mm1 kernel (The RT hack may not be
> neccessary), but then it oopses somewhere in softmac layer. I'll try
> to play with it some more.
> 
> If you have any ideas, let me know.
> 								Pavel
> 
> --- clean-mm/drivers/net/wireless/rt2x00/rt73usb.c	2007-10-09 09:32:08.000000000 +0200
> +++ linux-mm/drivers/net/wireless/rt2x00/rt73usb.c	2007-10-19 22:19:45.000000000 +0200
> @@ -1580,7 +1580,6 @@
>  
>  	if (!rt2x00_rev(&rt2x00dev->chip, 0x25730)) {
>  		ERROR(rt2x00dev, "Invalid RT chipset detected.\n");
> -		return -ENODEV;
>  	}
>  
>  	if (!rt2x00_rf(&rt2x00dev->chip, RF5226) &&
> @@ -1588,7 +1587,6 @@
>  	    !rt2x00_rf(&rt2x00dev->chip, RF5225) &&
>  	    !rt2x00_rf(&rt2x00dev->chip, RF2527)) {
>  		ERROR(rt2x00dev, "Invalid RF chipset detected.\n");
> -		return -ENODEV;
>  	}

Both removals of -ENODEV are completely wrong. If the device does not pass the above
2 checks it is _not_ a rt73usb device. And forcing the driver to work with the device will
result in all kinds of problems.

If rt2x00 is loaded and detected the device, it should print out a debug message that starts with:
"Chipset detected - " What is in your case the complete line?

Ivo
