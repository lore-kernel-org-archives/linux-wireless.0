Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2053 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755320Ab1JMPMt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Oct 2011 11:12:49 -0400
Message-ID: <4E96FFE2.7050100@broadcom.com> (sfid-20111013_171252_983724_98113DB1)
Date: Thu, 13 Oct 2011 17:12:34 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: "Hauke Mehrtens" <hauke@hauke-m.de>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] brcm80211: rename CONFIG_BRCMUMAC to
 CONFIG_BRCMUTIL
References: <1318515949-9558-1-git-send-email-hauke@hauke-m.de> (
 sfid-20111013_162620_528734_10EF53D2)
 <1318516084.5612.18.camel@jlt3.sipsolutions.net>
In-Reply-To: <1318516084.5612.18.camel@jlt3.sipsolutions.net>
Content-Type: multipart/mixed;
 boundary=------------000407030307070802040400
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--------------000407030307070802040400
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit

On 10/13/2011 04:28 PM, Johannes Berg wrote:
> On Thu, 2011-10-13 at 16:25 +0200, Hauke Mehrtens wrote:
>> There is no config option named CONFIG_BRCMUMAC this should be
>> CONFIG_BRCMUTIL as this is missing here.
>>
>> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
>> ---
>>  drivers/net/wireless/Makefile |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/net/wireless/Makefile b/drivers/net/wireless/Makefile
>> index 0a304b0..812a050 100644
>> --- a/drivers/net/wireless/Makefile
>> +++ b/drivers/net/wireless/Makefile
>> @@ -59,5 +59,5 @@ obj-$(CONFIG_IWM)	+= iwmc3200wifi/
>>  
>>  obj-$(CONFIG_MWIFIEX)	+= mwifiex/
>>  obj-$(CONFIG_BRCMFMAC) += brcm80211/
>> -obj-$(CONFIG_BRCMUMAC) += brcm80211/
>> +obj-$(CONFIG_BRCMUTIL) += brcm80211/
>>  obj-$(CONFIG_BRCMSMAC) += brcm80211/
> 
> Shouldn't it just go away since BRCMUTIL depends on SMAC||FMAC and is
> otherwise unreachable?
> 
> johannes
> 
> 

Henry provided the script for preparing the mainline patch. Indeed there
is no BRCMUMAC item so that was clearly a mistake. Also Johannes
statement is a valid one. BRCMUTIL always comes with either BRCMSMAC or
BRCMFMAC so include brcm80211/ on BRCMSMAC or BRCMFMAC is sufficient.
The Makefile in brcm80211 assures brcmutil module is built.

Gr. AvS

--------------000407030307070802040400
Content-Type: application/pgp-keys;
 name=0xB5E1A116.asc
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename=0xB5E1A116.asc

-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG v1.4.11 (GNU/Linux)

