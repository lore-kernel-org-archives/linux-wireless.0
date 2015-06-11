Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:36976 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbbFKE2p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2015 00:28:45 -0400
Received: by wifx6 with SMTP id x6so63332307wif.0
        for <linux-wireless@vger.kernel.org>; Wed, 10 Jun 2015 21:28:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <911fece613ad9dd7975e53ac808fd495@lanada.kaist.ac.kr>
References: <1433913284-18444-1-git-send-email-janusz.dziedzic@tieto.com>
	<911fece613ad9dd7975e53ac808fd495@lanada.kaist.ac.kr>
Date: Thu, 11 Jun 2015 06:28:43 +0200
Message-ID: <CALhHN=qf=frYc2iLQWs5AyJncxACa3fuBeXChE7_K+rTS8w7VQ@mail.gmail.com> (sfid-20150611_062852_727865_3AA627BF)
Subject: Re: [PATCH v2] ath10k: enable VHT for IBSS
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: Sangwoo Moon <swmoon@lanada.kaist.ac.kr>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10 June 2015 at 20:04, Sangwoo Moon <swmoon@lanada.kaist.ac.kr> wrote:
> Hello,
>
> Thanks much for your help.
> However, I have looked at my driver code and
> did not find any implementations such as wiphy_ext_feature_set()
> or NL80211_EXT_FEATURE_VHT_IBSS.
> It seems not simple to apply your patch into my version of ath10k device
> driver.
> I am currently using backports-3.16-rc1-1 for ath10k device driver code
> in order to match the kernel version v3.16 for Ubuntu 14.04.02.
>
You can use newest backports with older kernel (new
mac80211/cfg80211/drivers with old kernel).

Or you can build and install new kernel for Ubuntu.
I am using https://github.com/kvalo/ath

BR
Janusz

> Could you tell me the version of kernel and ath10k device driver of your
> test configuration?
> Or is there any way to apply your version of patch code into linux kernel
> v3.16?
> (I expect the version will be much more recent one than mine)
>
> Thanks,
> --Sangwoo Moon
>
> 2015-06-10 14:14에 Janusz Dziedzic이(가) 작성한 내용:
>
>> Enable VHT support for IBSS, while mac80211/cfg80211 and
>> wpa_supplicant already support this.
>>
>> In my test env, ath10k 2x2 I get:
>> (udp) ath10k-1 >>>> ath10k-2 (server) -  speed: 419 Mbits/sec
>> (tcp) ath10k-1 >>>> ath10k-2 (server) -  speed: 404 Mbits/sec
>>
>> During tests I used wpa_supplicant (current version), which
>> already support IBSS VHT, and choose highest available BW.
>>
>> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
>> ---
>>  drivers/net/wireless/ath/ath10k/mac.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/net/wireless/ath/ath10k/mac.c
>> b/drivers/net/wireless/ath/ath10k/mac.c
>> index f4de717..14a8f25 100644
>> --- a/drivers/net/wireless/ath/ath10k/mac.c
>> +++ b/drivers/net/wireless/ath/ath10k/mac.c
>> @@ -6949,6 +6949,8 @@ int ath10k_mac_register(struct ath10k *ar)
>>                 goto err_free;
>>         }
>>
>> +       wiphy_ext_feature_set(ar->hw->wiphy,
>> NL80211_EXT_FEATURE_VHT_IBSS);
>> +
>>         /*
>>          * on LL hardware queues are managed entirely by the FW
>>          * so we only advertise to mac we can do the queues thing
>
>
> --
> Sangwoo Moon, Ph.D. Candidate
> Dept. of EE, KAIST, Korea
> (Office) +82-42-350-5486, N1-#819
> (E-mail) swmoon at lanada.kaist.ac.kr
> (URL) http://lanada.kaist.ac.kr
> Gwahangno 335, Yuseong-Gu Daejeon, S. Korea 305-701
>
