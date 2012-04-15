Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout0.freenet.de ([195.4.92.90]:57820 "EHLO mout0.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752302Ab2DOMFb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Apr 2012 08:05:31 -0400
Received: from [195.4.92.142] (helo=mjail2.freenet.de)
	by mout0.freenet.de with esmtpa (ID andihartmann@freenet.de) (port 25) (Exim 4.76 #1)
	id 1SJOCv-00055j-Ti
	for linux-wireless@vger.kernel.org; Sun, 15 Apr 2012 14:05:29 +0200
Received: from localhost ([::1]:57551 helo=mjail2.freenet.de)
	by mjail2.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1SJOCv-0007Aj-Pm
	for linux-wireless@vger.kernel.org; Sun, 15 Apr 2012 14:05:29 +0200
Received: from [195.4.92.23] (port=37156 helo=13.mx.freenet.de)
	by mjail2.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1SJOAq-0006T1-EC
	for linux-wireless@vger.kernel.org; Sun, 15 Apr 2012 14:03:20 +0200
Received: from [2002:4fde:769:2:5054:ff:feb8:40bd] (port=47725 helo=mail.maya.org)
	by 13.mx.freenet.de with esmtpsa (ID andihartmann@freenet.de) (TLSv1:AES256-SHA:256) (port 25) (Exim 4.76 #1)
	id 1SJOAq-00024P-1I
	for linux-wireless@vger.kernel.org; Sun, 15 Apr 2012 14:03:20 +0200
Message-ID: <4F8AB8F9.4060503@01019freenet.de> (sfid-20120415_140603_932184_494F97D0)
Date: Sun, 15 Apr 2012 14:03:05 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
MIME-Version: 1.0
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
CC: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	IvDoorn@gmail.com, linville@tuxdriver.com, gwingerde@gmail.com,
	helmut.schaa@googlemail.com
Subject: Re: [rt2x00-users] [PATCH] wireless: rt2x00: rt2800usb add more devices
 ids
References: <1334448592-16391-1-git-send-email-xose.vazquez@gmail.com> <4F8A6CB6.4080006@01019freenet.de> <4F8A92A5.8090707@gmail.com>
In-Reply-To: <4F8A92A5.8090707@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Xose,

sorry for double post - I accidentally pressed the wrong answer button :-(.

Xose Vazquez Perez wrote:
> On 04/15/2012 08:37 AM, Andreas Hartmann wrote:
> 
>> Did you test them? What did you test exactly? What exactly works, what
>> does not?
> 
> NO. NOTHING . I DON'T KNOW. But...
> 
>> It doesn't mean anything, if they work with the legacy driver.
> 
> ..., the chips in these devices are *identified* . They perform so well
> or so badly like those that are already in the driver(rt2800usb).

This is an expectation. The mentioned WUSB600Nv2 is one proof, that it
isn't (always) enough to successfully identify chips and derive, that it
behaves like other brands using the same chip. There have been brands
with this chip, which have been working fine (supposedly), but this
special brand didn't work at all here - even though it uses an already
known chip.

>> Linksys WUSB600Nv2 e.g. works fine with the legacy driver, but only
>> limited (if at all) with rt2800usb yet.
> 
> <http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=drivers/net/wireless/rt2x00/Kconfig;h=299c3879582da14e12ca00d7f11184da8c61bed7;hb=HEAD#l83>
> 
> config RT2800USB_RT35XX
> 	bool "rt2800usb - Include support for rt35xx devices ( *EXPERIMENTAL* )"
> 	depends on *EXPERIMENTAL*

Chance :-)

rt2860 (PCI) chipset (rt2800pci) isn't experimental but is nevertheless
broken since 3.2 [1].

I'm seeing a fundamental problem (but not just here :-)) regarding QA. I
can't see any QA if there is done any change. Ok, I don't know all and
maybe, I'm blind, too. But I'm willing to learn .

That's why I'm wondering: When are all these appropriate devices going
to be tested? I think, a good point would be during development and not
after they have been released (means: "experimental" was removed). If
the ID's are committed, it should be ensured, that they really behave as
expected.


Kind regards,
Andreas

[1]
http://thread.gmane.org/gmane.linux.kernel.wireless.general/83297/focus=83304
