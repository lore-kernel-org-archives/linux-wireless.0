Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f175.google.com ([209.85.215.175]:59360 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755836Ab3IAPtJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Sep 2013 11:49:09 -0400
Received: by mail-ea0-f175.google.com with SMTP id m14so1839929eaj.6
        for <linux-wireless@vger.kernel.org>; Sun, 01 Sep 2013 08:49:08 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: ath10k@lists.infradead.org
Subject: Re: [PATCH v2 1/2] ath10k: check chip id from the soc register during probe
Date: Sun, 1 Sep 2013 17:48:59 +0200
Cc: Kalle Valo <kvalo@qca.qualcomm.com>, linux-wireless@vger.kernel.org
References: <20130901082007.1930.79088.stgit@localhost6.localdomain6> <20130901082214.1930.61079.stgit@localhost6.localdomain6>
In-Reply-To: <20130901082214.1930.61079.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201309011749.00846.chunkeey@googlemail.com> (sfid-20130901_174913_943012_205C8EBB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 01 September 2013 10:22:14 Kalle Valo wrote:
> ath10k doesn't support qca988x hw1.0 boards anymore. Unfortunately
> the PCI id is the same in hw1.0 and hw2.0 so ath10k tries to use
> hw1.0 boards anyway. But without hw1.0 workarounds in place
> ath10k just crashes horribly.
> 
> To avoid using hw1.0 boards at all add a chip id detection
> and fail the probe if hw1.0 is detected:
> 
> [ 5265.786408] ath10k: ERROR: qca988x hw1.0 is not supported
> [ 5265.786497] ath10k: Unsupported chip id 0x043202ff
Wait a second... Isn't "0x043202ff" the id for v2.0?
Shouldn't this have worked?

> [ 5265.786574] ath10k: could not register driver core (-95)
> [ 5265.793191] ath10k_pci: probe of 0000:02:00.0 failed with error -95
> 
> Also add a warning if there's an unknown chip id but continue
> the boot process normally anyway.
> 

[22217.940000] ath10k_pci 0000:01:00.0: BAR 0: assigned [mem 0x12000000-0x121fffff 64bit]
[22217.950000] PCI: Enabling device 0000:01:00.0 (0000 -> 0002)
[22217.960000] ath10k: ERROR: qca988x hw1.0 is not supported
[22217.960000] ath10k: Unsupported chip id 0x043200ff
[22217.970000] ath10k: could not register driver core (-122)
[22217.970000] ath10k_pci: probe of 0000:01:00.0 failed with error -122

[ Ok. Although I wonder why the error code is -122 (-EDQUOT) and
not -95 (-EOPNOTSUPP)?! Anyway, it still works. However I'm
looking forward to run some more tests, but first I'll need
to get that 2.0 hw ;-) ].

Tested-by: Christian Lamparter <chunkeey@googlemail.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Regards,
	Chr
