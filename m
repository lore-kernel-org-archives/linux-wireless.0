Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:59886 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbaCUSwA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Mar 2014 14:52:00 -0400
Message-ID: <532C8A32.70501@candelatech.com> (sfid-20140321_195204_421049_C6D48776)
Date: Fri, 21 Mar 2014 11:51:30 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
CC: Kalle Valo <kvalo@qca.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH] ath10k: Fix getting stats from firmware.
References: <1395360324-20433-1-git-send-email-greearb@candelatech.com> <CA+BoTQn1B6g19Ks41kzcoVyhYbHAcJGTNAyucmPMupbRAy1SNg@mail.gmail.com> <CAEFj98541uEFjHxjzUeim4nrjELToYrnbJTGuR5WgzwRvF9gkw@mail.gmail.com> <532C62DE.6060309@candelatech.com> <87eh1va5um.fsf@kamboji.qca.qualcomm.com> <CAEFj985WKAOp9vewgZW8LYB9KdUxh2GJG5uhAjRdCSiAd-y1sQ@mail.gmail.com> <CAEFj985bx2ZK-Y08yrJirqNhBQFt_CF_1hGPaj_qTRSvnU4DJw@mail.gmail.com>
In-Reply-To: <CAEFj985bx2ZK-Y08yrJirqNhBQFt_CF_1hGPaj_qTRSvnU4DJw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/21/2014 09:48 AM, Yeoh Chun-Yeow wrote:

>> I did a quick check again on STA mode. With or without your patch, the
>> printed peer stats are both identical but both wrong. See below:
>>
>>              ath10k PEER stats
>>              =================
>>
>>               Peer MAC address 00:00:00:00:00:00
>>                      Peer RSSI 256
>>                   Peer TX rate 0
>>
>>               Peer MAC address 00:00:00:00:04:f0
>>                      Peer RSSI 17317
>>                   Peer TX rate 73
>>
>> So I think that your patch makes no difference but do indeed providing
>> "correct" peer stats on latest AP firmware.

It looks like the peer stats are broken on my 10.x firmware as well.  Other pdev tx/rx
stats look like they are at least possibly correct.

Since ath10k supports more than one vdev, we also will want to extend it to
get peer for the rest of the vdevs some day.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

