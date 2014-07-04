Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ve0-f169.google.com ([209.85.128.169]:53247 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760008AbaGDDM4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jul 2014 23:12:56 -0400
Received: by mail-ve0-f169.google.com with SMTP id pa12so1118104veb.14
        for <linux-wireless@vger.kernel.org>; Thu, 03 Jul 2014 20:12:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140703151034.GA10238@localhost>
References: <1403987726-17576-1-git-send-email-me@bobcopeland.com>
	<20140628205414.GA17825@localhost>
	<CAEFj987rJW6bH7bZQKT1W2RzMVB2BnOyWABRQRHwbrCSuOAUig@mail.gmail.com>
	<20140703142837.GA11380@localhost>
	<20140703151034.GA10238@localhost>
Date: Fri, 4 Jul 2014 11:12:55 +0800
Message-ID: <CAEFj9866CKbFrPFyxqj=LyiaGdWmK3Fw7Fw8wB4TCgRcJ2j8tQ@mail.gmail.com> (sfid-20140704_051303_381424_2C26E601)
Subject: Re: [PATCH 1/2] mac80211: mesh_plink: handle confirm frames with new plid
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: "devel@lists.open80211s.org" <devel@lists.open80211s.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, Bob

Thanks for your explanation.

I am also thinking whether it is easy to replicate the mentioned
problem. It seems that the re-auth is working fine.

Regards,
Chun-Yeow

On Thu, Jul 3, 2014 at 11:10 PM, Bob Copeland <me@bobcopeland.com> wrote:
> On Thu, Jul 03, 2014 at 10:28:37AM -0400, Bob Copeland wrote:
>> > What is the consequence if we don't handle this case? Is the peer
>> > going to do the re-auth again?
>> >
>> > Regards,
>> > Chun-Yeow
>>
>> It shouldn't be a big problem -- looking at 802.11-2012 figure 13-2:
>
> Actually, thinking about it more, a worse case is if B reaches
> ESTAB and then A reboots.  Now, A sends an Open, gets back
> a Confirm that A will ignore (due to no plid).  A will still
> timeout and send a Close frame to restart everything, but we
> would have to wait quite a while to re-establish the peering.
>
> --
> Bob Copeland %% www.bobcopeland.com
