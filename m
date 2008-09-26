Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:64770 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752503AbYIZIj4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2008 04:39:56 -0400
Message-ID: <48DC9F31.4010807@cn.fujitsu.com> (sfid-20080926_104001_437100_81E82E6E)
Date: Fri, 26 Sep 2008 16:37:05 +0800
From: Wang Chen <wangchen@cn.fujitsu.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Dan Williams <dcbw@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jeff Garzik <jgarzik@pobox.com>,
	NETDEV <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 14/18] netdevice airo: Convert directly reference of	netdev->priv
 to netdev->ml_priv
References: <48C0A219.2030004@cn.fujitsu.com>	 <48C0A72B.9050407@cn.fujitsu.com>  <20080905125036.GA3027@tuxdriver.com> <1220634383.6430.14.camel@localhost.localdomain> <48C24F66.1090803@cn.fujitsu.com>
In-Reply-To: <48C24F66.1090803@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wang Chen said the following on 2008-9-6 17:37:
>>>> We have some reasons to kill netdev->priv:
>>>> 1. netdev->priv is equal to netdev_priv().
>>>> 2. netdev_priv() wraps the calculation of netdev->priv's offset, obviously
>>>>    netdev_priv() is more flexible than netdev->priv.
>>>> But we cann't kill netdev->priv, because so many drivers reference to it
>>>> directly.
>>>>
>>>> OK, becasue Dave S. Miller said, "every direct netdev->priv usage is a bug",
>>>> and I want to kill netdev->priv later, I decided to convert all the direct
>>>> reference of netdev->priv first.
>>>>
>>>> Different to readonly reference of netdev->priv, in this driver, netdev->priv
>>>> was changed. I use netdev->ml_priv to replace netdev->priv.
>>>>
>>>> Signed-off-by: Wang Chen <wangchen@cn.fujitsu.com>
>>> Thank you for your patch.  However, I do not understand why you didn't
>>> simply replace netdev->priv with netdev_priv()?  Can you explain?
>> Yeah, that would have been my first choice too...
>>
> 
> 1. Why I don't use netdev_priv() to replace netdev->priv here?
> Because, here
>> @@ -2665,7 +2666,7 @@ static struct net_device *init_wifidev(struct airo_info *ai,
>>  	struct net_device *dev = alloc_netdev(0, "wifi%d", wifi_setup);
>>  	if (!dev)
>>  		return NULL;
>> -	dev->priv = ethdev->priv;
>> +	dev->ml_priv = ethdev->ml_priv;
>> @@ -2766,7 +2767,7 @@ static struct net_device *_init_airo_card( unsigned short irq, int port,
>>  		return NULL;
>>  	}
>>  
>> -	ai = dev->priv;
>> +	ai = dev->ml_priv = netdev_priv(dev);
> netdev->priv was changed here, but it shouldn't, the memory was allocated when alloc_netdev and
> netdev->priv should always pointed to that memory.
> 
> 2. Why I use netdev->ml_priv here to replace netdev->priv?
> In this driver, netdev->priv are shared by multi wifidevs, that means wifidevs need
> mid-layer private data, which are all same as their parent netdev.
> This usage is same as Dave's commit "syncppp: Fix crashes."
> 

John, do you have any comments about my answer?
