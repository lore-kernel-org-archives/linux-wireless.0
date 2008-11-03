Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:46769 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754495AbYKCHvV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Nov 2008 02:51:21 -0500
Received: by yx-out-2324.google.com with SMTP id 8so917851yxm.1
        for <linux-wireless@vger.kernel.org>; Sun, 02 Nov 2008 23:51:20 -0800 (PST)
Message-ID: <43e72e890811022351m2c03e0b4g2a67a70cd6a7bd3c@mail.gmail.com> (sfid-20081103_085125_482357_8D67DF6E)
Date: Sun, 2 Nov 2008 23:51:20 -0800
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: wireless-testing commit eb9d4e8399181357cb6f6625ba7f849987432c6c causes stalls
Cc: "Bob Copeland" <me@bobcopeland.com>,
	"Nick Kossifidis" <mickflemm@gmail.com>, tim.gardner@canonical.com,
	mick@madwifi.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1225697686.3619.25.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <4908B754.1050400@tpi.com>
	 <43e72e890811011419k460b11e0he08d66022cbd606e@mail.gmail.com>
	 <40f31dec0811020132o640afa49u56791b4122013463@mail.gmail.com>
	 <40f31dec0811020110t6ec94c57gd91adc44f759bf45@mail.gmail.com>
	 <20081102184146.GA6065@hash.localnet>
	 <43e72e890811021249x6047b38do5d7ead10fe4098e7@mail.gmail.com>
	 <1225696692.3619.18.camel@johannes.berg>
	 <43e72e890811022329g510a280wfd033538ee9b8c17@mail.gmail.com>
	 <1225697686.3619.25.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 2, 2008 at 11:34 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sun, 2008-11-02 at 23:29 -0800, Luis R. Rodriguez wrote:
>
>> >> Not sure I agree with the WARN_ON() if the driver's mac80211 config()
>> >> callback fails. In our case when we tune to a different channel we
>> >> have to clear any DMA operations first and then we reset the chip.
>> >> Reseting the chip can fail for whatever strange hw issue cases. The
>> >> patch fixes the complaint but is the complaint sane?
>> >
>> > What's mac80211 to do when it fails?
>>
>> How about a shiny new nl80211 event?
>
> And wtf would userspace do?

If multiple configuration attempts fail perhaps stop trying, and
inform the user?

  Luis