mQINBE6PPIYBEAC64ntCiEHcX4ldkBRmvFDnGBaMB3kTLSfOIY7Sl1BNBOooBd12
IAVv0rqlPwhlFehULl0zMMg1WrRZGfbNc79yhJxkjISdOXCFnhGoM+sUYpI8rGuv
W5KiiKLlekZzTNlFRWROO4o2tr8A5/7TTX+BnNWxe3Kxdukpo2G4TPZ7reTa1F0c
hbPg3oWAbQvyKaHfxoptX65K+pi5XOctqKZkgh8uERgPZXu8JNcoIyBm5b1uMFpM
NROIRjwDsOsaeuKuJNz+PR/fh49nDOOmfzA+66Exe2TqGj2aSJ467XvP8fl1CqDT
LGkCJJtH2IbIcNE2xovfwSXA6/dIknDfxnLZb3c6S9Hmb6aiNLY1XYn5EpBafznJ
au0vd6AUMzjeUMlHx5OVmFVZRSjLPx7m0PiO/2kpq7qFXP5MLvT/E1S1mupbqsF3
sQlK3mFmJbkg2vqkmNp+Kd361lHNWA0/3RfnMiLaR5Z/buFjYhqqssFjRGEHKARB
BEjV2Vz+LX+vu6K8xFhLLcINlwk6d1UHYxqb0XJRap93Pos+urlUMmlICVNvSSZn
Etp1xwXu6UfcU3/k/pGKQJo8hNMRY5lynZDvMSgJs2C6e79o/dkqS1P44rwiRXZZ
8TvrjTQexQA5smkWq9leAQRRlMxlms1nkXuSjEFdD+MYvsXW16cU3gbzAQARAQAB
tCVBcmVuZCB2YW4gU3ByaWVsIDxhcmVuZEBicm9hZGNvbS5jb20+iQI4BBMBAgAi
BQJOjzyGAhsDBgsJCAcDAgYVCAIJCgsEFgIDAQIeAQIXgAAKCRC3BMfxteGhFjFB
D/9hokTANGm6G8XL/NbE6hD8D1VImdYiVv7EfSA2laHmuQBYhG9Md8NiCrJPPrIG
MG+Zok4T7waATJ3PgiZXC7xyQhQWzWpNa5TVRyWgpI4ufJwjy1EB11+iN0onGIY9
fN7Hcz2G5xVU0TsKR8J82syV/vVxIG+PRtTcvKqlMgttZL6Dug/axowfs33HtU7n
wfjgO/qqqrWL59dRE44aL8U21cON5+L4Fx8kYBV377aI9bJcBQRMS0fGBGF4Ng2B
GfipAJHEV/zPwgWvmrwClw8W0j4Fd/Q52HE8NJL1X8YeWqLO+ZKA0CizGD3LM8U0
V7MYoz73NRNwBaK7dCQ1QFulYOyXx7qW7UGSKNfqAfwA+69RdXL5JIvS41nstaUl
f7o8pL5Vc9Ir5rPiKf6u+4HU0fEMhMLcpg/mTaJXJNVd8Hi8XV6k5l/HScVYJhR9
X/xIQd304rnGIuEB4FW+dTj/6Asz8mHljuT44zRqfsW+xcoSx73QM4kIZzxAcCHq
Z8RYCmJUhAhmj82D32YbpjW589tG8Wyf/SzMcouLbSaULPgIHMr3Q6Y94Fg49Mvo
/Qt/oasuaVBgaumF9K/VdSw5hs1eQ0qbm/CFJQYVuH+5aJLiI/dcexd1r/C0ACGw
tltEA7EQ4s9nJjC1U0izaFnjGjnvAK0MsAlenwkERhTcjbkCDQROjzyGARAApgDs
8SoVBByE/fKsaCQPmGwUVY2uyLZZgyxEOZB2SafzhNxWi5lW+r8sfVNXmxLoYTW/
+87LpnSFWSLnzwsuUZlnrZ3nHiesiUpX9nQ/wtIOEqBkGY313TPAUb89qECZUuaZ
hkwVCHCxWrFoxKSi6plW5/ZRTXnOlY5shRmI2aOQ1rF+c/abaao9iTdSsygwBI05
tIIbCDJlpCnX6LDiU2SwCHEGTyv0uiBr/qAekSN0ykvZ22pUN4psNc3AWsMi5EpZ
XZ0bTw19p9u/jwsOhnpKc7A9+qhMxP+vnj+GdLQG2HAGu+sINuPbNlauOQhenA8k
zoY/wFOLCoeuxNyNvmLGBm7/JMSy1bImT79fvbcH2HS3sTCfjh2poUvUnDFVaLmD
EBf2KmOz1gMWo8QZ/XmhUavE7gFJHLONnhsCDRmbBm4lifvgd+Tr53NPxxxUNAQA
h+6WIxFnRK4cxn889BfxUP31V/ir4CiU2T/+aajg4tvgk1pGQx8QQIZEpkjtT0Kh
iJwxOvv9BIIMyBwiymRcOuBkaBw9oUiNIc5He/tOWTPvX97mOh0bZrbQ8yJJD5M5
9nJrN+9vOnbE9d8MrMiHd5mbpbNtEDoEPP6lZmTtILv8ooc9q5wLYtmCIIdgHWWc
BHjdQm1VQLfsUh2Aj+b8E2pWrVW/4wZxSW0yqRkAEQEAAYkCHwQYAQIACQUCTo88
hgIbDAAKCRC3BMfxteGhFjR5D/9tvr3Vp6IVnEm9PgWbGetemO+M9jfFT69Vkq01
KJcsa+XOu7bVNEznyl1Ieou8ELzKmRnQJNe1PLsv18gPYoNnpZ2w8Z1Z88W1VrC4
uX0BdiNsipyyZE0tBkVVs8FsFekYmWl0LtfE4GqGHm7Q1ezvF3FDT2dMBOT+0Iz+
koIX9PQlwQDzry/Du+crRGOcww9k89qtTO2goYXzXSmtcNcTGwXkTOlbf3A/PSyk
nR4CA3Z5EFP5NVTXpS4n32Yg7zI4VXf9iZPYKQhNUACWRCRf1CJIv8/eo6ho1OIv
jD2gopmG6nsTdCTdjQRp00paBBonAY6wOZxZCCvZf/EZIcTxGW9TWHZ0hzHrHfGH
tB0waKeY7OVwi3dKeWegBkhgZjDCl2Ef990ME+SL8DEfaEGpQEZHUeNYfvD+DJTP
WaJ5xenMvm3ZsCqajr+9X76O5/6PNGcHBHzdh6GFmIVinpe+1BKOhstKzjtx6+s9
iI0jPC5lDvR8qB0tigvAB31P5yi5J8I9nU6tC9eri4WvrKQe5EZxG9KpCxRE10ks
WCnOOIGUie+6LfEZtLfiQXOasu8ZmcNeBKiF0Ahl6RMO6poz49Hmr7cOisSMxlze
eXTwkOYfmFtE4rosnqpPAC+cYxATTNESWe2b3ZFg9Dbf1y2ROzkXKMe6naUZHc5q
NWhoWw==
=VXPt
-----END PGP PUBLIC KEY BLOCK-----

--------------000407030307070802040400--

