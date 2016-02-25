Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:19911 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933052AbcBYRjR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Feb 2016 12:39:17 -0500
From: "Manoharan, Rajkumar" <rmanohar@qti.qualcomm.com>
To: "janusz.dziedzic@tieto.com" <janusz.dziedzic@tieto.com>,
	"Valo, Kalle" <kvalo@qca.qualcomm.com>,
	"greearb@candelatech.com" <greearb@candelatech.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/4] ath10k: remove supported chain mask
Date: Thu, 25 Feb 2016 17:39:08 +0000
Message-ID: <1456421947524.85405@qti.qualcomm.com> (sfid-20160225_183927_657018_0C2D514F)
References: <1445948474-16738-1-git-send-email-rmanohar@qti.qualcomm.com>
	<87fv0uq6p7.fsf@kamboji.qca.qualcomm.com>,<CALhHN=orRg2mkjcJ1TGssjEocNrRWEhhDV=SKGYANQ-c+YEyzA@mail.gmail.com>,<1456233812853.59898@qti.qualcomm.com>
In-Reply-To: <1456233812853.59898@qti.qualcomm.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>>>> Removing supported chainmask fields as it can be always derived
>>>> from num_rf_chains.
>>>>
>>>> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
>>>
>> Hello,
>>
>> This one break monitor mode for qca988x and 10.x firmware:
>> After Revert "ath10k: remove supported chain mask" - works correctly.
>>
>Janusz,
>
> Thanks for reporting. Will send out patch asap.
>

Janusz,

It seems the change ("ath10k: remove supported chain mask") just exposed an
hidden problem. The same target assert can be reproduced by below sequence
even after reverting the commit.

ifconfig wlan0 down
iw wlan0 set type monitor
iw phy0 set antenna 7
ifconfig wlan0 up

The actual cause of target assert is below commit.

commit 5572a95b4b5768187652a346356e39e7542ca6e0
Author: Ben Greear <greearb@candelatech.com>
Date:   Mon Nov 24 16:22:10 2014 +0200

    ath10k: apply chainmask settings to vdev on creation

Configuring NSS vdev param on interface addition is causing the target assert in 10.1 firmware.
Just creating monitor interface is causing assert with qca_main firmware.


-Rajkumar