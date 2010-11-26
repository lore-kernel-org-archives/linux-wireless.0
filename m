Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:50440 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203Ab0KZPyn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Nov 2010 10:54:43 -0500
Received: by mail-qw0-f46.google.com with SMTP id 7so2189640qwb.19
        for <linux-wireless@vger.kernel.org>; Fri, 26 Nov 2010 07:54:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTikCQPq-HVUJhDet-ZbA97nt+1uYTKgtzvK2cyd7@mail.gmail.com>
References: <AANLkTikCQPq-HVUJhDet-ZbA97nt+1uYTKgtzvK2cyd7@mail.gmail.com>
Date: Fri, 26 Nov 2010 10:54:41 -0500
Message-ID: <AANLkTikgkBZPEVOuZQHeJSXiiwBsVgMOGxRwOu315Vn4@mail.gmail.com>
Subject: Re: help with ath5k --- wlan0 no private ioctls
From: Bob Copeland <me@bobcopeland.com>
To: Octav Chipara <ochipara@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 25, 2010 at 12:43 AM, Octav Chipara <ochipara@gmail.com> wrote:
> Hi,
>
> I'm having some problems properly configuring ath5k. I'm trying to set
> the retransmission count so that the card will not perform more than a
> transmission:
>
> iwconfig wlan0 retry 1

Hmm, someone can correct me if I'm wrong, but according to my
reading of the code, minstrel only uses hw->max_rate_tries
and not wiphy->retry_{short,long}.  Also it looks like the only
drivers that poke at these values only use it for failure
indication when they don't support accurate tx status reporting.

You can try the pid controller for now, it directly uses these
settings.

> I tried to set the value directly using iwpriv and I
> get wlan0 no private ioctls.

Unlearn iwpriv -- ath5k will never support it.

-- 
Bob Copeland %% www.bobcopeland.com
