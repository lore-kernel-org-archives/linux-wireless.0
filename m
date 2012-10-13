Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:36173 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751507Ab2JMFiq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Oct 2012 01:38:46 -0400
From: Kalle Valo <kvalo@adurom.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
	Pontus Fuchs <pontus.fuchs@gmail.com>,
	linux-wireless@vger.kernel.org, hch@lst.de, s.L-H@gmx.de,
	mcgrof@qca.qualcomm.com
Subject: Re: [PATCH 0/4] Driver for the ar5523 chipset
References: <1349985702-21322-1-git-send-email-pontus.fuchs@gmail.com>
	<20121011203112.GB3317@kroah.com> <87haq017wi.fsf@purkki.adurom.net>
	<20121012143355.GA25235@tuxdriver.com>
Date: Sat, 13 Oct 2012 08:38:42 +0300
In-Reply-To: <20121012143355.GA25235@tuxdriver.com> (John W. Linville's
	message of "Fri, 12 Oct 2012 10:33:56 -0400")
Message-ID: <87a9vr0w4d.fsf@purkki.adurom.net> (sfid-20121013_073859_524465_A5E0B17B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"John W. Linville" <linville@tuxdriver.com> writes:

>> I did a really quick 5 min review of this driver and IMHO this should go
>> directly to drivers/net/wireless/ (or maybe to drivers/net/wireless/ath,
>> Luis?), I don't see any reason why this should go to staging. The code
>> looks clean and is only 2 kLOC. But I'll review this better during the
>> weekend and also run some build tests.
>
> I have no particular objection to that.  FWIW, Pontus contacted me
> and said something like "I've got this driver that sucks and needs
> a lot of work, should it go to staging?"  Perhaps he was being too
> hard on himself? :-)

Well, we are not exactly famous about giving positive feedback ;) So no
wonder new people are extra cautious.

But after a more thorough review I still think that this driver should
go to drivers/net/wireless. For example, it has proper endian support,
it's both gcc and sparse warning free and the code is a pleasure to
read(!).

Here are my comments:

* use ALIGN() and IS_ALIGNED() macros instead of doing it manually
* checkpatch complains about DOS line endings (but that might be due to
  mail server, not sure)
* git-am complained about whitespace damage
* defines inside structures is not common, kernel style is to have the
  defines on top of the structure definition

-- 
Kalle Valo
