Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:47353 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254Ab1H3Lpc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 07:45:32 -0400
Date: Tue, 30 Aug 2011 17:15:15 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: Jouni Malinen <jouni@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	Edward Lu <shaol@qca.qualcomm.com>
Subject: Re: [PATCH 11/20] ath6kl: Support channel set request for
	startscan command
Message-ID: <20110830114514.GA32127@vasanth-laptop> (sfid-20110830_134535_587807_2AA441F7)
References: <1314620641-24257-1-git-send-email-jouni@qca.qualcomm.com> <1314620641-24257-12-git-send-email-jouni@qca.qualcomm.com> <4E5CAE7A.8000809@qca.qualcomm.com> <20110830095123.GA31713@vasanth-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20110830095123.GA31713@vasanth-laptop>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 30, 2011 at 03:21:24PM +0530, Vasanthakumar Thiagarajan wrote:
> On Tue, Aug 30, 2011 at 12:33:46PM +0300, Kalle Valo wrote:
> > On 08/29/2011 03:23 PM, Jouni Malinen wrote:
> > > From: Edward Lu <elu@qca.qualcomm.com>
> > > -	if (num_chan)
> > > -		memcpy(sc->ch_list, ch_list, num_chan * sizeof(u16));
> > > +	if (num_chan) {
> > > +		for (i = 0; i < num_chan; i++)
> > > +			sc->ch_list[i] = cpu_to_le16(ch_list[i]);
> > > +	}
> > 
> > if (num_chan) is not needed, the for loop is enough.
> 
> It is not that for loop would run once when num_chan is 0,
> may be it needs to  go from 0 to num_chan -1?.

Oops, obviously i misread it.

Vasanth
