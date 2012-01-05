Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:32805 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755198Ab2AERVQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jan 2012 12:21:16 -0500
Date: Thu, 05 Jan 2012 12:20:04 -0500 (EST)
Message-Id: <20120105.122004.1170447281304011158.davem@davemloft.net> (sfid-20120105_182125_399986_9B2B432F)
To: Larry.Finger@lwfinger.net
Cc: festevam@gmail.com, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, gwingerde@gmail.com,
	linville@tuxdriver.com, fabio.estevam@freescale.com
Subject: Re: [PATCH v2] drivers: net: Fix dependency for EEPROM_93CX6
From: David Miller <davem@davemloft.net>
In-Reply-To: <4F05CBA9.1070602@lwfinger.net>
References: <1325770673-17309-1-git-send-email-festevam@gmail.com>
	<4F05CBA9.1070602@lwfinger.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Larry Finger <Larry.Finger@lwfinger.net>
Date: Thu, 05 Jan 2012 10:11:21 -0600

> On 01/05/2012 07:37 AM, Fabio Estevam wrote:
>> Fix the following build warning:
>>
>> warning: (KS8851&& AX88796_93CX6&& RTL8180&& RTL8187&& ADM8211&&
>> RT2400PCI&& RT2500PCI&& RT61PCI&& RT2800PCI&& R8187SE) selects
>> EEPROM_93CX6 which has unmet direct dependencies (MISC_DEVICES)
>>
>> Signed-off-by: Fabio Estevam<fabio.estevam@freescale.com>
>> ---
>> Changes since v1:
>> - Place MISC_DEVICES dependency into the 'depends on' line
> 
> Is this the right way to fix this? Whenever I get this kind of build
> warning, I usually attribute it to a problem with my local
> configuration and fix my copy of .config, not modify the build
> system. With this change, it seems to me that a lot of devices will
> suddenly disappear from the build with little explanation. I don't
> feel confident enough to NACK the patch, but I would like an expert to
> comment.
> 
> I have noticed that the defconfigs for various architectures are split
> between turning MISC_DEVICES on or off.

Right, this is definitely the wrong fix, "select" is the right way to
fix this because no user should have to know the gory details of what
random odd config variables have to be on already in order to turn on
support for a device they are interested in.

Fix this right, by using "select MISC_DEVICES"
