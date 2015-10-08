Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56126 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776AbbJHVDX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Oct 2015 17:03:23 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Jakub Sitnicki <jsitnicki@gmail.com>
Cc: linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
	Larry.Finger@lwfinger.net
Subject: Re: [PATCH 1/1] New driver: rtl8xxxu (mac80211)
References: <1440883083-32498-1-git-send-email-Jes.Sorensen@redhat.com>
	<1440883083-32498-2-git-send-email-Jes.Sorensen@redhat.com>
	<87d1wp49ds.fsf@frog.home> <wrfjio6h18jq.fsf@redhat.com>
Date: Thu, 08 Oct 2015 17:03:21 -0400
In-Reply-To: <wrfjio6h18jq.fsf@redhat.com> (Jes Sorensen's message of "Thu, 08
	Oct 2015 15:09:45 -0400")
Message-ID: <wrfjbnc913ae.fsf@redhat.com> (sfid-20151008_230349_336482_F11C47F4)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jes Sorensen <Jes.Sorensen@redhat.com> writes:
> Jakub Sitnicki <jsitnicki@gmail.com> writes:
>> AFAICT, in this regard, rtl8188eu driver has more in common with the
>> rtlwifi/rtl8188ee driver.
>>
>> I'm curious what is your opinion on this.  In particular, do you see any
>> reason not to make an attempt to extend rtl8xxxu to support 8188EU
>> chips?
>
> Parsing the efuse is normally fairly easy, if you have a reference to
> the layout. It can be deducted from the vendor driver code. The layout
> pretty much differ for each chip, but I have seen enough of them by now
> that I can parse most of it by looking at the hex dump.
>
> I think the 8188EU uses IOL, which is an enhanced firmware assist API.
> That will change the programming a bit, but I think it's well within
> scope for this driver to support this as well.
>
> In other words, it is my plan to look at the 8188EU. If you get it going
> before me, I am very happy to work with you on integrating the patches.

Jakub,

Digging a bit further, it looks like the 8188EU, 8192EU, and 8723BU, use
a different RF module than the previous parts. They have far more RF
registers, so the code for reading/writing RF registers does not work as
is.

Hopefully shouldn't be too hard to fix, but it also mean that the RF
init table used for the older parts will not match whats needed for the
new parts.

Jes
