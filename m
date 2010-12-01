Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39816 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755427Ab0LAOlx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 09:41:53 -0500
Received: by bwz15 with SMTP id 15so6180806bwz.19
        for <linux-wireless@vger.kernel.org>; Wed, 01 Dec 2010 06:41:51 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Mohammed Shafi <shafi.wireless@gmail.com>
Subject: Re: [PATCH] mac80211: Update last_tx_rate only for data frames
Date: Wed, 1 Dec 2010 15:40:44 +0100
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
References: <1291202302-9698-1-git-send-email-helmut.schaa@googlemail.com> <AANLkTi=_61HVmSBR-9v3ukVw-mpouoaFwYE8cpfa96wH@mail.gmail.com>
In-Reply-To: <AANLkTi=_61HVmSBR-9v3ukVw-mpouoaFwYE8cpfa96wH@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201012011540.45031.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Am Mittwoch 01 Dezember 2010 schrieb Mohammed Shafi:
> On Wed, Dec 1, 2010 at 4:48 PM, Helmut Schaa
> <helmut.schaa@googlemail.com> wrote:
> > The last_tx_rate field was also updated for non-data frames that are
> > often sent with a lower rate (for example management frames at 1 Mbps).
> > This is confusing when the data rate is actually much higher.
> >
> > Hence, only update the last_tx_rate field with tx rate information
> > gathered from the last data frames.
>
> Hi Helmut,
>             I have a doubt,ideally should not this be taken care by the driver ?

Sorry, I don't get your point. How should that be handled by the driver? Could
you please elaborate?

last_tx_rate is part of the sta_info struct and is documented as:

207  * @last_tx_rate: rate used for last transmit, to report to userspace as
208  *      "the" transmit rate

So, the fields sole purpose is to report the "current" tx rate to user space.
A normal user (IMO) would like to see the current tx rate that is used for
data frames and not occasionally a 1Mbps because a management frame was the
last sent frame.

Helmut
