Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f170.google.com ([209.85.210.170]:54016 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109Ab1HNLKk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Aug 2011 07:10:40 -0400
Received: by iye16 with SMTP id 16so5330948iye.1
        for <linux-wireless@vger.kernel.org>; Sun, 14 Aug 2011 04:10:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110601184931.499557c6@boulder.homenet>
References: <4CEAB969.20702@lwfinger.net>
	<1290451982.20888.2.camel@maggie>
	<4CEAC095.7020706@lwfinger.net>
	<BANLkTimjRA5CsSDp_+LrGq8PNgaR4JFD=w@mail.gmail.com>
	<4DC9853A.1090508@lwfinger.net>
	<BANLkTimBpGRxfidpE4hYCVscmX-Hy5q5jw@mail.gmail.com>
	<BANLkTi=TohOdjurvgqZT8=GXKbWfNe4v+w@mail.gmail.com>
	<20110601114839.433ae42d@boulder.homenet>
	<BANLkTin_RnMV3KnGS4qYPtMVxCuW=Vj7mg@mail.gmail.com>
	<20110601130842.077da1c3@boulder.homenet>
	<BANLkTi=2xYrrjEdHuYCKFKy4H2EXoUGQuQ@mail.gmail.com>
	<20110601160101.75e30b3d@boulder.homenet>
	<BANLkTim9pQc+yxdQLSL1-6VNiyM6_tvJ6g@mail.gmail.com>
	<20110601184931.499557c6@boulder.homenet>
Date: Sun, 14 Aug 2011 13:10:39 +0200
Message-ID: <CACna6rxH8_9pc+vZizLyAkNCLK7-CmK6GZP-E2FKUfwR9uD8Xg@mail.gmail.com> (sfid-20110814_131050_811114_C87C75D8)
Subject: Re: b43 error under heavy load
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Chris Vine <chris@cvine.freeserve.co.uk>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>,
	=?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>,
	b43-dev <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hey Chris,

2011/6/1 Chris Vine <chris@cvine.freeserve.co.uk>:
> Summary: Traffic sent up from the broadcom wireless device generates
> copious reports of "Stopped TX ring 1" but always carries on with its
> job and stays up, although its traffic is slower than on received
> packets.  Received traffic on the other hand reports no errors until
> the spate of "Out of order TX status report on DMA ring 1" errors
> occurs, which seems to happen at random (albeit accompanied on my
> failed transfer by a single "Stopped TX ring 1" log entry), and when it
> does happen brings the wireless link to a halt. Wireless traffic can be
> restarted simply by reassociating with the AP.

So it seems heavy load of RX can cause problems with TX. I just though
of one another reason, could you test one more thing for me?

Edit drivers/net/wireless/b43/dma.h and change define from value 64 to
in the line:
#define B43_RXRING_SLOTS		64

Can you get "Out of order TX" much more easily after such a change?

-- 
Rafał
