Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:9973 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758576AbcCVJua (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Mar 2016 05:50:30 -0400
Subject: Re: making fq_codel default
To: Reinoud Koornstra <reinoudkoornstra@gmail.com>
References: <CAAA5faG+AOviPrJxd9dOuZrDAkm+4F5sy0M7w3MW0U-ufNeZ3g@mail.gmail.com>
Cc: linux-wireless@vger.kernel.org
From: Matthias May <matthias.may@neratec.com>
Message-ID: <56F113B3.2050608@neratec.com> (sfid-20160322_105107_281574_6B8439B6)
Date: Tue, 22 Mar 2016 10:43:15 +0100
MIME-Version: 1.0
In-Reply-To: <CAAA5faG+AOviPrJxd9dOuZrDAkm+4F5sy0M7w3MW0U-ufNeZ3g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22/03/16 10:37, Reinoud Koornstra wrote:
> Hi Everyone,
>
> Everytime I boot I need to set fq_codel for my wireless interface:
>
> sudo tc qdisc add   dev wlp4s0 root fq_codel
>
> I also need to sudo sysctl -w net.core.default_qdisc=fq_codel
>
> Is there a good way to have this as the default in the kernel config
> instead of pfifo?
> Also, are there plans for cake support or do fq_codel in this case mean cake?
> Thanks,
>
> Reinoud.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

You might want to take a look at the patches in openwrt.
Specifically this one:
https://dev.openwrt.org/browser/trunk/target/linux/generic/patches-4.4/662-use_fq_codel_by_default.patch

Best regards
Matthias
