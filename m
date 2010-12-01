Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53200 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385Ab0LAPPP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 10:15:15 -0500
Received: by fxm20 with SMTP id 20so151544fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 01 Dec 2010 07:15:14 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Mohammed Shafi <shafi.wireless@gmail.com>
Subject: Re: [PATCH] mac80211: Update last_tx_rate only for data frames
Date: Wed, 1 Dec 2010 16:14:06 +0100
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	"John W. Linville" <linville@tuxdriver.com>
References: <1291202302-9698-1-git-send-email-helmut.schaa@googlemail.com> <AANLkTi=_61HVmSBR-9v3ukVw-mpouoaFwYE8cpfa96wH@mail.gmail.com> <201012011540.45031.helmut.schaa@googlemail.com>
In-Reply-To: <201012011540.45031.helmut.schaa@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201012011614.07163.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Mittwoch 01 Dezember 2010 schrieb Helmut Schaa:
> Am Mittwoch 01 Dezember 2010 schrieb Mohammed Shafi:
> > On Wed, Dec 1, 2010 at 4:48 PM, Helmut Schaa
> > <helmut.schaa@googlemail.com> wrote:
> > > The last_tx_rate field was also updated for non-data frames that are
> > > often sent with a lower rate (for example management frames at 1 Mbps).
> > > This is confusing when the data rate is actually much higher.
> > >
> > > Hence, only update the last_tx_rate field with tx rate information
> > > gathered from the last data frames.
> >
> > Hi Helmut,
> >             I have a doubt,ideally should not this be taken care by the driver ?
> 
> Sorry, I don't get your point. How should that be handled by the driver? Could
> you please elaborate?

Ahh, did you mean that should be taken care of by the rate control algorithm?

I agree, if the rate control algortihm returns a rate via txrc.reported_rate
we should just use that without further validation.

Nevertheless, if the rate control algortihm doesn't fill in txrc.reported_rate
we should only account data frames.

Will send an updated patch.

Helmut
