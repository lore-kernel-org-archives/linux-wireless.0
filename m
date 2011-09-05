Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44233 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754510Ab1IEPUL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Sep 2011 11:20:11 -0400
Received: by wwf5 with SMTP id 5so5285389wwf.1
        for <linux-wireless@vger.kernel.org>; Mon, 05 Sep 2011 08:20:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201109030906.21009.chunkeey@googlemail.com>
References: <201109030906.21009.chunkeey@googlemail.com>
Date: Mon, 5 Sep 2011 20:50:09 +0530
Message-ID: <CAD2nsn16Otuzp9KbivA03Q5ySMBHLp36J+-HfU=wRcqkSD6QRg@mail.gmail.com> (sfid-20110905_172015_186014_ED2C418C)
Subject: Re: [RESEND][PATCH] minstrel_ht: fix Open BA session request floods
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>, nbd@openwrt.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Sep 3, 2011 at 12:36 PM, Christian Lamparter
<chunkeey@googlemail.com> wrote:
> Minstrel HT tries very hard to establish a BA session with
> each peer once there's some data on the way. However the
> stack does not inform minstrel if an aggregation session
> is already in place, so it keeps trying and wastes good
> cycles in the tx status path.
>
> [ 8149.946393] Open BA session requested for $AP tid 0
> [ 8150.048765] Open BA session requested for $AP tid 0
> [ 8150.174509] Open BA session requested for $AP tid 0
> [ 8150.274376] Open BA session requested for $AP tid 0
> ...


Hi Christian,

I got this messages in ath9k after few cycles of suspend and resume.
doing the same fix in ath9k rate control tx_status callback the
messages did not re-appear. I will soon send a proper patch for ath9k
too.

thanks,
shafi
