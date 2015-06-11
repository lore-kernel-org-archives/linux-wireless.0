Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:48271 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbbFKNZq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2015 09:25:46 -0400
Message-ID: <55798C58.9020600@candelatech.com> (sfid-20150611_152549_955456_3F76AD17)
Date: Thu, 11 Jun 2015 06:25:44 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Janusz Dziedzic <janusz.dziedzic@gmail.com>,
	Sangwoo Moon <swmoon@lanada.kaist.ac.kr>
CC: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ath10k <ath10k@lists.infradead.org>
Subject: Re: [PATCH v2] ath10k: enable VHT for IBSS
References: <1433913284-18444-1-git-send-email-janusz.dziedzic@tieto.com>	<911fece613ad9dd7975e53ac808fd495@lanada.kaist.ac.kr>	<CALhHN=qf=frYc2iLQWs5AyJncxACa3fuBeXChE7_K+rTS8w7VQ@mail.gmail.com>	<4e93e535617121ba802385eef13b9ef7@lanada.kaist.ac.kr> <CAFED-jkdYZaKiEY9RWHTh0+MthbsQri8EhmQZ1j-tjcvzjSVdg@mail.gmail.com>
In-Reply-To: <CAFED-jkdYZaKiEY9RWHTh0+MthbsQri8EhmQZ1j-tjcvzjSVdg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 06/10/2015 11:33 PM, Janusz Dziedzic wrote:
> 2015-06-11 8:32 GMT+02:00 Sangwoo Moon <swmoon@lanada.kaist.ac.kr>:
>> Hello,
>>
>> I have successfully installed the latest version of ath10k driver from
>> backports.
>>
>> However, I have some difficulties on configuring wpa_supplicant for IBSS VHT
>> mode.
>> Looked at wpa_supplicant configuration file, but I couldn't found any option
>> related to explicit setting VHT (though I've found disable_vht instead)
>>
>> Sorry for annoying questions, but can you help this out?
>> At least you could let me know your configuration of wpa_supplicant.
>>
> supplicant by default setup wildest BW, no special parameter required
> for IBSS VHT
>
> network = {
>      ssid="ibss"
>      mode=1
>      key_mgmt=NONE
>      frequency=5180
> }
>
> Just use latest version of wpa_supplicant.
> next check you have 80MHz BW
> iw wlan0 info

Make sure you compile supplicant with this option enabled:

CONFIG_IBSS_RSN=y

I think only particular firmware versions are doing to do IBSS as well.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
