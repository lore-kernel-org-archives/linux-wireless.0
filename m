Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:42246 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804Ab2BQIui (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Feb 2012 03:50:38 -0500
Received: by werb13 with SMTP id b13so1679307wer.19
        for <linux-wireless@vger.kernel.org>; Fri, 17 Feb 2012 00:50:37 -0800 (PST)
Message-ID: <4F3E14D9.2010204@openwrt.org> (sfid-20120217_095042_936348_979ACF0D)
Date: Fri, 17 Feb 2012 09:50:33 +0100
From: Florian Fainelli <florian@openwrt.org>
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: Helmut Schaa <helmut.schaa@googlemail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	users@rt2x00.serialmonkey.com, gwingerde@gmail.com,
	Ivo Van Doorn <ivdoorn@gmail.com>,
	Andreas Hartmann <andihartmann@freenet.de>
Subject: Re: Poor RT2880 performance
References: <4F390ED3.8010400@openwrt.org> <CAGXE3d90az_g3KyzPp-4NQoM2zmXaNSVo=7piM=q8EK9WdBp7A@mail.gmail.com> <4F3961FB.7020409@openwrt.org> <20120216130020.GG25833@redhat.com>
In-Reply-To: <20120216130020.GG25833@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Stanislaw,

Le 02/16/12 14:00, Stanislaw Gruszka a écrit :
> On Mon, Feb 13, 2012 at 08:18:19PM +0100, Florian Fainelli wrote:
>> Le 02/13/12 14:45, Helmut Schaa a écrit :
>>> On Mon, Feb 13, 2012 at 2:23 PM, Florian Fainelli<florian@openwrt.org>   wrote:
>>>> I am playing with a RT2880-F based AP, with a N connected station, in a
>>>> residential environment.
>>> Mind to provide the RF and RT chipset identifications? rt2x00 should print them
>>> out during module load (at least when compiled with debugging options).
>> Sure, here are the HW infos of the AP:
>> Ralink RT2880   id:1 rev:1 running at 266.66 MHz
>> phy0 ->  rt2x00_set_chip: Info - Chipset detected - rt: 2860, rf:
>> 0001, rev: 0101.
> Did you try to revert commit (if you use kernel, which include it) ?
>
> commit f0425beda4d404a6e751439b562100b902ba9c98
> Author: Felix Fietkau<nbd@openwrt.org>
> Date:   Sun Aug 28 21:11:01 2011 +0200
>
>      mac80211: retry sending failed BAR frames later instead of tearing
>
> It was already identified that it couse performace issues on rt2860
> based APs.

Indeed, that seems to give me much better throughput, now I am around 
45Mbits/sec in HT20 and 64Mbits/sec in HT40+.

On a crowded channel, I could get 20Mbits/sec compared to the previous 
5Mbits/sec.

Do you know what could be the fix for RT2860 not to be impacted by this 
change or play nicely with it?

Thanks.
--
Florian
