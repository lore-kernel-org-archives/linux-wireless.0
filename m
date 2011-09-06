Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49862 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277Ab1IFEdC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Sep 2011 00:33:02 -0400
Received: by wyh22 with SMTP id 22so4087790wyh.19
        for <linux-wireless@vger.kernel.org>; Mon, 05 Sep 2011 21:33:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201109060609.46663.chunkeey@googlemail.com>
References: <201109030906.21009.chunkeey@googlemail.com>
	<CAD2nsn16Otuzp9KbivA03Q5ySMBHLp36J+-HfU=wRcqkSD6QRg@mail.gmail.com>
	<201109060609.46663.chunkeey@googlemail.com>
Date: Tue, 6 Sep 2011 10:03:00 +0530
Message-ID: <CAD2nsn3FUM-k3bBD3mpwqVVXo3xvwjrf2HEARJddZJq+w0pf9w@mail.gmail.com> (sfid-20110906_063313_489606_8648780D)
Subject: Re: [RESEND][PATCH] minstrel_ht: fix Open BA session request floods
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>, nbd@openwrt.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 6, 2011 at 9:39 AM, Christian Lamparter
<chunkeey@googlemail.com> wrote:
> On Monday, September 05, 2011 05:20:09 PM Mohammed Shafi wrote:
>> On Sat, Sep 3, 2011 at 12:36 PM, Christian Lamparter
>> <chunkeey@googlemail.com> wrote:
>> > Minstrel HT tries very hard to establish a BA session with
>> > each peer once there's some data on the way. However the
>> > stack does not inform minstrel if an aggregation session
>> > is already in place, so it keeps trying and wastes good
>> > cycles in the tx status path.
>> >
>> > [ 8149.946393] Open BA session requested for $AP tid 0
>> > [ 8150.048765] Open BA session requested for $AP tid 0
>> > [ 8150.174509] Open BA session requested for $AP tid 0
>> > [ 8150.274376] Open BA session requested for $AP tid 0
>> > ...
>>
>>
>> Hi Christian,
>>
>> I got this messages in ath9k after few cycles of suspend and resume.
> There's nothing wrong with the message... as long as its reasonable
> and does not spam the logs as in my case [had about 100k entries].

indeed, it spam's the log.

>
>> doing the same fix in ath9k rate control tx_status callback the
>> messages did not re-appear. I will soon send a proper patch for ath9k
>> too.
> Well, ath9k's rc works different than minstrel_ht. In fact that check
> is not needed as ath9k's rc can check the tid state directly in
> ath_tx_aggr_check [which I think it already does... unless something
> is wrong with the txtid->state check?!].

 thanks, i will check  into that.

thanks,
shafi
