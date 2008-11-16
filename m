Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.187]:1259 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541AbYKPKBx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Nov 2008 05:01:53 -0500
Received: by nf-out-0910.google.com with SMTP id d3so979712nfc.21
        for <linux-wireless@vger.kernel.org>; Sun, 16 Nov 2008 02:01:50 -0800 (PST)
Message-ID: <491FEF89.3040100@gmail.com> (sfid-20081116_110214_016313_8BCFAE45)
Date: Sun, 16 Nov 2008 10:01:45 +0000
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Andrey Borzenkov <arvidjaar@mail.ru>,
	orinoco-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
Subject: Re: [Orinoco-devel] Agere PCMCIA sometimes takes very long time to
 associate with 9.48 FW
References: <200810191436.13298.arvidjaar@mail.ru> <491349BC.8090606@gmail.com> <49134F66.4020608@gmail.com> <200811151115.48750.arvidjaar@mail.ru> <20081115145655.GB31553@tuxdriver.com>
In-Reply-To: <20081115145655.GB31553@tuxdriver.com>
Content-Type: text/plain; charset=us-ascii
From: Dave <kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> On Sat, Nov 15, 2008 at 11:15:47AM +0300, Andrey Borzenkov wrote:
> 
>> - we should not be doing it in ->open. It is technically legal to set
>> wireless parameters before "icfonfig up" and we lose all of them. I will
>> try next week with similar patch in orinoco_stop().
> 
> That seems wrong...
> 
>> - I am still not even sure we should do it at all. What is sematic of
>> ifconfig up/down w.r.t. wireless parameters? I.e. is "ifconfig down"
>> expected to clean all device state and start from scratch?
> 
> No.  Unfortunately, it is mostly a matter of opinion as to what
> wireless extensions expects.

Agreed with all the above. I'll discard the driver patch.

There are two other things I can think of:

1. make sure wpa_supplicant is shut down before ifconfig ethX down, and
restart it on resume.

>From the data you've provided it looks like your distribution brings the
device down, but may leave wpa_supplicant running. I've noticed that
every time wpa_supplicant shuts down it removes most configuration
settings. Or has that changed?

2. Does the driver need to send a dissociation event (or something) to
userspace on ifconfig down?



Dave.
