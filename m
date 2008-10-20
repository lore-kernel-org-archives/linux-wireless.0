Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f16.google.com ([209.85.217.16]:36281 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867AbYJTJFU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2008 05:05:20 -0400
Received: by gxk9 with SMTP id 9so3335176gxk.13
        for <linux-wireless@vger.kernel.org>; Mon, 20 Oct 2008 02:05:18 -0700 (PDT)
Message-ID: <43e72e890810200205s58b4bfcbk8d2e75f68dc0ca84@mail.gmail.com> (sfid-20081020_110523_866367_BF3ACA4C)
Date: Mon, 20 Oct 2008 02:05:18 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC] mac80211: Re-enable aggregation
Cc: Sujith <Sujith.Manoharan@atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Luis Rodriguez" <Luis.Rodriguez@atheros.com>,
	"tomasw@gmail.com" <tomasw@gmail.com>
In-Reply-To: <1224493469.18024.38.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <18684.16351.638713.791015@gargle.gargle.HOWL>
	 <1224491480.18024.32.camel@johannes.berg>
	 <43e72e890810200135o1581c904i456a35298f8a56a9@mail.gmail.com>
	 <1224492335.18024.34.camel@johannes.berg>
	 <18684.17816.702853.44986@gargle.gargle.HOWL>
	 <43e72e890810200155wbe01660xe3f53de80dc7357d@mail.gmail.com>
	 <1224493038.18024.36.camel@johannes.berg>
	 <43e72e890810200201l49eea95h2f67615b536311aa@mail.gmail.com>
	 <1224493469.18024.38.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 20, 2008 at 2:04 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2008-10-20 at 02:01 -0700, Luis R. Rodriguez wrote:
>
>> > Well the fact that it's in tx_h_sequence is a bit weird, but we should
>> > be able to get around not using an extra bit in skb I think. Especially
>> > for this since it's only really between the driver and mac80211, and
>> > after a requeue the ampdu status might actually change.
>>
>> Good point. I failed to see that. So in that case it should be as
>> sujith had it before my suggestion and just handle it as he had it in
>> the tx handlers. The problem though is that the RC algorithm should be
>> the one to determine if an skb is part of an ampdu for aggregation or
>> not IMHO. Actually this is the real question and hot topic.
>>
>> When should we aggregate and should mac80211 decide that or be left to the RC.
>
> No, the RC algorithm cannot decided that, the RC algorithm can merely
> decide when to set up/tear down aggregation sessions. When a session is
> up all packet belonging to that TID should go into it, surely?

Good question :)

  Luis
