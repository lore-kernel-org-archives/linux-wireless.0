Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f171.google.com ([209.85.222.171]:35191 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758074AbZKYPfW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2009 10:35:22 -0500
Received: by pzk1 with SMTP id 1so5690263pzk.33
        for <linux-wireless@vger.kernel.org>; Wed, 25 Nov 2009 07:35:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B0C6493.7010805@erley.org>
References: <4B0C5E6F.5040302@viagenie.ca> <4B0C6493.7010805@erley.org>
Date: Wed, 25 Nov 2009 07:35:27 -0800
Message-ID: <45e8e6c40911250735o334e23degdf0f1e421aa590b9@mail.gmail.com>
Subject: Re: Hardware for 802.11s
From: Andrey Yurovsky <andrey@cozybit.com>
To: Pat Erley <pat-lkml@erley.org>
Cc: Simon Perreault <simon.perreault@viagenie.ca>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 24, 2009 at 2:56 PM, Pat Erley <pat-lkml@erley.org> wrote:
> Simon Perreault wrote:
>> Hello,
>>
>> I want to run 802.11s.
>>
>> I tried a pair of Linksys WRT54GL v1.1 (Broadcom 5352) with the b43 driver,
>> kernel 2.6.30.9, OpenWRT trunk (r18526). Doesn't work. I don't see anything in
>> "iw ... station dump".
>> Side question: is this expected behaviour?
>>
>> Can anyone recommend something I can buy on which 802.11s will work? I couldn't
>> Google anyone saying e.g. "I used the ACME Router 1.0 and it worked."
>
> I don't have time tonight, but I believe you can make b43 work by triggering a
> scan after bringing the interface up.  I know I've made b43 work in the past.

The scanning workaround is needed to deal with bugs in the ath9k and
rt2x00 drivers, however there was no problem with b43 last time I
checked.  The station dump should show you output provided that you
have more than one mesh node within range, with the same mesh ID, and
on the same channel.  Can you please use a sniffer on the channel you
picked (it's channel 1 by default) and confirm that you see mesh
beacons from your devices once you "ifconfig up"?  Thanks,

  -Andrey
