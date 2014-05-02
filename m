Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:56514 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbaEBGPt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 May 2014 02:15:49 -0400
Received: by mail-wg0-f47.google.com with SMTP id x12so2263944wgg.18
        for <linux-wireless@vger.kernel.org>; Thu, 01 May 2014 23:15:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CABPxzYJxWtKtJNDVcxA2tt6jFYDQvJ7hpFbwLQ4JHB0CmGihMw@mail.gmail.com>
References: <53620550.3050001@broadcom.com> <CABPxzYJxWtKtJNDVcxA2tt6jFYDQvJ7hpFbwLQ4JHB0CmGihMw@mail.gmail.com>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Fri, 2 May 2014 11:45:23 +0530
Message-ID: <CABPxzYKn6Dqk3Jrm2bw2OANtZ=t1QTLG6qb760WB5rwpnB4Wig@mail.gmail.com> (sfid-20140502_081553_058489_96AEF7C8)
Subject: Re: net/wireless/chan.c: prohibited_flags wrongly set
To: Arend van Spriel <arend@broadcom.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 1, 2014 at 9:36 PM, Krishna Chaitanya
<chaitanya.mgit@gmail.com> wrote:
>
>
> On May 1, 2014 2:01 PM, "Arend van Spriel" <arend@broadcom.com> wrote:
> >
> > Hi Johannes,
> >
> > I was debugging issue with hostapd failing on setting channel when I came across this piece of code in chan.c:545:cfg80211_chandef_usable():
> >
> >         if (width > 20)
> >                 prohibited_flags |= IEEE80211_CHAN_NO_OFDM;
> >
> >         /* 5 and 10 MHz are only defined for the OFDM PHY */
> >         if (width < 20)
> >                 prohibited_flags |= IEEE80211_CHAN_NO_OFDM;
> >
> > I suspect the first if statement to be wrong, but what should it be?
>
> Looks ok to me. Basically it says that only 20MHz has a possibility of both OFDM and DSSS.

Adding the list.
