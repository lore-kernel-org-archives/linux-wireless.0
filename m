Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.238]:16464 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755857AbYFPVrq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jun 2008 17:47:46 -0400
Received: by rv-out-0506.google.com with SMTP id k40so3859200rvb.1
        for <linux-wireless@vger.kernel.org>; Mon, 16 Jun 2008 14:47:45 -0700 (PDT)
Message-ID: <1ba2fa240806161447md125213v397d6c1f08b4a631@mail.gmail.com> (sfid-20080616_234750_051647_C92FD36F)
Date: Tue, 17 Jun 2008 00:47:45 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: remove shared key todo
Cc: "Dan Williams" <dcbw@redhat.com>,
	"John Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1213649176.3803.55.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1213642529.3803.47.camel@johannes.berg>
	 <1213647566.18384.6.camel@localhost.localdomain>
	 <1213647709.3803.50.camel@johannes.berg>
	 <1213648729.18384.11.camel@localhost.localdomain>
	 <1213649176.3803.55.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 16, 2008 at 11:46 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
>> > I have no idea. Usually, you don't even do open auth for IBSS, there's
>> > just no point. Unless you get into IBSS with encryption, but we don't
>> > really support that yet, and we probably never will actually support
>> > that without the userspace MLME in wpa supplicant.
>>
>> IBSS + WEP works at least for ipw2200 and other non-mac80211 cards; I
>> can check it out with mac80211 if you like.
>
> Yeah, no, +WEP should work. I haven't specifically tested it but I see
> no reason for it not to work.

Can confirm that this is working or least was working somewhere around
2.6.24-rcX. with 4965.

>> Any particular reason IBSS would require a userspace MLME?  There
>> shouldn't be any rekeying of any kind with adhoc, since there's no
>> central station to coordinate the rekying.  AFAIK with IBSS you just use
>> the given PSK at creation time, and never change it.  That shouldn't be
>> too hard to handle, right?
>
> Well, I was really thinking of RSN/WPA, and last I checked
> wpa_supplicant didn't even support that with IBSS, and I think it
> requires userspace MLME because you have to do the auth/assoc sequence
> with each peer etc.

The spec is very vague about implementation of this and I'm not sure
anyone implements this even on other OSs.
Tomas
