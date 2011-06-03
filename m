Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54229 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756294Ab1FCVfK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jun 2011 17:35:10 -0400
Received: by bwz15 with SMTP id 15so2081894bwz.19
        for <linux-wireless@vger.kernel.org>; Fri, 03 Jun 2011 14:35:09 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: mmendez@srtrl.com
Subject: Re: carl9170 noise floor calculation
Date: Fri, 3 Jun 2011 23:35:06 +0200
Cc: linux-wireless@vger.kernel.org
References: <1307047613.15440.8.camel@localhost.localdomain>
In-Reply-To: <1307047613.15440.8.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201106032335.07352.chunkeey@googlemail.com> (sfid-20110603_233515_154493_94543DF7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 02 June 2011 22:46:53 Manuel Mendez wrote:
> We are developing a product that uses a board similar to the DLink
> DWA-160.
Uh, there are at least two DWA-160 AR9170 revision and mysteriously
users have reported strange problems with both?!

So, my question: why not base your product on ath9k_htc instead?
> We are sticking an amplifier before the usb radios. I am pumping
> beacons at say -80dBm from a siggen and a program reading the
> radiotap header prints them out.
> 
> I am seeing ~20dBm gain which looks right, when taking into account my
> PA and the one that looks to be on the actual USB cards.
> 
> Is there a way to use the pre-gain values for noise floor calculations,
> and reporting of signal strength?
probably not, in fact the whole noise floor and signal strength calculations
are not as straight forward as you might think?!

http://www.mail-archive.com/ath9k-devel@lists.ath9k.org/msg05777.html
http://www.spinics.net/lists/linux-wireless/msg50060.html
[there's more, just ask google about ath9k and noise]

Also, since you are adding an extra amplifier: Are you thinking about
long-range links? Because you'll need to tinker with the round trip time
MAC registers then.

Regards,
	Chr
