Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f51.google.com ([209.85.219.51]:49328 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbaBTXWV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Feb 2014 18:22:21 -0500
Message-ID: <53068E22.5050003@lwfinger.net> (sfid-20140221_002240_477323_FA91A774)
Date: Thu, 20 Feb 2014 17:22:10 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>, linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: pull request: wireless-next 2014-02-20
References: <20140220203005.GF3657@tuxdriver.com> <20140220.172922.864207706999214682.davem@davemloft.net>
In-Reply-To: <20140220.172922.864207706999214682.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-7; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/20/2014 04:29 PM, David Miller wrote:
> From: "John W. Linville" <linville@tuxdriver.com>
> Date: Thu, 20 Feb 2014 15:30:05 -0500
>
>> Please pull this batch of wireless updates intended for the 3.15
>> stream!
>>
>> For the mac80211 bits, Johannes says:
>>
>> "We have some cleanups and minor fixes as well as userspace API
>> improvements from a lot of people, extended VHT support for radiotap
>> from Emmanuel, CSA improvements from Andrei, Luca and Michal. I've also
>> included my work on hwsim to make dynamic registration of radios
>> possible."
>>
>> Along with that, we get the usual round of updates to ath9k,
>> brcmfmac, mwifiex, wcn36xx, and the ti drivers -- nothing particularly
>> noteworthy, mostly just random updates and refactoring.
>>
>> Also included is a pull of the wireless tree, intended to resolve
>> some potential merge issues.
>>
>> Please let me know if there are problems!
>
> Pulled, but please address this:
>
> drivers/staging/rtl8821ae/rtl8821ae/trx.c: In function ¡rtl8821ae_rx_query_desc¢:
> drivers/staging/rtl8821ae/rtl8821ae/trx.c:619:3: warning: passing argument 1 of ¡ieee80211_is_robust_mgmt_frame¢ from incompatible pointer type [enabled by default]
>
> I was going to do the easy transformation to the "_" prefixed variant
> but noticed that this code doesn't validate the skb length, which is
> precisely the reason why this routine now takes an skb.

David,

That staging driver is expected to be deleted in a commit to be submitted in 
about one week. The new one will be in the regular wireless tree. The staging 
version was submitted so that there would be a driver in 3.14.

I was surprised to see this patch in John's list. It should have gone through 
GregKH. In fact, has has been suppressing all cleanups because the better one 
will be available soon.

I suggest that you drop this one now. I will, however, check the new source to 
make sure that the skb length is checked.

Thanks,

Larry


