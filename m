Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix.szarvasnet.hu ([87.101.127.3]:49968 "EHLO
	phoenix.szarvas.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674AbZAIUl2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2009 15:41:28 -0500
Message-ID: <4967B62C.1050203@openwrt.org> (sfid-20090109_214133_256008_5B61E350)
Date: Fri, 09 Jan 2009 21:40:12 +0100
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: Pavel Roskin <proski@gnu.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jouni Malinen <jmalinen@atheros.com>,
	Christoph Hellwig <hch@infradead.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [ath9k-devel] [PATCH v2 08/11] ath9k: remove (u16) casts from
 rtc register access
References: <1231503868-29226-1-git-send-email-juhosg@openwrt.org>	 <1231503868-29226-9-git-send-email-juhosg@openwrt.org> <1231519108.24032.1.camel@dv>
In-Reply-To: <1231519108.24032.1.camel@dv>
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pavel Roskin =EDrta:
> On Fri, 2009-01-09 at 13:24 +0100, Gabor Juhos wrote:
>> The RTC register offsets don't fit into 'u16' on the AR913x, so we h=
ave
>> to remove the existing casts.
>>
>> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
>> Signed-off-by: Imre Kaloz <kaloz@openwrt.org>
>> ---
>>  drivers/net/wireless/ath9k/hw.c |   14 +++++++-------
>>  1 files changed, 7 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/=
ath9k/hw.c
>> index 088d968..742ecc1 100644
>> --- a/drivers/net/wireless/ath9k/hw.c
>> +++ b/drivers/net/wireless/ath9k/hw.c
>> @@ -1008,7 +1008,7 @@ static void ath9k_hw_init_pll(struct ath_hal *=
ah,
>>  				pll |=3D SM(0xb, AR_RTC_PLL_DIV);
>>  		}
>>  	}
>> -	REG_WRITE(ah, (u16) (AR_RTC_PLL_CONTROL), pll);
>> +	REG_WRITE(ah, (AR_RTC_PLL_CONTROL), pll);
>=20
> Perhaps you could remove the parentheses as well?  It looks weird
> otherwise.
>=20

Yes. I will do it.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
