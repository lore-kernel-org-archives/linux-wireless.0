Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lanada.kaist.ac.kr ([143.248.57.170]:43952 "EHLO
	lanada.kaist.ac.kr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbbFKG0U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2015 02:26:20 -0400
Received: from localhost (lanada.kaist.ac.kr [127.0.0.1])
	by lanada.kaist.ac.kr (Postfix) with ESMTP id 57D6613FDF53
	for <linux-wireless@vger.kernel.org>; Thu, 11 Jun 2015 15:32:39 +0900 (KST)
Received: from lanada.kaist.ac.kr ([127.0.0.1])
	by localhost (lanada.kaist.ac.kr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6hBVo24TCb16 for <linux-wireless@vger.kernel.org>;
	Thu, 11 Jun 2015 15:32:39 +0900 (KST)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Thu, 11 Jun 2015 15:32:28 +0900
From: Sangwoo Moon <swmoon@lanada.kaist.ac.kr>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] ath10k: enable VHT for IBSS
In-Reply-To: <CALhHN=qf=frYc2iLQWs5AyJncxACa3fuBeXChE7_K+rTS8w7VQ@mail.gmail.com>
References: <1433913284-18444-1-git-send-email-janusz.dziedzic@tieto.com>
 <911fece613ad9dd7975e53ac808fd495@lanada.kaist.ac.kr>
 <CALhHN=qf=frYc2iLQWs5AyJncxACa3fuBeXChE7_K+rTS8w7VQ@mail.gmail.com>
Message-ID: <4e93e535617121ba802385eef13b9ef7@lanada.kaist.ac.kr> (sfid-20150611_082623_756783_4215EC13)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I have successfully installed the latest version of ath10k driver from
backports.

However, I have some difficulties on configuring wpa_supplicant for IBSS 
VHT mode.
Looked at wpa_supplicant configuration file, but I couldn't found any 
option
related to explicit setting VHT (though I've found disable_vht instead)

Sorry for annoying questions, but can you help this out?
At least you could let me know your configuration of wpa_supplicant.

Thanks much,
--Sangwoo Moon

2015-06-11 13:28에 Janusz Dziedzic이(가) 작성한 내용:
> On 10 June 2015 at 20:04, Sangwoo Moon <swmoon@lanada.kaist.ac.kr> 
> wrote:
>> Hello,
>> 
>> Thanks much for your help.
>> However, I have looked at my driver code and
>> did not find any implementations such as wiphy_ext_feature_set()
>> or NL80211_EXT_FEATURE_VHT_IBSS.
>> It seems not simple to apply your patch into my version of ath10k 
>> device
>> driver.
>> I am currently using backports-3.16-rc1-1 for ath10k device driver 
>> code
>> in order to match the kernel version v3.16 for Ubuntu 14.04.02.
>> 
> You can use newest backports with older kernel (new
> mac80211/cfg80211/drivers with old kernel).
> 
> Or you can build and install new kernel for Ubuntu.
> I am using https://github.com/kvalo/ath
> 
> BR
> Janusz
> 
>> Could you tell me the version of kernel and ath10k device driver of 
>> your
>> test configuration?
>> Or is there any way to apply your version of patch code into linux 
>> kernel
>> v3.16?
>> (I expect the version will be much more recent one than mine)
>> 
>> Thanks,
>> --Sangwoo Moon
>> 
>> 2015-06-10 14:14에 Janusz Dziedzic이(가) 작성한 내용:
>> 
>>> Enable VHT support for IBSS, while mac80211/cfg80211 and
>>> wpa_supplicant already support this.
>>> 
>>> In my test env, ath10k 2x2 I get:
>>> (udp) ath10k-1 >>>> ath10k-2 (server) -  speed: 419 Mbits/sec
>>> (tcp) ath10k-1 >>>> ath10k-2 (server) -  speed: 404 Mbits/sec
>>> 
>>> During tests I used wpa_supplicant (current version), which
>>> already support IBSS VHT, and choose highest available BW.
>>> 
>>> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
>>> ---
>>>  drivers/net/wireless/ath/ath10k/mac.c | 2 ++
>>>  1 file changed, 2 insertions(+)
>>> 
>>> diff --git a/drivers/net/wireless/ath/ath10k/mac.c
>>> b/drivers/net/wireless/ath/ath10k/mac.c
>>> index f4de717..14a8f25 100644
>>> --- a/drivers/net/wireless/ath/ath10k/mac.c
>>> +++ b/drivers/net/wireless/ath/ath10k/mac.c
>>> @@ -6949,6 +6949,8 @@ int ath10k_mac_register(struct ath10k *ar)
>>>                 goto err_free;
>>>         }
>>> 
>>> +       wiphy_ext_feature_set(ar->hw->wiphy,
>>> NL80211_EXT_FEATURE_VHT_IBSS);
>>> +
>>>         /*
>>>          * on LL hardware queues are managed entirely by the FW
>>>          * so we only advertise to mac we can do the queues thing
>> 
>> 
>> --
>> Sangwoo Moon, Ph.D. Candidate
>> Dept. of EE, KAIST, Korea
>> (Office) +82-42-350-5486, N1-#819
>> (E-mail) swmoon at lanada.kaist.ac.kr
>> (URL) http://lanada.kaist.ac.kr
>> Gwahangno 335, Yuseong-Gu Daejeon, S. Korea 305-701
>> 

-- 
Sangwoo Moon, Ph.D. Candidate
Dept. of EE, KAIST, Korea
(Office) +82-42-350-5486, N1-#819
(E-mail) swmoon at lanada.kaist.ac.kr
(URL) http://lanada.kaist.ac.kr
Gwahangno 335, Yuseong-Gu Daejeon, S. Korea 305-701

