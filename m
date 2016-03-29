Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:44032 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757338AbcC2PyB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Mar 2016 11:54:01 -0400
Subject: Re: [RFC] ath10k: implement dql for htt tx
To: Michal Kazior <michal.kazior@tieto.com>,
	Dave Taht <dave.taht@gmail.com>
References: <1458898743-21118-1-git-send-email-michal.kazior@tieto.com>
 <CA+BoTQk7q7VerNC1KZK49REHn9rfo6sG5zW54P=-K3XkOL77pQ@mail.gmail.com>
 <CAA93jw7BEsEOP8O2BQFXUibkGzkzBZuyWxBxs5XDCZmOt6D+Qg@mail.gmail.com>
 <CA+BoTQnDtWNGQGkBNeBGSrjkjQc4dFuivQTL=0_1D+ooE-9+RQ@mail.gmail.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	make-wifi-fast@lists.bufferbloat.net,
	"codel@lists.bufferbloat.net" <codel@lists.bufferbloat.net>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <56FAA518.2000805@candelatech.com> (sfid-20160329_175406_613599_06E1F001)
Date: Tue, 29 Mar 2016 08:54:00 -0700
MIME-Version: 1.0
In-Reply-To: <CA+BoTQnDtWNGQGkBNeBGSrjkjQc4dFuivQTL=0_1D+ooE-9+RQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/29/2016 12:49 AM, Michal Kazior wrote:

>> if you are getting a pure codel result of 160ms, that means the
>> implementation is broken. But I think (after having read your
>> description twice), the baseline result today of 160ms of queuing was
>> with a fq_codel *qdisc* doing the work on top of huge buffers,
>
> Yes. The 160ms is with fq_codel qdisc with ath10k doing DQL at 6mbps.
> Without DQL ath10k would clog up all tx slots (1424 of them) with
> frames. At 6mbps you typically want/need a handful (5-10) of frames to
> be queued.

Have you actually verified you can use all tx slots?  The way the
firmware uses it's tx buffers I think you may not be able to actually
do that...and in practice, you will get a lot fewer usable tx-buffers
than configured....

THanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

