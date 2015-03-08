Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:39320 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757AbbCHLNO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Mar 2015 07:13:14 -0400
MIME-Version: 1.0
In-Reply-To: <2194797.iarD5YIxEd@wuerfel>
References: <1424362401-8228-1-git-send-email-eliad@wizery.com>
	<1424362401-8228-2-git-send-email-eliad@wizery.com>
	<2194797.iarD5YIxEd@wuerfel>
Date: Sun, 8 Mar 2015 13:13:13 +0200
Message-ID: <CAB3XZEfc3qV_o+0paM=HNdySKWwiJDfH=kJ8u0tz1ae+3ujxVw@mail.gmail.com> (sfid-20150308_121318_508423_3972EEBE)
Subject: Re: [PATCH v3 2/2] wl18xx: add basic device-tree support
From: Eliad Peller <eliad@wizery.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	Mark Rutland <mark.rutland@arm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 27, 2015 at 10:26 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thursday 19 February 2015 18:13:21 Eliad Peller wrote:
>> +
>> +static struct wl12xx_platform_data *wlcore_probe_of(struct device *dev)
>> +{
>> +       struct device_node *np = dev->of_node;
>> +       struct wl12xx_platform_data *pdata;
>> +
>> +       if (!np || !of_match_node(wlcore_sdio_of_match_table, np)) {
>> +               dev_err(dev, "No platform data set\n");
>> +               return NULL;
>> +       }
>> +
>> +       pdata = kzalloc(sizeof(*pdata), GFP_KERNEL);
>> +       if (!pdata)
>> +               return NULL;
>> +
>> +       pdata->irq = irq_of_parse_and_map(np, 0);
>> +       if (!pdata->irq) {
>> +               dev_err(dev, "No irq in platform data\n");
>> +               kfree(pdata);
>> +               return NULL;
>> +       }
>> +
>> +       return pdata;
>> +}
>> +#else
>> +static struct wl12xx_platform_data *wlcore_probe_of(struct device *dev)
>> +{
>> +       return NULL;
>> +}
>> +#endif
>> +
>> +static struct wl12xx_platform_data *
>> +wlcore_get_platform_data(struct device *dev)
>> +{
>> +       struct wl12xx_platform_data *pdata;
>> +
>> +       pdata = wl12xx_get_platform_data();
>> +       if (!IS_ERR(pdata))
>> +               return kmemdup(pdata, sizeof(*pdata), GFP_KERNEL);
>> +
>> +       return wlcore_probe_of(dev);
>> +}
>
> I think the probe_of needs to come first here, otherwise you cannot
> override the pdata quirk with actual DT data.
>
makes sense. i'll change it.

> I've looked up the what boards actually use this data and found that
> all of them already support booting from DT: some omap2 boards using
> arch/arm/mach-omap2/pdata-quirks.c to provide the data, and the
> davinci 850evm. Can you make sure you add the correct data to all
> of these dts files as part of your series and remove the
> wl12xx_platform_data references?

AFAICT, these board files add wl12xx platform data, while the new DT
support is only for wl18xx.

Eliad.
