Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:53044 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754861AbZLILcc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Dec 2009 06:32:32 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 09 Dec 2009 03:32:39 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19231.35710.80659.717664@gargle.gargle.HOWL>
Date: Wed, 9 Dec 2009 17:05:26 +0530
To: Jiri Slaby <jirislaby@gmail.com>
CC: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: useless ath9k commit logs
In-Reply-To: <4B1F76F2.4090004@gmail.com>
References: <4B1F76F2.4090004@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jiri Slaby wrote:
>     ath9k: Fix bug in ANI channel handling
> 
>     When processing MIB interrupts, OFDM and CCK error
>     handling routines for low RSSI values have to be invoked
>     only when the channel mode is 11G/11B. Since HT channels
>     will also fall under the bands 2Ghz/5Ghz, check appropriately.

This was a long standing bug. The original behaviour was changed
by the commit: 38b33707a1ec77f7b4c92ae41cfe93318014f5bf (in wireless-testing).

The bug was identified by code review.
And yep, this should have been mentioned in the commit log.
Sorry about that.

>     ath9k: Maintain monotonicity of PER while going across different phy
> 
>     Monotonicity of packet error rate should be kept when moving
>     from one phy to another (legacy to ht, ht single stream to dual,
>     etc). Current code skips updating per for other phys.

This is also a bug fix. Rate control gets bumpy when switching between
APs operating in different modes. This was identified by internal testing.

Hope this helps.

Sujith
