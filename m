Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:54098 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465AbbIPA4M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Sep 2015 20:56:12 -0400
From: Ben Greear <greearb@candelatech.com>
Subject: CT firmware beta-15 can now configure arbitrary rate-sets.
To: ath10k <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Message-ID: <55F8BE2B.7030004@candelatech.com> (sfid-20150916_025616_190476_D7C36834)
Date: Tue, 15 Sep 2015 17:56:11 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here is the changelog note.  This requires some corresponding driver patchs to
enable configuring the rateset (and fetching the tx-ratectrl memory from the host)
I tested this on my 4.0.4+ kernel.

Should be useful for anyone trying make a station transmit in pure /b mode.

And, likely could help tune various other ratesets as well.  So far, the ath10k
driver patches do not enable HT or VHT filters, but I hope to add that soon.
If all goes according to plan, the firmware will just magically work for HT and
VHT ratemasks.

Some of the ath10k driver patches probably help/work-with upstream firmware as well,
but I don't have time to deal with dis-entangling it from my CT specific changes.
If someone else wants to do so, please be my guest.

   *  Allow setting arbitrary rate-mask.  This allows the user to disable all but
      /b legacy rates, for instance.  It should also allow configuring subsets of
      all other HT and VHT rates, but that has not yet been tested.

      In addition, fix several bugs that caused the firmware to ignore tx-rate-ctrl
      settings because it did not properly fetch the cached RAM from the host OS.

      To enable these features, you need to be using the CT kernel patches (currently
      only in 4.0, but will at least be ported forward to 4.2 sometime soon.  Might
      not be ported to 3.17 or other older kernels.)


http://www.candelatech.com/ath10k.php


http://dmz2.candelatech.com/git/gitweb.cgi?p=linux-4.0.dev.y/.git;a=summary


Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

