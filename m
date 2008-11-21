Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.174]:38009 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793AbYKUUBJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Nov 2008 15:01:09 -0500
Received: by wf-out-1314.google.com with SMTP id 27so1151595wfd.4
        for <linux-wireless@vger.kernel.org>; Fri, 21 Nov 2008 12:01:08 -0800 (PST)
Message-ID: <b6c5339f0811211201i384ee31dyb5b3998fe02136af@mail.gmail.com> (sfid-20081121_210115_279054_AC4D8198)
Date: Fri, 21 Nov 2008 15:01:08 -0500
From: "Bob Copeland" <me@bobcopeland.com>
To: "Maxim Levitsky" <maximlevitsky@gmail.com>
Subject: Re: [ath5k-devel] [PATCH] ath5k: set mac address in add_interface
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
In-Reply-To: <492710E6.7020506@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20081118044037.GA18983@hash.localnet> <492710E6.7020506@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 21, 2008 at 2:49 PM, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> Bob Copeland wrote:
>> Hi Maxim,
>>
>> Please try this patch.  I didn't have a problem changing the mac address
>> after it was set to something else.  I did kick it to re-associate with
>> the AP, though.
>>
>
> Tested it, this still doesn't work:
>
> iwconfig wlan0 down
> macchanger wlan0
> iwconfig wlan0 up

Wait, don't you want to do ifconfig here?  Or was that just a typo?

I did exactly that (ifconfig down/macchanger/ifconfig up) and it
worked here.  In particular if you have mac80211 debugging on it should
show the mac address changing.  In my case, it didn't matter whether
I'd previously associated or not.  I did have to tell NetworkManager
to re-associate though.

-- 
Bob Copeland %% www.bobcopeland.com
