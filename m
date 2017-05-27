Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bn3nam01on0046.outbound.protection.outlook.com ([104.47.33.46]:6992
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753205AbdE0CJZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 May 2017 22:09:25 -0400
From: Norik Dzhandzhapanyan <norikd@ethertronics.com>
To: Adrian Chadd <adrian@freebsd.org>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] Per chain RSSI reporting
Date: Sat, 27 May 2017 02:09:22 +0000
Message-ID: <SN1PR08MB137316C4132262145C58CEA3B0FD0@SN1PR08MB1373.namprd08.prod.outlook.com> (sfid-20170527_040936_873978_476ED189)
References: <SN1PR08MB1373BF583E9CE2AA6A0F6381B0FC0@SN1PR08MB1373.namprd08.prod.outlook.com>,<CAJ-VmomiKOgV4pJWNKdOCzsUJZYEixvP4p5bQ9X1FBqAGk_o0w@mail.gmail.com>
In-Reply-To: <CAJ-VmomiKOgV4pJWNKdOCzsUJZYEixvP4p5bQ9X1FBqAGk_o0w@mail.gmail.com>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Adrian,

Inserting the smoothing function here is motivated by what we see as 'spike=
s' in rssi data under weak rssi conditions.  Figured its best to get rid of=
 the 'bogus' data as close to the source as possible. Also to minimize the =
impact on the changes.

I believe the averaging  that happens at higher levels is based on EWMA mac=
ros in net/mac80211/sta_info.c which not wifi card/chipset specific. Didn't=
 want to touch that since other cards seem to not have this spikey behavior=
. And, it doesnt seem to have an effect on the ath10k data anyway (iw repor=
ts the exact same values for both).

I wonder if it would be acceptable to pass a module load time parameter whi=
ch would indicate an average factor with 0 (as default) to indicate no aver=
aging?

Another option would be to add the chain_signal_avg field to the ieee80211_=
tx_status struct in mac80211.h to expose the average value up the stack thi=
s way? I haven't looked too deep on what this entails though and I didn't w=
ant to risk impacting anything else.

So yes.. I am OK with the per-chain RSSI changes first.

Norik


From: adrian.chadd@gmail.com <adrian.chadd@gmail.com> on behalf of Adrian C=
hadd <adrian@freebsd.org>
Sent: Friday, May 26, 2017 6:12 PM
To: Norik Dzhandzhapanyan
Cc: ath10k@lists.infradead.org; linux-wireless@vger.kernel.org
Subject: Re: [PATCH] Per chain RSSI reporting

[snip]

hiya,

I have something local that I've been meaning to push up to do this,
but with no smoothing. Ideally (!) smoothing is done optionally in
mac80211.

What do you think about just committing the per-chain RSSI stuff to
mac80211 so it shows up right now, and then we figure out how to
express the smoothing in mac80211 or further up the layers?

(We care about packet-to-packet RSSI values for "reasons" - mostly
bring-up and board validation, but also for runtime link checks.)


-adrian

The contents of this transmission are Ethertronics Inc. Confidential and ma=
y contain proprietary or legally privileged information which may not be di=
sclosed, copied or distributed without the express written consent of Ether=
tronics Inc. The information is intended to be for the use of the individua=
l or entity named on this transmission. If you are not the intended recipie=
nt, be aware that any disclosure, copying, distribution or use of the conte=
nts of this information is prohibited. If you have received this transmissi=
on in error, please notify us by telephone immediately so that we can arran=
ge for the retrieval of the original documents at no cost to you. Alternati=
vely, notify the sender by replying to this transmission and delete the mes=
sage without disclosing it. Thank you
