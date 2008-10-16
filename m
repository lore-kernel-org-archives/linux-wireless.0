Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.184]:12406 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670AbYJPA5W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Oct 2008 20:57:22 -0400
Received: by fk-out-0910.google.com with SMTP id 18so2907834fkq.5
        for <linux-wireless@vger.kernel.org>; Wed, 15 Oct 2008 17:57:20 -0700 (PDT)
Message-ID: <1ba2fa240810151757r11060dfble6b58c76a7d0d8d1@mail.gmail.com> (sfid-20081016_025730_080228_647AB0AF)
Date: Thu, 16 Oct 2008 02:57:20 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: New Regulatory Domain Api.
Cc: "Luis Rodriguez" <Luis.Rodriguez@atheros.com>,
	"Marcel Holtmann" <holtmann@linux.intel.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Zhu Yi" <yi.zhu@intel.com>,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20081015174447.GF15902@tesla>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1224086374.735.4.camel@johannes.berg>
	 <43e72e890810151039s34ad8d79nd2744847dd254b4e@mail.gmail.com>
	 <1224092868.28173.21.camel@californication>
	 <20081015112517.GF6509@tesla>
	 <1224098748.28173.32.camel@californication>
	 <20081015131622.GH6509@tesla>
	 <1ba2fa240810151631t37edc367hfe59c76926c7b82e@mail.gmail.com>
	 <20081015170830.GA15902@tesla>
	 <1ba2fa240810151735t100ceda5s7fe7b495f735c507@mail.gmail.com>
	 <20081015174447.GF15902@tesla>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 15, 2008 at 7:44 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Wed, Oct 15, 2008 at 05:35:44PM -0700, Tomas Winkler wrote:
>> On Wed, Oct 15, 2008 at 7:08 PM, Luis R. Rodriguez
>> > The issue was your single band cards do not store 5 GHz band regulatory
>> > information. Is this MOW1 or MOW2?
>>
>> Don't understand the question, the 5GHz channels are disabled that's
>> all you can read from there.
>
> Oh OK so its not just MOW1 and MOW2 but you also *do* take into account
> the card's capabilities.
>
>> > It certainly helps more understand your situation. I had no idea
>> > of MOW1 and MOW2. Can this be documented as part of the
>> > regulatory_hint() code changes which will be added?
>>
>> I've just checked current docs and from 5000 on inclusively there are
>> only 3 SKU's MOW, ABG (no N) and BG. All others were depreciated.
>
> Interesting.. Are these SKUs also used on other platforms as well, say
> for Windows?

Definitely It's not defined specially  for Linux market. And you may
sense that this is also station mode specific. In AP mode probably the
story would be different.

> Anyway since you only have 3 this should be very simple to resolve...
> Just add the 5 GHz frequency ranges you always support. Obviously the BG
> card will not be able to make use of them :)

It's ugly but possible w/a but we still have 3945 and 4965 where it is
not so simple.
Tomas
