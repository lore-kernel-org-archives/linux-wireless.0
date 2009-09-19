Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:62456 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088AbZISWMx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Sep 2009 18:12:53 -0400
Received: by ewy2 with SMTP id 2so48572ewy.17
        for <linux-wireless@vger.kernel.org>; Sat, 19 Sep 2009 15:12:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090919220805.GA2728@plato.andrewprice.me.uk>
References: <20090919220805.GA2728@plato.andrewprice.me.uk>
Date: Sun, 20 Sep 2009 00:12:56 +0200
Message-ID: <2d0a357f0909191512o2ad20b1ag3eb344948351cae3@mail.gmail.com>
Subject: Re: Problem with "cfg80211: fix SME connect" (bisected)
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Andrew Price <andy@andrewprice.me.uk>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Can you try "[PATCH] cfg80211: don't overwrite privacy setting" from [1]?

-Sedat

[1] http://marc.info/?l=linux-wireless&m=125323296617306&w=2

On Sun, Sep 20, 2009 at 12:08 AM, Andrew Price <andy@andrewprice.me.uk> wrote:
> Hi,
>
> After building today's mainline kernel (as of 78f28b7c) my wireless
> networking stopped working - the interface seems to come up but nothing
> can connect.  The output of dmesg was clean, no backtraces or anything
> unusual.
>
> I've bisected the problem down to commit bbac31f4 "cfg80211: fix SME
> connect".  Reverting that commit fixes the problem. I'm using
> wpa_supplicant v0.6.9. The bug occurs for my b43 card and my rt2500pci
> card, and reverting the commit fixes the problem for both cards.
>
> Please let me know if there's any more info I can provide or patches I
> can test.
>
> Andrew
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
