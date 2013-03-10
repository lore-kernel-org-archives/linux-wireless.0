Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:19448 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892Ab3CJFxp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Mar 2013 00:53:45 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qca.qualcomm.com>
Subject: Re: Add ath6kl cleaned up driver
References: <20130213205646.GA23798@elgon.mountain>
Date: Sun, 10 Mar 2013 07:53:40 +0200
In-Reply-To: <20130213205646.GA23798@elgon.mountain> (Dan Carpenter's message
	of "Wed, 13 Feb 2013 23:56:46 +0300")
Message-ID: <87a9qbls0r.fsf@kamboji.qca.qualcomm.com> (sfid-20130310_065348_838188_4768CB37)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Carpenter <dan.carpenter@oracle.com> writes:

> Hello Kalle Valo,
>
> The patch bdcd81707973: "Add ath6kl cleaned up driver" from Jul 18, 
> 2011, leads to the following static checker warning:
> "drivers/net/wireless/ath/ath6kl/txrx.c:1327 ath6kl_rx()
> 	 warn: what are we testing here?"
>
> [ This is from a failed experiment with Smatch that I won't release. ]

[...]

>   1327          if (status || !(skb->data + HTC_HDR_LENGTH)) {
>                                 ^^^^^^^^^^^^^^^^^^^^^^^^^^
> skb->data is a pointer.  This pointer math is always going to be false.
> Should it be testing "packet->act_len < HTC_HDR_LENGTH" or something?

Good find! I have no idea what this is supposed to test, but act_len <
HTC_HDR_LENGTH seems like a good idea. I sent a patch for this.

-- 
Kalle Valo
