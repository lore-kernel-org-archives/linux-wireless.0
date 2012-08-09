Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:57764 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754209Ab2HIWGf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Aug 2012 18:06:35 -0400
Received: by obbuo13 with SMTP id uo13so1245839obb.19
        for <linux-wireless@vger.kernel.org>; Thu, 09 Aug 2012 15:06:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <50242B80.4060509@openwrt.org>
References: <CAA2SeNJmaHs5fMHrG65HWbe5Y-ytz2qvuzNGKvhBKgvZ15KoVw@mail.gmail.com>
	<20120809173435.GQ3745@lenteja.do-not-panic.com>
	<CAA2SeNKbBCxPbJmXMyo4-nK2SXL-WcOFQaKDrEM-cxbVrzt7Ew@mail.gmail.com>
	<CAB=NE6V6T0RMSiMZCsUdr85vWMgs4VfJ6HTYHwf+kDQUwQ-mhg@mail.gmail.com>
	<20120809170757.748b68bf@mj>
	<CAB=NE6UracUuvGhQcnkfDsi1peNMgvagS0jyYgSvamim4tiLWA@mail.gmail.com>
	<50242B80.4060509@openwrt.org>
Date: Fri, 10 Aug 2012 00:06:34 +0200
Message-ID: <CAA2SeNJ_+ajhcfF1Zdh77W6qNZHXZwgBaQ7psP7zgmkaQW5_0Q@mail.gmail.com> (sfid-20120810_000639_097071_A577CFF7)
Subject: Re: [PATCH v2] ath9k: decrypt_error flag issue
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>,
	Pavel Roskin <proski@gnu.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On 2012-08-09 11:21 PM, Luis R. Rodriguez wrote:
>> On Thu, Aug 9, 2012 at 2:07 PM, Pavel Roskin <proski@gnu.org> wrote:
>>> On Thu, 9 Aug 2012 11:10:38 -0700
>>> "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com> wrote:
>>>
>>>> And this would lead to .. what? How did you realize this? Can you
>>>> please resend and add all this information to the commit log message?
>>>
>>> Also please use a better subject.  For example:
>>>
>>> ath9k: fix decrypt_error initialization in ath_rx_tasklet()
>>>
>>> "issue" is too vague.
>>
>> Also -- what I was getting at is to evaluate whether or not this is an
>> important fix or critical. To determine if its critical it helps to
>> understand exactly what negative behavior was observed. If its
>> critical it can go to stable but I have a feeling this is not
>> critical. If its not critical and only important although it won't go
>> to stable I'll still cherry pick it for the stable compat-wireless
>> releases.
> I think it's critical enough for stable. I think when using CCMP
> encryption, high CPU load can get the connection stuck (because of CCMP
> PN corruption when the issue occurs).
>
> - Felix
>

 I was using a two hop network encrypted with AES CCMP.

STA <---f0---> Node A <---f0---> Node B   f0=2412GHz

Node A and node B were running latest OpenWRT trunk, AR9280 chipset.
I was injecting 30Mbps of UDP iperf traffic from STA to Node B.
I was facing a connection stuck issue on Node B side because it
reports a lot of decrypt errors
and since decrypt_error flag sets to true, it tries to decrypt an
already decrypted frame with ieee80211_aes_ccm_decrypt. Setting
decrypt_error to false at beginning of ath_rx_tasklet cycle
the connection is definitely more stable avoiding waste of CPU time.

Regards

Lorenzo
