Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:37774 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753200Ab1KGMKy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Nov 2011 07:10:54 -0500
Date: Mon, 7 Nov 2011 12:58:35 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
To: Eliad Peller <eliad@wizery.com>
cc: Julia Lawall <julia@diku.dk>,
	"John W. Linville" <linville@tuxdriver.com>,
	kernel-janitors@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	"David S. Miller" <davem@davemloft.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] net/mac80211/debugfs.c: use kstrtoul, etc
In-Reply-To: <CAB3XZEfHV+sO=+vJdZUQVqXFtHvZyhJQ1Cm8LJ8Puyz9eqq9Kg@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1111071258160.2527@hadrien> (sfid-20111107_131059_584868_75A6A162)
References: <1320586010-21931-1-git-send-email-julia@diku.dk> <1320586010-21931-4-git-send-email-julia@diku.dk> <CAB3XZEfHV+sO=+vJdZUQVqXFtHvZyhJQ1Cm8LJ8Puyz9eqq9Kg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-1619784325-1320667116=:2527"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1619784325-1320667116=:2527
Content-Type: TEXT/PLAIN; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT



On Mon, 7 Nov 2011, Eliad Peller wrote:

> On Sun, Nov 6, 2011 at 3:26 PM, Julia Lawall <julia@diku.dk> wrote:
>> From: Julia Lawall <julia@diku.dk>
>>
>> Use kstrtoul, etc instead of the now deprecated strict_strtoul, etc.
>>
>> A semantic patch rule for the kstrtoul case is as follows:
>> (http://coccinelle.lip6.fr/)
>>
>> // <smpl>
>> @@
>> expression a,b;
>> {int,long} *c;
>> @@
>>
>> -strict_strtoul
>> +kstrtoul
>>  (a,b,c)
>> // </smpl>
>>
>> Signed-off-by: Julia Lawall <julia@diku.dk>
>>
>> ---
>>  net/mac80211/debugfs.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff -u -p a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
>> --- a/net/mac80211/debugfs.c
>> +++ b/net/mac80211/debugfs.c
>> @@ -190,7 +190,7 @@ static ssize_t uapsd_max_sp_len_write(st
>>                return -EFAULT;
>>        buf[len] = '\0';
>>
>> -       ret = strict_strtoul(buf, 0, &val);
>> +       ret = kstrtoul(buf, 0, &val);
>>
>>        if (ret)
>>                return -EINVAL;
>>
>
> maybe while cleaning it up change copy_from_user +
> strict_stroul/kstroul -> kstroul_from_user?

Thanks for the suggestion.  I will look into it.

julia
--8323329-1619784325-1320667116=:2527--
