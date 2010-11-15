Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:36099 "EHLO nbd.name"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752723Ab0KOLc6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Nov 2010 06:32:58 -0500
Message-ID: <4CE11A65.5020307@openwrt.org>
Date: Mon, 15 Nov 2010 12:32:53 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [PATCH 11/13] ath9k: block new AMPDU sessions if SC_OP_TXAGGR
 is not set
References: <1289744413-20789-2-git-send-email-nbd@openwrt.org> <1289744413-20789-3-git-send-email-nbd@openwrt.org> <1289744413-20789-4-git-send-email-nbd@openwrt.org> <1289744413-20789-5-git-send-email-nbd@openwrt.org> <1289744413-20789-6-git-send-email-nbd@openwrt.org> <1289744413-20789-7-git-send-email-nbd@openwrt.org> <1289744413-20789-8-git-send-email-nbd@openwrt.org> <1289744413-20789-9-git-send-email-nbd@openwrt.org> <1289744413-20789-10-git-send-email-nbd@openwrt.org> <1289744413-20789-11-git-send-email-nbd@openwrt.org> <20101115112752.GA25277@vasanth-laptop>
In-Reply-To: <20101115112752.GA25277@vasanth-laptop>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-11-15 12:27 PM, Vasanthakumar Thiagarajan wrote:
> On Sun, Nov 14, 2010 at 07:50:11PM +0530, Felix Fietkau wrote:
>> This makes further tx path cleanups easier
>> 
>> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
>> ---
>>  drivers/net/wireless/ath/ath9k/main.c |    3 +++
>>  1 files changed, 3 insertions(+), 0 deletions(-)
>> 
>> diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
>> index 8464ca3..50bdb5d 100644
>> --- a/drivers/net/wireless/ath/ath9k/main.c
>> +++ b/drivers/net/wireless/ath/ath9k/main.c
>> @@ -1992,6 +1992,9 @@ static int ath9k_ampdu_action(struct ieee80211_hw *hw,
>>  	case IEEE80211_AMPDU_RX_STOP:
>>  		break;
>>  	case IEEE80211_AMPDU_TX_START:
>> +		if (!(sc->sc_flags & SC_OP_TXAGGR))
>> +			return -EOPNOTSUPP;
> 
> SC_OP_TXAGGR is set when the hw supports tx AMPDU, I think
> mac80211 does not call drv_ampdu_action() if hw does not
> support AMPDU.
You're right, I took another look at the code and while AMPDU is not
disabled based on SC_OP_TXAGGR, it is disabled based on the same
condition that gets checked before SC_OP_TXAGGR is even set.
Maybe I'll clean that up later...

- Felix
