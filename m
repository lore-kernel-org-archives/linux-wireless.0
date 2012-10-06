Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:52057 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754385Ab2JFJDv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Oct 2012 05:03:51 -0400
Message-ID: <506FF3ED.6010906@openwrt.org> (sfid-20121006_110405_779903_448CBFAB)
Date: Sat, 06 Oct 2012 11:03:41 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Adrian Chadd <adrian@freebsd.org>
CC: Sven Eckelmann <sven@narfation.org>,
	Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mcgrof@qca.qualcomm.com, ath9k-devel@lists.ath9k.org,
	lindner_marek@yahoo.de
Subject: Re: [ath9k-devel] [PATCHv2] ath9k_hw: Handle AR_INTR_SYNC_HOST1_FATAL
 on AR9003
References: <1348756862-8788-1-git-send-email-sven@narfation.org> <506B0628.6070201@openwrt.org> <CAJ-Vmo=bu=j+=z_TAeE3--Sn5oAEbkEG-HDqK=6okR8xmmWpSQ@mail.gmail.com> <2629427.e28b8DS3gI@bentobox> <506ED3D4.7050107@openwrt.org> <CAJ-VmonKjxmquSUg99kAtPWVwHH-4zTooF1Xvj9mGUyjWL5pCA@mail.gmail.com> <20121005165152.GA4473@sven-atom.home.narfation.org> <CAJ-VmomfDr-JAMtgQmbEsSeF62W-dmsK7LRTJxNUUddOTqDayA@mail.gmail.com>
In-Reply-To: <CAJ-VmomfDr-JAMtgQmbEsSeF62W-dmsK7LRTJxNUUddOTqDayA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-10-06 1:48 AM, Adrian Chadd wrote:
> On 5 October 2012 09:51, Sven Eckelmann <sven@narfation.org> wrote:
> 
>>> Well, is it a RX chainmask thing, or is it a chip thing?
>>>
>>> It's totally possible to have an RX chainmask of say 0x2 or 0x4..
>>
>> What are you trying to tell us?
> 
> That the check for "rx chainmask == 1? Definitely can't do MRC CCK"
> implying "rx chainmask != 1? Definitely can do MRC CCK."
> I think that's the wrong logic. It may be a general chipset problem
> across some/all AR9300 and later chips that doing MRC CCK with only
> one RX chain enabled is a problem, or it may be a single-chain NIC
> problem.
> 
> I'm pretty sure we can configure any of the RX antennas; it doesn't
> have to be "one chain == chain 0."
> 
> Anywy. I'll double check that.
I'm pretty sure it's an issue specific to single-stream chipsets, where
all MRC functionality was left out (and thus the register access leads
nowhere).
I don't think this needs to consider multi-stream chipsets with only one
enabled chain.

- Felix

