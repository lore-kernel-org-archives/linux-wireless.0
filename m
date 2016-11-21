Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54130 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754548AbcKUQ7t (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Nov 2016 11:59:49 -0500
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Barry Day <briselec@gmail.com>
Cc: linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
        Larry.Finger@lwfinger.net
Subject: Re: [PATCH 0/7] rtl8xxxu: Pending patches
References: <1479505468-29383-1-git-send-email-Jes.Sorensen@redhat.com>
        <20161119014648.GA7140@testbox> <wrfjbmxcb55h.fsf@redhat.com>
        <20161119023830.GA7324@testbox> <wrfj37inauwp.fsf@redhat.com>
        <20161120024257.GA13169@testbox>
Date: Mon, 21 Nov 2016 11:59:47 -0500
In-Reply-To: <20161120024257.GA13169@testbox> (Barry Day's message of "Sun, 20
        Nov 2016 12:42:59 +1000")
Message-ID: <wrfj7f7w7oqk.fsf@redhat.com> (sfid-20161121_175957_614777_BD34A140)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Barry Day <briselec@gmail.com> writes:
> On Sat, Nov 19, 2016 at 06:53:42PM -0500, Jes Sorensen wrote:
>> Barry Day <briselec@gmail.com> writes:
>> > On Fri, Nov 18, 2016 at 09:00:10PM -0500, Jes Sorensen wrote:
>> >> Barry Day <briselec@gmail.com> writes:
>> >> > On Fri, Nov 18, 2016 at 04:44:21PM -0500, Jes.Sorensen@redhat.com wrote:
>> >> >> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>> >> >> 
>> >> >> Kalle,
>> >> >> 
>> >> >> Please find attached a number of patches for the rtl8xxxu
>> >> >> driver.
>> >> >> 
>> >> >> The issues reported with wpa_supplicant on 8723bu still needs further
>> >> >> investigation.
>> >> >> 
>> >> >
>> >> > The patch I posted that you want tested more will also fix the
>> >> > wpa_supplicant issue.  Currently I'm looking at why the tx rate is not
>> >> > what it should be. I feel fixing that first will be beneficial for
>> >> > fixing any other issues.
>> >> 
>> >> Interesting, I was thinking that might be the case. I do want to dig
>> >> into this further to understand it better. If we use your solution I
>> >> will want to make sure we cover both gen1 and gen2 parts.
>> >> 
>> >> > The recent merge has made my local branch of rtl8xxxu-devel 14
>> >> > commits ahead.
>> >> > Do I need to do a reset and submit a new patch for the DWA-131 dongle?
>> >> 
>> >> In general you need to use 'git pull --rebase' on my tree. I rebase it
>> >> to stay in sync with Kalle's tree.
>> >> 
>> >> The DWA-131 is the 8192eu? Sorry a bit behind and my mind is losing
>> >> bits. If it's the patch you posted earlier I can dig it out and play
>> >> with it - I am still catching up though, so please be patient.
>> >
>> > yes it's an 8192eu.
>> 
>> Gotcha - how do you do your testing to reproduce the problem btw? Most
>> of my testing is using the 8723au as a primary device and the next
>> device as a follow-on, so I may not see as long a run with the device
>> active as you see.
>> 
>
> Testing is simple. Connect to an AP in the usual
> manner..disconnect..reconnect.  The 8192eu will fail to reconnect and
> John Heenan reported the 8723bu also fails to reconnect. Even though
> he was directly stopping and restarting wpa_supplicant, it's the same
> thing to the driver - connect..disconnect..reconnect.

Thanks for the details - I'll have a look shortly.

> With using a usb_device pointer, each message starts with the usb bus
> address.  Plug it into a different port and that address could
> change. By using a pointer to the device associated with the wiphy
> each message will begin with the driver name. Just makes it easier for
> the average user to report what's in the log because he can just grep
> for "rtl8xxxu".

I see - that would be problematic for me as I quite often have 3-4 of
these things plugged in at the same time. Not knowing which port spits
out the message would make it a lot harder to track. In fact my primary
devel box for this (Lenovo Yoga 13) has an rtl8723au soldered on the
motherboard, so the moment I plug in any other dongle I'll have two.

The alternative would be to add a prefer to the individual messages.

Cheers,
Jes
