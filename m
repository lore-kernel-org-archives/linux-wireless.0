Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:41445 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134Ab1FLOgB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Jun 2011 10:36:01 -0400
Received: by qyk7 with SMTP id 7so510299qyk.19
        for <linux-wireless@vger.kernel.org>; Sun, 12 Jun 2011 07:36:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1307891513-6812-1-git-send-email-zajec5@gmail.com>
References: <1307891513-6812-1-git-send-email-zajec5@gmail.com>
Date: Sun, 12 Jun 2011 16:36:00 +0200
Message-ID: <BANLkTin0H=c1ekTWbPHvA_O6CqGPVr=TYg@mail.gmail.com> (sfid-20110612_163608_726976_4DA0816C)
Subject: Re: [RFC][PATCH] b43: do not try sending packets when ring can be full
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Cc: francesco.gringoli@ing.unibs.it,
	=?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/6/12 Rafał Miłecki <zajec5@gmail.com>:
> ---
> This prevents us from hitting "Packet after queue stopped", but still
> is not an optimal solution. We stop sending packets from queue to
> hardware if just a one ring is full. It may happen there are packets on
> the queue that want to be send to different ring (qos).
> ---

Does anyone have a better (real?) solution? Should we use multiple skb
queues, one for each ring?

We could do correct queuing in b43_op_tx then and b43_tx_work would
just check every ring (qos), one by one.

-- 
Rafał
