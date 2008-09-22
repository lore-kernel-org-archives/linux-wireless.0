Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:47220 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721AbYIVPbj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Sep 2008 11:31:39 -0400
Received: by fg-out-1718.google.com with SMTP id 19so1400628fgg.17
        for <linux-wireless@vger.kernel.org>; Mon, 22 Sep 2008 08:31:37 -0700 (PDT)
Message-ID: <1ba2fa240809220831q46cea34cq13d73d7a98f876b5@mail.gmail.com> (sfid-20080922_173143_383202_D86D0CB6)
Date: Mon, 22 Sep 2008 18:31:37 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/1] mac80211: fix led behavior in IBSS
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org,
	"Emmanuel Grumbach" <emmanuel.grumbach@intel.com>
In-Reply-To: <1222096710.3023.85.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1222092610-25374-1-git-send-email-tomas.winkler@intel.com>
	 <1222095543.3023.83.camel@johannes.berg>
	 <1ba2fa240809220812v2d91bb18k4b78072fffd85e2c@mail.gmail.com>
	 <1222096710.3023.85.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 22, 2008 at 6:18 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2008-09-22 at 18:12 +0300, Tomas Winkler wrote:
>> On Mon, Sep 22, 2008 at 5:59 PM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> > On Mon, 2008-09-22 at 17:10 +0300, Tomas Winkler wrote:
>> >> From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
>> >>
>> >> This patch fixes the led behavior in IBSS. After we joined an IBSS cell we
>> >> need to inform the led that we got associated. Although there is no 802.11
>> >> association in IBSS mode, the semantic of "There is a link" is relevant.
>> >> This allows the led to blink in IBSS mode (at least this solves a bug for
>> >> iwlwifi).
>> >
>> > Doesn't it also have to be turned off again at some point? Or is that
>> > done? Other than that looks fine to me.
>>
>> I've asked my self the same question  the answer is not clear. We
>> switch the led off on close/ifdown by radio led trigger.
>> Note in IBSS is always connected, carrier is always on if I'm not mistaken.
>
> I think you can configure it off though, by setting the "essid" (oh how
> I hate that) to "off" or something?

Let see if we hit real world scenario, this patch fixes bug opened for
long time.

 Not sure, and we can always fix it
> when we see the problem, I don't really care much about the LEDs, I
> don't have any.

Can send you few, just pick a color :)
Tomas
