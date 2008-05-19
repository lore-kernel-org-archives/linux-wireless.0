Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.176]:15932 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754381AbYESQoK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2008 12:44:10 -0400
Received: by wa-out-1112.google.com with SMTP id j37so1906376waf.23
        for <linux-wireless@vger.kernel.org>; Mon, 19 May 2008 09:44:09 -0700 (PDT)
Message-ID: <1ba2fa240805190944i8c7fc9btecebf98df3b2b265@mail.gmail.com> (sfid-20080519_184418_429561_E2F1978B)
Date: Mon, 19 May 2008 19:44:09 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCHv2] mac80211: fix NULL pointer dereference in ieee80211_compatible_rates
Cc: "Helmut Schaa" <hschaa@suse.de>,
	"John Linville" <linville@tuxdriver.com>,
	"Larry Finger" <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1211200868.6252.37.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20080517203531.vus3gj5ce8ksskkc@imap.suse.de>
	 <1ba2fa240805180337h35bc3244od619e78c0d95d895@mail.gmail.com>
	 <1211200868.6252.37.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 19, 2008 at 3:41 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
>> Again, mac should rather solve the problem that we do not connect to
>> AP's that are not in the BSS list
>
> You're talking about this a lot without showing any willingness to work
> on it. Personally, I don't care so I'm not going to work on making this
> a valid assertion, obviously it is not.

You are absolutely right I can imagine how it sounds, just I wish I
had more time. So for now I'm just talking. If nobody will fix it till
I clean my table I will fix it.

>> The other issue is that we call ieee80211_rx_bss_put(dev, bss); before
>> this call in ieee80211_send_assoc.
>
> Indeed, we (i.e. not just me!) should have caught this at the time the
> original patch was merged.
:)

> Helmut, can you please make a patch that addresses both issues by
> instead moving the compatible rates check into the "if (bss)" part in
> ieee80211_send_assoc() right after ieee80211_rx_bss_get()? And you can
> make "u64 rates = ~0;" the default to address the !bss case.
>

Still not sure in what flow the bss can be removed from the list.
send_assoc() is called after mac has  received successful
authentication response. I would like to see a trace of this. Is this
easily reproducible ?

Thanks
Tomas


> johannes
>
