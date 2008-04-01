Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.170]:3888 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241AbYDAQdJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Apr 2008 12:33:09 -0400
Received: by ug-out-1314.google.com with SMTP id z38so166611ugc.16
        for <linux-wireless@vger.kernel.org>; Tue, 01 Apr 2008 09:33:06 -0700 (PDT)
Message-ID: <787b0d920804010933p112212d6ha21a2d7022d8f627@mail.gmail.com> (sfid-20080401_173315_169570_31122995)
Date: Tue, 1 Apr 2008 12:33:05 -0400
From: "Albert Cahalan" <acahalan@gmail.com>
To: "Julian Calaby" <julian.calaby@gmail.com>
Subject: Re: Marvell 88w8335 [Libertas]
Cc: "Markus Becker" <mab@comnets.uni-bremen.de>,
	libertas-dev@lists.infradead.org, "Dan Williams" <dcbw@redhat.com>,
	andreamrl@tiscali.it, david@woodhou.se,
	linux-wireless@vger.kernel.org, dwmw2@infradead.org
In-Reply-To: <646765f40803190449m16421197m7519aeefab577920@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <Pine.LNX.4.64.0803191037220.21835@bugs.comnets.uni-bremen.de>
	 <646765f40803190449m16421197m7519aeefab577920@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 19, 2008 at 7:49 AM, Julian Calaby <julian.calaby@gmail.com> wrote:

>  I'm currently working on making this firmware extractor a little more
>  generic, and at the very least work successfully for all the drivers I
>  can gather for cards based upon these chips.

How about this one?
http://wiki.laptop.org/images/b/bd/Extract.txt

It gets the main firmware only. To fetch boot2,
you either need to use symbols (88W8385 driver)
or dump the eeprom (88W8388).

For an 88W8388 eeprom, boot2 length is at 0x0004
and boot2 offset (or "other junk" length) is at 0x0008.
Both are 32-bit. An eeprom image may be byte-swapped.

>  I intend to get some small part of it working this weekend - probably
>  the LED as a proof of concept - before starting on the real wireless
>  code. If you want to experience the joys of blinking LEDs, ping me and
>  I'll send you the code once it's working.

I do blinking LEDs too:
git clone git://dev.laptop.org/users/albert/usb8388
