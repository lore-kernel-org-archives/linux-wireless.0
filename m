Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:61086 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237AbaKYFxa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2014 00:53:30 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Sujith Manoharan <sujith@msujith.org>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/3] ath10k: Fix shared WEP
References: <1416796657-24657-1-git-send-email-sujith@msujith.org>
	<1416796657-24657-2-git-send-email-sujith@msujith.org>
	<87lhn0639s.fsf@kamboji.qca.qualcomm.com>
	<21620.5017.657509.251220@gargle.gargle.HOWL>
Date: Tue, 25 Nov 2014 07:53:12 +0200
In-Reply-To: <21620.5017.657509.251220@gargle.gargle.HOWL> (Sujith Manoharan's
	message of "Tue, 25 Nov 2014 10:58:57 +0530")
Message-ID: <87y4qz3jxz.fsf@kamboji.qca.qualcomm.com> (sfid-20141125_065349_385988_E34B595A)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith Manoharan <sujith@msujith.org> writes:

> Kalle Valo wrote:
>> No magic numbers, please. I didn't find anything for IV internals from
>> ieee80211.h, not sure if we should add them there or just use ath10k
>> internal defines.
>
> We are just retrieving the keyidx from the IV - not sure adding a couple
> of macros for "6" and "3" will make any difference.

It won't make a difference for you but it will for someone else reading
that part of code.

keyidx = skb->data[hdrlen + WEP_HDR_IV_LEN] >> WEP_HDR_KEY_ID_LSB;

versus:

keyidx = skb->data[hdrlen + 3] >> 6;

(I didn't check the standard so tha names can be totally wrong.)

-- 
Kalle Valo
