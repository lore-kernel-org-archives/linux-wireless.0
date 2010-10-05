Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38302 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab0JERWR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Oct 2010 13:22:17 -0400
Subject: Re: memory clobber in rx path, maybe related to ath9k.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4CAB59B2.5050106@candelatech.com>
References: <4CAB59B2.5050106@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Oct 2010 19:22:16 +0200
Message-ID: <1286299336.3641.15.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-10-05 at 10:00 -0700, Ben Greear wrote:

> Oct  5 09:50:18 localhost kernel:  Object 0xf5b18030:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> Oct  5 09:50:18 localhost kernel:  Object 0xf5b18040:  80 00 00 00 ff ff ff ff ff ff c8 4c 75 20 e8 fd ....ÿÿÿÿÿÿÈLu.èý
> Oct  5 09:50:18 localhost kernel:  Object 0xf5b18050:  c8 4c 75 20 e8 fd d0 88 80 c1 e1 03 00 00 00 00 ÈLu.èýÐ..Áá.....
> Oct  5 09:50:18 localhost kernel:  Object 0xf5b18060:  90 01 21 04 00 09 63 69 73 63 6f 73 62 2d 31 01 ..!...ciscosb-1.

Evidently, a beacon was received into an already freed SKB.

johannes

