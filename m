Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.179]:9254 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247AbYK0Wjf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Nov 2008 17:39:35 -0500
Received: by wa-out-1112.google.com with SMTP id v27so535327wah.21
        for <linux-wireless@vger.kernel.org>; Thu, 27 Nov 2008 14:39:34 -0800 (PST)
Message-ID: <69e28c910811271439g3f7beaffx431ec1aa7549f7b9@mail.gmail.com> (sfid-20081127_233939_546341_FE04773B)
Date: Thu, 27 Nov 2008 23:39:34 +0100
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC] rtl8187: Do not wait for an ACK when IEEE80211_TX_CTL_NO_ACK is set
Cc: "Herton Ronaldo Krzesinski" <herton@mandriva.com.br>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Hin-Tak Leung" <hintak.leung@gmail.com>,
	"Larry Finger" <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Felix Fietkau" <nbd@openwrt.org>
In-Reply-To: <1227823149.7559.1.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <69e28c910811261431u26e341d3p51ebadca807f4b61@mail.gmail.com>
	 <200811271543.59126.herton@mandriva.com.br>
	 <69e28c910811271202s295bbf5bo3dc8c04c50b08a01@mail.gmail.com>
	 <200811271952.21408.herton@mandriva.com.br>
	 <1227823149.7559.1.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 27, 2008 at 10:59 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2008-11-27 at 19:52 -0200, Herton Ronaldo Krzesinski wrote:
>
>> In this case then shouldn't mac80211/rate control alg give a right rates[0].count?
>
> It probably should put 1 into that value, yes. It doesn't seem to
> enforce that now though, I'll take a look at doing that.
>
>> And other drivers have same bug?
>
> possibly.
>
> Another thing: the ".count" is the number of tries you should do, so if
> the hardware expects retries then you need to subtract 1.
>
> johannes
>

I actually tested that 0 is the right setting - I initially tested it
with 1, and there was evidence that it was still retrying. Setting it
to 0 truly behaved like a NO_ACK bit would on other HW. (I used
aireplay-ng to get a view of transmission speed - the "chopchop" and
"interactive replay" are good indicators. I used a patch to make all
injected frames NO_ACK, then tested the highest rate that results in
no multiple tries for the same number in chopchop. With the original
code, I could transmit 25 frames per second - anything higher resulted
in chopchop requiring more than 256 packets for each byte. Most
drivers start to behave this way over about 600 to 700 packets per
second. Setting the retry count to 1 resulted in a max of 220/s before
producing more-than-256-attempts errors, still lower than what other
drivers do with NO_ACK, suggestive of the driver still retrying.
Setting to 0 resulted in a 625/s max, on par with other drivers.)
This means, hdr->retry is the number of retries, unlike ".count",
which is the number of tries, including the initial transmit.

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
