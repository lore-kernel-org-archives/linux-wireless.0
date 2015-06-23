Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f170.google.com ([209.85.223.170]:34629 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753540AbbFWLaD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Jun 2015 07:30:03 -0400
Received: by iebmu5 with SMTP id mu5so9283648ieb.1
        for <linux-wireless@vger.kernel.org>; Tue, 23 Jun 2015 04:30:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CB3B3D4774441E42AA3EA0E1BA8230A04DADF2DE@HASMSX110.ger.corp.intel.com>
References: <CALhHN=qr6k_a8W-8SGG4CNipB+Ovm3qxJnzKd0yL6JUYD4eT_Q@mail.gmail.com>
 <CB3B3D4774441E42AA3EA0E1BA8230A04DADF2DE@HASMSX110.ger.corp.intel.com>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Tue, 23 Jun 2015 16:59:43 +0530
Message-ID: <CABPxzYK1yvRuYnZP4xgywJy0wEx28MCZWw-G09kr7MNzZ6MMxA@mail.gmail.com> (sfid-20150623_133006_849269_F8D8C602)
Subject: Re: AP + P2P_GO multichan tests with intel7260 as a P2P_CLIENT -
 direct probe issue
To: "Peer, Ilan" <ilan.peer@intel.com>
Cc: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 23, 2015 at 4:41 PM, Peer, Ilan <ilan.peer@intel.com> wrote:
>
>
>> -----Original Message-----
>> From: linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-
>> owner@vger.kernel.org] On Behalf Of Janusz Dziedzic
>> Sent: Tuesday, June 23, 2015 11:51
>> To: linux-wireless@vger.kernel.org
>> Cc: Peer, Ilan
>> Subject: AP + P2P_GO multichan tests with intel7260 as a P2P_CLIENT - direct
>> probe issue
>>
>> Hello,
>>
>> This is my setup:
>> t1-ath9k:
>> - AP (2412)
>> - P2P_GO - go_intent=15 (2462)
>>
>> ref P2P - intel 7260
>> ref STA - t2-ath9k
>>
>> Scenario:
>> 1. setup AP t1-ath9k
>> 2. connect STA (t2-ath9k) to AP
>> 3. run ping STA->AP
>> 4. t1-ath9k - p2p_connect <intel7260> go_intent=15 5. intel7260 -
>> p2p_connect <t1-ath9k> 6. go_negotiation success 7. connect failed ...
>> 8. ...
>>
>> Sometimes I see such fail on intel7260:
>>
>> [533519.009978] p2p-wlan3-0: authenticate with 02:03:7f:4e:a0:cd
>> [533519.009999] p2p-wlan3-0: Allocated STA 02:03:7f:4e:a0:cd
>> [533519.013667] p2p-wlan3-0: Inserted STA 02:03:7f:4e:a0:cd
>> [533519.014128] p2p-wlan3-0: direct probe to 02:03:7f:4e:a0:cd (try 1/3)
>> [533519.217270] p2p-wlan3-0: direct probe to 02:03:7f:4e:a0:cd (try 2/3)
>> [533519.421349] p2p-wlan3-0: direct probe to 02:03:7f:4e:a0:cd (try 3/3)
>> [533519.624329] p2p-wlan3-0: authentication with 02:03:7f:4e:a0:cd timed
>> out [533519.633084] p2p-wlan3-0: Removed STA 02:03:7f:4e:a0:cd
>> [533519.633325] p2p-wlan3-0: Destroyed STA 02:03:7f:4e:a0:cd
>>
>> I suspect this is because of P2P_GO NoA?
>> Who should care about this direct probes tx when GO is not present?
>>
>> In case we didn't send direct probes - there is no problem and TC works
>> correctly
>>
>
> Interesting :)
>
> Any chance you can provide trace-cmd and sniffer capture?
>
> Normally, if we provided the FW with the BSSID information and TSF information for syncing, once the FW hears the 1st beacon with the NoA it should sync on it and not try to attempt to transmit any frames as long as the AP is absent. It might also be related to the fact that the probe requests are sent to broadcast address, but I need to further checks this. Anyway, having some data would help ;)
>
Thats exactly the point, if GO is in NoA FW will not transmit
but mac80211 timed-out for direct probe.

So the question is should mac80211 even send the direct
probe in this case when GO is in NoA?
