Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:37081 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755125Ab0IMTXe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Sep 2010 15:23:34 -0400
Message-ID: <4C8E7A31.70600@candelatech.com>
Date: Mon, 13 Sep 2010 12:23:29 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>
Subject: Re: RFC:  v3: Support multiple STA on same AP with ath9k
References: <4C8A8FF8.4030900@candelatech.com> <20100913121428.GA15567@vasanth-laptop>
In-Reply-To: <20100913121428.GA15567@vasanth-laptop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/13/2010 05:14 AM, Vasanthakumar Thiagarajan wrote:

>> -	/* configure bssid mask */
>> -	if (ah->caps.hw_caps&  ATH9K_HW_CAP_BSSIDMASK)
>> -		ath_hw_setbssidmask(common);
>> +	/* configure bssid mask, if ah->hw is configured.
>> +	 * it is NOT configured when mac80211 is calling
>> +	 * ieee80211_do_open, but probably just as well since
>> +	 * this STA isn't in the list yet.
>> +	 */
>> +	if (ah->hw) {
>
> This seems bogus. why a check for hw at this point??. IIRS hw of
> ah is not initialized at all, in that case this would fail always.
> Did you test with these code?
>
>> +	int avifs = ieee80211_count_sta_atomic(sc->hw);
>
> If your aim here is to get the number of virtual interfaces
> associated to a hw, sc->nvifs should work.

Using nvifs seems to work fine.  I can respin that patch using
nvifs.

Any suggestions for fixing the bssid mask setting in ath_opmode_init?
My change, appears to work because it's set in ath9k_add_interface, even
if not in the ath_opmode_init method.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

