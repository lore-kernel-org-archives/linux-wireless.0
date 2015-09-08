Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yk0-f172.google.com ([209.85.160.172]:33703 "EHLO
	mail-yk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbbIHTRv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Sep 2015 15:17:51 -0400
Received: by ykei199 with SMTP id i199so134755305yke.0
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2015 12:17:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1441728204.1906.18.camel@sipsolutions.net>
References: <1438781899-600-1-git-send-email-bertold.vandenbergh@esat.kuleuven.be>
	<1439456956.2114.8.camel@sipsolutions.net>
	<1441728204.1906.18.camel@sipsolutions.net>
Date: Tue, 8 Sep 2015 21:17:50 +0200
Message-ID: <CABm7fFM4aCJoFmHNFWyKALr1ZwTtxy2Hyte7TLX-TDa0eEswMw@mail.gmail.com> (sfid-20150908_211754_451464_8D163333)
Subject: Re: [PATCH] mac80211: Fix oops in OCB mode when receiving data when
 not joined
From: Bertold Van den Bergh <vandenbergh@bertold.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Bertold Van den Bergh <bertold.vandenbergh@esat.kuleuven.be>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

Sorry. I missed your previous email. I agree that your solution is
better and cleaner.

Do you want me to submit a new patch?

Sincerely,
Bertold Van den Bergh

On Tue, Sep 8, 2015 at 6:03 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2015-08-13 at 11:09 +0200, Johannes Berg wrote:
>> On Wed, 2015-08-05 at 15:38 +0200, Bertold Van den Bergh wrote:
>> > The current implementation in ocb.c can cause a kernel oops when
>> > the
>> > interface is up, but no ocb has been joined. When data is received
>> > with the broadcast BSSID rx_no_sta is called. This function uses
>> > uninitialized variables because the join function has not yet been
>> > used.
>> >
>> > Signed-off-by: Bertold Van den Bergh <
>> > bertold.vandenbergh@esat.kuleuven.be>
>> > ---
>> >  net/mac80211/ocb.c | 3 +++
>> >  1 file changed, 3 insertions(+)
>> >
>> > diff --git a/net/mac80211/ocb.c b/net/mac80211/ocb.c
>> > index 573b81a..5da2bd3 100644
>> > --- a/net/mac80211/ocb.c
>> > +++ b/net/mac80211/ocb.c
>> > @@ -50,6 +50,9 @@ void ieee80211_ocb_rx_no_sta(struct
>> > ieee80211_sub_if_data *sdata,
>> >     struct sta_info *sta;
>> >     int band;
>> >
>> > +   if (!ifocb->joined)
>> > +           return;
>> >
>> Wouldn't it make more sense to put this check into
>> ieee80211_accept_frame() and, in addition to not doing any station
>> processing, simply dropping the frame completely? Like such:
>>
>
> Reminder? I'm not sure what to do with this patch - I don't
> particularly like processing the frame at all.
>
> johannes
