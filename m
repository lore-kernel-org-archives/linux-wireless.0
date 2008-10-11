Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.189]:4508 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072AbYJKAtq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2008 20:49:46 -0400
Received: by fk-out-0910.google.com with SMTP id 18so634127fkq.5
        for <linux-wireless@vger.kernel.org>; Fri, 10 Oct 2008 17:49:42 -0700 (PDT)
Message-ID: <1ba2fa240810101749k5d053451kdaef3194a954b442@mail.gmail.com> (sfid-20081011_024948_685824_FAA168FC)
Date: Sat, 11 Oct 2008 02:49:42 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: move bss_conf into vif
Cc: "John Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1223685820.29811.23.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1223682711.29811.7.camel@johannes.berg>
	 <1ba2fa240810101732y610b4cc8g1b914b2c8eb726e5@mail.gmail.com>
	 <1223685820.29811.23.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Oct 11, 2008 at 2:43 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sat, 2008-10-11 at 02:32 +0200, Tomas Winkler wrote:
>> On Sat, Oct 11, 2008 at 1:51 AM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> > Move bss_conf into the vif struct so that drivers can
>> > access it during ->tx without having to store it in
>> > the private data or similar. No driver updates because
>> > this is only for when they want to start using it.
>>
>> What protection should driver take to be sure it won't be changed underneath ?
>> With prive copy you know this is changed only in bss_info changed is called.
>
> Yeah, that's true, I guess you can only access those fields there that
> you can access atomically. That's actually most of the fields though.
>
> Also, we don't actually take care about locking this structure at all
> even in mac80211, something we might need to think about.

When working on SM PS I have the  same dilemma I have with
ieee80211_conf do you think I need to take a private copy of it?
Thanks
Tomas

 >
> johannes
>
