Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2nam03on0084.outbound.protection.outlook.com ([104.47.42.84]:44987
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751826AbdCMKYp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Mar 2017 06:24:45 -0400
Subject: Re: [PATCH v5] qtnfmac: announcement of new FullMAC driver for
 Quantenna chipsets
To: Christian Lamparter <chunkeey@googlemail.com>
References: <1489262657-8191-1-git-send-email-igor.mitsyanko.os@quantenna.com>
 <2641812.B5DpPPlh2Q@debian64>
CC: <linux-wireless@vger.kernel.org>, <johannes@sipsolutions.net>,
        Dmitrii Lebed <dlebed@quantenna.com>,
        Sergei Maksimenko <smaksimenko@quantenna.com>,
        Sergey Matyukevich <smatyukevich@quantenna.com>,
        Bindu Therthala <btherthala@quantenna.com>,
        Huizhao Wang <hwang@quantenna.com>,
        Kamlesh Rath <krath@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Message-ID: <b0d48b52-3374-04d2-49da-63d40c24af23@quantenna.com> (sfid-20170313_112505_946740_8589008F)
Date: Mon, 13 Mar 2017 13:24:32 +0300
MIME-Version: 1.0
In-Reply-To: <2641812.B5DpPPlh2Q@debian64>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/12/2017 07:59 PM, Christian Lamparter wrote:
> On Saturday, March 11, 2017 11:04:17 PM CET Igor Mitsyanko wrote:
>> This patch adds support for new FullMAC WiFi driver for Quantenna
>> QSR10G chipsets.
>>
>> QSR10G (aka Pearl) is Quantenna's 8x8, 160M, 11ac offering.
>> QSR10G supports 2 simultaneous WMACs - one 5G and one 2G.
>> 5G WMAC supports 160M, 8x8 configuration. FW supports
>> up to 8 concurrent virtual interfaces on each WMAC.
>> [...]
> ---
>
> I see a lot of error/warning/info messages the likes of:
>
> pr_err("failed to change interface type\n");
> pr_err("bss not started\n");
> pr_err("failed to configure phy thresholds\n");
> pr_err("failed to add key\n");
> pr_err("failed to delete key\n");
> pr_err("failed to change STA\n");
> ...
>
> I'm wondering what this will look like if there are multiple VIFs,
> multiple PHYs or more than one QSR10G in a System. How - for example -
> can you map a error/warning/info message to the individual Client, VIF,
> PHY instance or device? From what I can tell, this is bound to get very
> confusing very fast.
>
> the kernel and cfg80211 has a ton of predefined logging and debug
> functions: dev_[info|warn|err|...], wiphy_[WARN|emerg|alert|crit|err|warn|...]
> I think using those functions (and adding information about the client/vif)
> would tremendously help with that?

Christian, makes sense, thanks. We will change the way driver does 
error/info reporting.

>
> Thanks,
> Christian
>
