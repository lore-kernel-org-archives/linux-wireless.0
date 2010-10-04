Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:52230 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754380Ab0JDLxi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Oct 2010 07:53:38 -0400
Message-ID: <4CA9C03D.9010503@openwrt.org>
Date: Mon, 04 Oct 2010 13:53:33 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Rajkumar Manoharan <rmanoharan@atheros.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Subject: Re: [PATCH 3/4] ath9k_hw: clean up register write buffering
References: <1286125639-15137-1-git-send-email-nbd@openwrt.org> <1286125639-15137-2-git-send-email-nbd@openwrt.org> <1286125639-15137-3-git-send-email-nbd@openwrt.org> <20101004085608.GA5931@vmraj-lnx.users.atheros.com>
In-Reply-To: <20101004085608.GA5931@vmraj-lnx.users.atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-10-04 10:56 AM, Rajkumar Manoharan wrote:
> On Sun, Oct 03, 2010 at 10:37:18PM +0530, Felix Fietkau wrote:
>>  static void ath9k_regwrite_flush(void *hw_priv)
>>  {
>>         struct ath_hw *ah = (struct ath_hw *) hw_priv;
>> @@ -397,6 +388,9 @@ static void ath9k_regwrite_flush(void *hw_priv)
>>         u32 rsp_status;
>>         int r;
>> 
>> +       if (!atomic_dec_and_test(&priv->wmi->mwrite_cnt))
>> +               return;
>> +
> FMU, Assume that mwrite_cnt > 1 and a reg_read happens after a flush whose value
> depends on issued reg_write, the above check skips reg_write.
> The buffered commands only issued either mwrite_cnt reaches zero or 
> buffer reaches MAX limit.
OK, makes sense, I'll resend.

- Felix
