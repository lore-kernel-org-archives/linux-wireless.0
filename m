Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lanada.kaist.ac.kr ([143.248.57.170]:41113 "EHLO
	lanada.kaist.ac.kr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932309AbbFJSFp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2015 14:05:45 -0400
Received: from localhost (lanada.kaist.ac.kr [127.0.0.1])
	by lanada.kaist.ac.kr (Postfix) with ESMTP id 968AD13FDED7
	for <linux-wireless@vger.kernel.org>; Thu, 11 Jun 2015 03:04:40 +0900 (KST)
Received: from lanada.kaist.ac.kr ([127.0.0.1])
	by localhost (lanada.kaist.ac.kr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id y466Vm7WXIOJ for <linux-wireless@vger.kernel.org>;
	Thu, 11 Jun 2015 03:04:40 +0900 (KST)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Thu, 11 Jun 2015 03:04:31 +0900
From: Sangwoo Moon <swmoon@lanada.kaist.ac.kr>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] ath10k: enable VHT for IBSS
In-Reply-To: <1433913284-18444-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1433913284-18444-1-git-send-email-janusz.dziedzic@tieto.com>
Message-ID: <911fece613ad9dd7975e53ac808fd495@lanada.kaist.ac.kr> (sfid-20150610_200549_160798_04BCC320)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

Thanks much for your help.
However, I have looked at my driver code and
did not find any implementations such as wiphy_ext_feature_set()
or NL80211_EXT_FEATURE_VHT_IBSS.
It seems not simple to apply your patch into my version of ath10k device 
driver.
I am currently using backports-3.16-rc1-1 for ath10k device driver code
in order to match the kernel version v3.16 for Ubuntu 14.04.02.

Could you tell me the version of kernel and ath10k device driver of your
test configuration?
Or is there any way to apply your version of patch code into linux 
kernel v3.16?
(I expect the version will be much more recent one than mine)

Thanks,
--Sangwoo Moon

2015-06-10 14:14에 Janusz Dziedzic이(가) 작성한 내용:
> Enable VHT support for IBSS, while mac80211/cfg80211 and
> wpa_supplicant already support this.
> 
> In my test env, ath10k 2x2 I get:
> (udp) ath10k-1 >>>> ath10k-2 (server) -  speed: 419 Mbits/sec
> (tcp) ath10k-1 >>>> ath10k-2 (server) -  speed: 404 Mbits/sec
> 
> During tests I used wpa_supplicant (current version), which
> already support IBSS VHT, and choose highest available BW.
> 
> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
> ---
>  drivers/net/wireless/ath/ath10k/mac.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/wireless/ath/ath10k/mac.c
> b/drivers/net/wireless/ath/ath10k/mac.c
> index f4de717..14a8f25 100644
> --- a/drivers/net/wireless/ath/ath10k/mac.c
> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> @@ -6949,6 +6949,8 @@ int ath10k_mac_register(struct ath10k *ar)
>  		goto err_free;
>  	}
> 
> +	wiphy_ext_feature_set(ar->hw->wiphy, NL80211_EXT_FEATURE_VHT_IBSS);
> +
>  	/*
>  	 * on LL hardware queues are managed entirely by the FW
>  	 * so we only advertise to mac we can do the queues thing

-- 
Sangwoo Moon, Ph.D. Candidate
Dept. of EE, KAIST, Korea
(Office) +82-42-350-5486, N1-#819
(E-mail) swmoon at lanada.kaist.ac.kr
(URL) http://lanada.kaist.ac.kr
Gwahangno 335, Yuseong-Gu Daejeon, S. Korea 305-701

