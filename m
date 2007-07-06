Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:33215 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760271AbXGFPOH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2007 11:14:07 -0400
Message-ID: <468E5C33.2000102@warmcat.com>
Date: Fri, 06 Jul 2007 16:13:55 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Daniel Drake <dsd@gentoo.org>
CC: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	Ulrich Kunitz <kune@deine-taler.de>
Subject: Re: Arrested Development
References: <468DE699.9040708@warmcat.com> <468E48AF.10109@gentoo.org>
In-Reply-To: <468E48AF.10109@gentoo.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Daniel Drake wrote:
> Andy Green wrote:
>> Second is a small patch for zd1211rw-mac80211 that fixes rate reporting
>> on radiotap rx, last sent here 11 June.
>>
>> http://www.spinics.net/lists/linux-wireless/msg02897.html
> 
> Oh and if you want to jump on ahead and save me some time, answering
> these questions might help :)
> 
> Why isn't this needed for the softmac driver? (or is it broken there too?)

I don't know, I only test mac80211-zd1211rw (which I have a very good
experience of, by the way).

> Are we really sure we need another rate conversion function? there are
> already a couple in the mac80211 driver, and one or 2 extra (for RTS/CTS
> rate programming) in the softmac driver.

Dunno.  But you definitely need to actually call "a" rate conversion
function instead of passing the wrong thing on in radiotap.  If you want
to use one of these other conversion functions that you know about to
fix it instead, please feel free to supersede my patch that way and I
will be just as happy.

-Andy
