Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:41920 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753879Ab2B0RRo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 12:17:44 -0500
Message-ID: <4F4BBAB4.90000@qca.qualcomm.com> (sfid-20120227_181808_544728_C8048E3B)
Date: Mon, 27 Feb 2012 19:17:40 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Chilam Ng <chilamng@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH] ath6kl: assign Tx packet drop threshold per endpoint
 based on AC priority
References: <1328782621-5251-1-git-send-email-chilamng@qca.qualcomm.com>
In-Reply-To: <1328782621-5251-1-git-send-email-chilamng@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/09/2012 12:17 PM, Chilam Ng wrote:
> Tx packets will begin to drop when there are multiple traffic priorities
> and the current traffic is not the highest priority and the remaining
> cookies drop below a certain number, which is fixed for all AC. It is
> possilbe that lower priority AC have more traffic which will consume
> more cookies and lock out higher priority AC from having any. Assign
> each endpoint (AC) with a different Tx-packet-drop threshold so lower
> priority AC is more likely to drop packets and the cookies become more
> available to higher priority AC.
> 
> Signed-off-by: Chilam Ng <chilamng@qca.qualcomm.com>

Thanks, applied. The real fix of course is to implement multiqueue
support in ath6kl and get rid of the cookie stuff completely. But this
is a good quick fix.

Kalle
