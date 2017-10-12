Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:34096 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751455AbdJLIED (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Oct 2017 04:04:03 -0400
Message-ID: <1507795437.1998.70.camel@sipsolutions.net> (sfid-20171012_100444_289483_DA528F0D)
Subject: Re: [lkp-robot] [mac80211]  cd1a0cdbf9: hwsim.ap_cipher_bip.fail
From: Johannes Berg <johannes@sipsolutions.net>
To: kernel test robot <xiaolong.ye@intel.com>,
        Xiang Gao <qasdfgtyuiop@gmail.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org, lkp@01.org
Date: Thu, 12 Oct 2017 10:03:57 +0200
In-Reply-To: <20171012061919.GE26196@yexl-desktop>
References: <20171012061919.GE26196@yexl-desktop>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Thanks for the report.

On Thu, 2017-10-12 at 14:19 +0800, kernel test robot wrote:
> FYI, we noticed the following commit (built with gcc-6):
> 
> commit: cd1a0cdbf9ada9bb975d8730a375bc13824ef065 ("mac80211: aead api to reduce redundancy")

I guess the commit isn't actually an upstream commit, but one the robot
made when applying the patch?

> url: https://github.com/0day-ci/linux/commits/Xiang-Gao/mac80211-aead-api-to-reduce-redundancy/20170929-140556

This URL doesn't work (any more?)

> 2017-10-05 23:08:27 	./run-tests.py ap_cipher_bip 
> DEV: wlan0: 02:00:00:00:00:00
> DEV: wlan1: 02:00:00:00:01:00
> DEV: wlan2: 02:00:00:00:02:00
> APDEV: wlan3
> APDEV: wlan4
> START ap_cipher_bip 1/1
> Test: WPA2-PSK with BIP
> Starting AP wlan3
> Connect STA wlan0 to AP
> dev1->dev2 unicast data delivery failed
> Traceback (most recent call last):
>   File "./run-tests.py", line 453, in main
>     t(dev, apdev)
>   File "/lkp/benchmarks/hwsim/tests/hwsim/test_ap_ciphers.py", line
> 279, in test_ap_cipher_bip
>     check_group_mgmt_cipher(dev[0], apdev[0], "AES-128-CMAC")
>   File "/lkp/benchmarks/hwsim/tests/hwsim/test_ap_ciphers.py", line
> 51, in check_group_mgmt_cipher
>     hwsim_utils.test_connectivity(dev, hapd)
>   File "/lkp/benchmarks/hwsim/tests/hwsim/hwsim_utils.py", line 165,
> in test_connectivity
>     raise Exception(last_err)
> Exception: dev1->dev2 unicast data delivery failed
> FAIL ap_cipher_bip 5.24306 2017-10-05 23:08:32.620542

[... similar results ...]

As on the previous version of this report (which had different test
cases failing IIRC), I can't reproduce this on my tree, even with your
kernel config. Since I can't actually look at the tree state that you
had (mac80211-next + patch, but which mac80211-next?), I can't
reproduce entirely.

johannes
