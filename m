Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from avon.wwwdotorg.org ([70.85.31.133]:32994 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195AbaBUFfX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Feb 2014 00:35:23 -0500
Message-ID: <5306E599.7020605@wwwdotorg.org> (sfid-20140221_063603_044816_1281A5C9)
Date: Thu, 20 Feb 2014 22:35:21 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
MIME-Version: 1.0
To: Chen-Yu Tsai <wens@csie.org>
CC: Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"David S. Miller" <davem@davemloft.net>,
	Rhyland Klein <rklein@nvidia.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	netdev <netdev@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Linus Walleij <linus.walleij@linaro.org>,
	Alexandre Courbot <gnurou@gmail.com>
Subject: Re: [PATCH 2/4] net: rfkill: gpio: remove gpio names
References: <1392900697-27577-1-git-send-email-heikki.krogerus@linux.intel.com> <1392900697-27577-3-git-send-email-heikki.krogerus@linux.intel.com> <53062F97.3050407@wwwdotorg.org> <CAGb2v66-tDZhrm9dnXe+PdQTaLZbw20sw3uYzLor2eXpVWmPMA@mail.gmail.com>
In-Reply-To: <CAGb2v66-tDZhrm9dnXe+PdQTaLZbw20sw3uYzLor2eXpVWmPMA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/20/2014 06:55 PM, Chen-Yu Tsai wrote:
> Hi,
> 
> On Fri, Feb 21, 2014 at 12:38 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>> On 02/20/2014 05:51 AM, Heikki Krogerus wrote:
>>> There is no use for them in this driver. This will fix a
>>> static checker warning..
>>
>> Didn't you remove the use:
>>
>> -       gpio = devm_gpiod_get_index(&pdev->dev, rfkill->reset_name, 0);
>> +       gpio = devm_gpiod_get_index(&pdev->dev, NULL, 0);
>>
>> doesn't that parameter get put into the sysfs GPIO debug file, so people
>> can see which GPIOs are used for what?
> 
> That's correct. However using con_id to pass this results in different
> behavior across DT and ACPI. A better way is to export the labeling
> function so consumers can set meaningful labels themselves.

But this code is the consumer of those GPIOs. IF the parameter to
devm_gpiod_get_index() isn't intended to be used, why does it exist?

