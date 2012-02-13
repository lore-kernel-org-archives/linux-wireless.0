Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:44343 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755078Ab2BMTgK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Feb 2012 14:36:10 -0500
MIME-Version: 1.0
In-Reply-To: <1329161159.22948.3.camel@rklein-linux>
References: <1ec0e63a7453072689618430ebc2bdd7b62542a2.1329073559.git.marvin24@gmx.de>
	<1329161159.22948.3.camel@rklein-linux>
Date: Mon, 13 Feb 2012 11:36:09 -0800
Message-ID: <CAOesGMgJW7bRZn84VSZNVvc3G6z4S6HPzFEv3MJ8DcNYVsV2uQ@mail.gmail.com> (sfid-20120213_203614_366163_D40D9733)
Subject: Re: [PATCH 1/3] net: rfkill-gpio: add device tree support
From: Olof Johansson <olof@lixom.net>
To: Rhyland Klein <rklein@nvidia.com>
Cc: Marc Dietrich <marvin24@gmx.de>,
	"linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
	Stephen Warren <swarren@nvidia.com>,
	Colin Cross <ccross@android.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 13, 2012 at 11:25 AM, Rhyland Klein <rklein@nvidia.com> wrote:
> On Sun, 2012-02-12 at 11:13 -0800, Marc Dietrich wrote:
>> This adds device tree support for rfkill-gpio. The optional platform
>> paramters gpio_runtime_close and gpio_runtime_setup are not implemented.
>>
>> Cc: linux-wireless@vger.kernel.org
>> Cc: "John W. Linville" <linville@tuxdriver.com>
>> Cc: Johannes Berg <johannes@sipsolutions.net>
>> Cc: Rhyland Klein <rklein@nvidia.com>
>> Signed-off-by: Marc Dietrich <marvin24@gmx.de>
>> +
>>  static int rfkill_gpio_probe(struct platform_device *pdev)
>>  {
>>       struct rfkill_gpio_data *rfkill;
>>       struct rfkill_gpio_platform_data *pdata = pdev->dev.platform_data;
>> +     struct device_node *np = pdev->dev.of_node;
>>       int ret = 0;
>>       int len = 0;
>>
>> +     if (np)
>> +             pdata = rfkill_gpio_parse_pdata(pdev);
>> +
>
> The only concern I have is the precedence of devicetree settings vs
> platform data settings? If there is pdata passed in from board file
> initialization, and there is a device tree (a corner case but I think a
> valid one) then I believe the order would be that defined pdata would
> override the devicetree settings. That way if someone wanted to make a
> quick update, they wouldn't need to change the boot loader as well.

Yes, that is how other drivers tend to be coded -- only of pdata is
null will the driver try to fill in from the DT.


-Olof
