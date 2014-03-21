Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f170.google.com ([209.85.220.170]:55544 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512AbaCUQmy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Mar 2014 12:42:54 -0400
Received: by mail-vc0-f170.google.com with SMTP id hu19so2922341vcb.29
        for <linux-wireless@vger.kernel.org>; Fri, 21 Mar 2014 09:42:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87eh1va5um.fsf@kamboji.qca.qualcomm.com>
References: <1395360324-20433-1-git-send-email-greearb@candelatech.com>
	<CA+BoTQn1B6g19Ks41kzcoVyhYbHAcJGTNAyucmPMupbRAy1SNg@mail.gmail.com>
	<CAEFj98541uEFjHxjzUeim4nrjELToYrnbJTGuR5WgzwRvF9gkw@mail.gmail.com>
	<532C62DE.6060309@candelatech.com>
	<87eh1va5um.fsf@kamboji.qca.qualcomm.com>
Date: Sat, 22 Mar 2014 00:42:54 +0800
Message-ID: <CAEFj985WKAOp9vewgZW8LYB9KdUxh2GJG5uhAjRdCSiAd-y1sQ@mail.gmail.com> (sfid-20140321_174258_322733_1202B235)
Subject: Re: [PATCH] ath10k: Fix getting stats from firmware.
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: Ben Greear <greearb@candelatech.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, Ben

I did a quick check again on STA mode. With or without your patch, the
printed peer stats are both identical but both wrong. See below:

             ath10k PEER stats
             =================

              Peer MAC address 00:00:00:00:00:00
                     Peer RSSI 256
                  Peer TX rate 0

              Peer MAC address 00:00:00:00:04:f0
                     Peer RSSI 17317
                  Peer TX rate 73

So I think that your patch makes no difference but do indeed providing
"correct" peer stats on latest AP firmware.

After applying the "ath10k: add the Rx rate in FW stats", I am able to
get the Tx and Rx Rate for all connected STAs to my AP.

---
Chun-Yeow

On Sat, Mar 22, 2014 at 12:12 AM, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Ben Greear <greearb@candelatech.com> writes:
>
>> On 03/20/2014 11:41 PM, Yeoh Chun-Yeow wrote:
>>>>
>>>> Did you test 636 as well? 636 doesn't seem to support more than just `stats_id`.
>>>>
>>> Nope. Tested with 636 not working.
>>
>> Does the existing code work with 636?  If so, we can add two different cmd
>> structs and use the smaller one with 636, and the one I modified with
>> 10.x firmware?
>
> For this issue that would be the best approach. See Marek P's patch
> "ath10k: update regulatory domain settings for 10.x firmware" (not yet
> applied, still in ath-next-test branch) as an example how this can be
> done.
>
> --
> Kalle Valo
