Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f222.google.com ([209.85.218.222]:42542 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755232AbZHNRLe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2009 13:11:34 -0400
Received: by bwz22 with SMTP id 22so1259649bwz.18
        for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2009 10:11:34 -0700 (PDT)
To: Christian Lamparter <chunkeey@web.de>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFT] ar9170: downgrade BUG_ON() on unexpected mdpu
References: <1250215295-11253-1-git-send-email-lrodriguez@atheros.com>
	<200908141150.54153.chunkeey@web.de>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Fri, 14 Aug 2009 20:11:32 +0300
In-Reply-To: <200908141150.54153.chunkeey@web.de> (Christian Lamparter's message of "Fri\, 14 Aug 2009 11\:50\:53 +0200")
Message-ID: <87eire1fsr.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter <chunkeey@web.de> writes:

>> -		BUG_ON(1);
>> -		break;
>> +		if (ar9170_nag_limiter(ar))
>> +			printk(KERN_ERR "%s: rx'd unexpected "
>> +			       "type of MPDU.\n",
>> +			       wiphy_name(ar->hw->wiphy));
>> +		return;
>>  	}
>
> no, this is really impossible! really!

A network driver should not have a BUG_ON(), stalling the whole system
is not acceptable. For example, with my current setup I would have no
idea why the system even crashed. WARN_ON() should be enough here.

-- 
Kalle Valo
