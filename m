Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:45418 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751387Ab2BNKPB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Feb 2012 05:15:01 -0500
Message-ID: <4F3A3422.7020304@gmx.de> (sfid-20120214_111511_505048_36A09B01)
Date: Tue, 14 Feb 2012 11:14:58 +0100
From: Marc Dietrich <marvin24@gmx.de>
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: Rhyland Klein <rklein@nvidia.com>, Marc Dietrich <marvin24@gmx.de>,
	"linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
	Stephen Warren <swarren@nvidia.com>,
	Colin Cross <ccross@android.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/3] net: rfkill-gpio: add device tree support
References: <1ec0e63a7453072689618430ebc2bdd7b62542a2.1329073559.git.marvin24@gmx.de> <1329161159.22948.3.camel@rklein-linux> <CAOesGMgJW7bRZn84VSZNVvc3G6z4S6HPzFEv3MJ8DcNYVsV2uQ@mail.gmail.com>
In-Reply-To: <CAOesGMgJW7bRZn84VSZNVvc3G6z4S6HPzFEv3MJ8DcNYVsV2uQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 13.02.2012 20:36, schrieb Olof Johansson:
> On Mon, Feb 13, 2012 at 11:25 AM, Rhyland Klein<rklein@nvidia.com>  wrote:
>> On Sun, 2012-02-12 at 11:13 -0800, Marc Dietrich wrote:
>>> This adds device tree support for rfkill-gpio. The optional platform
>>> paramters gpio_runtime_close and gpio_runtime_setup are not implemented.
>>>
>>> Cc: linux-wireless@vger.kernel.org
>>> Cc: "John W. Linville"<linville@tuxdriver.com>
>>> Cc: Johannes Berg<johannes@sipsolutions.net>
>>> Cc: Rhyland Klein<rklein@nvidia.com>
>>> Signed-off-by: Marc Dietrich<marvin24@gmx.de>
>>> +
>>>   static int rfkill_gpio_probe(struct platform_device *pdev)
>>>   {
>>>        struct rfkill_gpio_data *rfkill;
>>>        struct rfkill_gpio_platform_data *pdata = pdev->dev.platform_data;
>>> +     struct device_node *np = pdev->dev.of_node;
>>>        int ret = 0;
>>>        int len = 0;
>>>
>>> +     if (np)
>>> +             pdata = rfkill_gpio_parse_pdata(pdev);
>>> +
>> The only concern I have is the precedence of devicetree settings vs
>> platform data settings? If there is pdata passed in from board file
>> initialization, and there is a device tree (a corner case but I think a
>> valid one) then I believe the order would be that defined pdata would
>> override the devicetree settings. That way if someone wanted to make a
>> quick update, they wouldn't need to change the boot loader as well.
> Yes, that is how other drivers tend to be coded -- only of pdata is
> null will the driver try to fill in from the DT.

If the device tree from the bootloader does not contain the rfkill 
information the resources from platform_data will be used (so no need to 
update the bootloader). If the bootloader contains rfkill information, 
why shouldn't it be used?

Marc

