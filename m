Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:26357 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757263Ab2CAHHd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Mar 2012 02:07:33 -0500
Message-ID: <4F4F2030.9080805@qca.qualcomm.com> (sfid-20120301_080739_541151_B02A4BD2)
Date: Thu, 1 Mar 2012 09:07:28 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH V3 1/5] ath6kl: Group wiphy initialization into ath6kl_cfg80211_init()
References: <1330440623-5649-1-git-send-email-vthiagar@qca.qualcomm.com> <4F4F1817.9070904@qca.qualcomm.com>
In-Reply-To: <4F4F1817.9070904@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/01/2012 08:32 AM, Kalle Valo wrote:
> On 02/28/2012 04:50 PM, Vasanthakumar Thiagarajan wrote:
>> There are some code which initializes various wiphy members
>> left outside ath6kl_cfg80211_init(), in ath6kl_core_init().
>> Move them into a single palce.
>>
>> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
> 
> Thanks, all five patches applied.

There's an issue and I think these patches might cause it. Earlier (with
commit 9289a8a8e2) my ath6kl device was always wlan0:

6: wlan0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast
state UP qlen 1000
    link/ether 00:03:7f:04:04:c2 brd ff:ff:ff:ff:ff:ff

But now for some reason it's always wlan3 even though the mac address is
the same:

4: wlan3: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN qlen 1000
    link/ether 00:03:7f:04:04:c2 brd ff:ff:ff:ff:ff:ff

I'm guessing this has something to do with mac address and udev, but I
didn't investigate this. But if you have the time better to check that
there are no suprises hidden anywhere.

Kalle
