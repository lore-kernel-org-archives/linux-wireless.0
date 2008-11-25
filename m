Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:60119 "EHLO ds10.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751832AbYKYWrs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2008 17:47:48 -0500
Message-ID: <492C808A.20403@openwrt.org> (sfid-20081125_234753_772842_13437823)
Date: Tue, 25 Nov 2008 23:47:38 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Benoit PAPILLAULT <benoit.papillault@free.fr>
CC: Maxim Levitsky <maximlevitsky@gmail.com>,
	Derek Smithies <derek@indranet.co.nz>,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, ipw3945-devel@lists.sourceforge.net,
	wally@theblackmoor.net, Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [ath5k-devel] Unusually low speeds with ath5k and iwl3945
References: <492719ED.5000006@gmail.com> <20081122005240.GA27826@hash.localnet>	<alpine.DEB.2.00.0811221643030.7067@monster> <4927FC0C.10900@gmail.com> <492A5913.3070007@free.fr> <492A7733.2000205@openwrt.org> <492C55FC.2040506@free.fr>
In-Reply-To: <492C55FC.2040506@free.fr>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Benoit PAPILLAULT wrote:
> Felix Fietkau a =E9crit :
>> While reading the code for calculating the frame duration, i noticed
>> something odd: It doesn't seem to be taking into account the short
>> vs long preamble distinction for ERP rates. IMHO this might be causi=
ng
>> issues like this. I've seen similar behaviour a long time ago when t=
esting
>> iwl3945 against a Broadcom AP with exactly the same throughput drop =
(500-
>> 600 kbits/s).
>> When I analyzed the problem with an extra monitor mode card, I found=
 out
>> that the throughput drop is caused by a huge number of retransmissio=
ns,
>=20
> In the test I've done, there was no retransmission at all (no
> duplicates). I don't save a capture file, so I cannot tell for sure.
Which test specifically? iwl3945 or ath5k?
If ath5k doesn't show any retransmissions, the problem might not be
related. Please do make some logs of the throughput issue and then
some more of the same kind of traffic without throughput issues
(same card, same driver).

> What is the code computing frame duration you are referring to? How i=
t
> could affect the hardware behavior?
I looked at it again and now I don't think it's the cause anymore. I
 did some comparisons against other stacks/drivers and this part
seems correct after all.

- Felix
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
