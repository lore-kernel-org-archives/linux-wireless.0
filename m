Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f174.google.com ([209.85.218.174]:52304 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754897AbZENIYC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 May 2009 04:24:02 -0400
Received: by bwz22 with SMTP id 22so1127138bwz.37
        for <linux-wireless@vger.kernel.org>; Thu, 14 May 2009 01:24:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890905132134v1f3f32f8p8dc73a09834100b4@mail.gmail.com>
References: <1242030669.6930.10.camel@johannes.local>
	 <9b2b86520905120709v4bd00e1eo4da26e6c5f75c4ba@mail.gmail.com>
	 <43e72e890905132134v1f3f32f8p8dc73a09834100b4@mail.gmail.com>
Date: Thu, 14 May 2009 09:24:01 +0100
Message-ID: <9b2b86520905140124r8826484g7a0f040536785c8d@mail.gmail.com>
Subject: Re: [RFT v9] rfkill: rewrite
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Gaurav.Jauhar@atheros.com,
	Vivek Natarajan <vivek.natarajan@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5/14/09, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Tue, May 12, 2009 at 7:09 AM, Alan Jenkins
> <sourcejedi.lkml@googlemail.com> wrote:
>> On 5/11/09, Johannes Berg <johannes@sipsolutions.net> wrote:
>>> This patch completely rewrites the rfkill core to address
>>> the following deficiencies:

>> I tested on todays wireless-testing, aka v2.6.30-rc5-23297-gbf2c6a3.
>> Somehow, it triggers an OOPS
>>
>> Function: req_reg_info_regd
>> Process: modprobe
>>
>> Call trace:
>> wiphy_apply_custom_regulatory
>> ath5k_regd_init
>> ath5k_reg_notifier
>> ath5k_pci_probe
>> ...
>>
>> Photo:
>> <http://picasaweb.google.com/sourcejedi.lkml/Screenshots#5334936857267342674>
>
> BTW can explain how to reproduce. Did you just use wireless-testing
> and johanne's rfkill rewrite and use ath5k and can easily reproduce?

Yes.  wireless-testing (v2.6.30-rc5-23297-gbf2c6a3) + Johan's rfkill
rewrite.  ath5k on the original model EeePC.  The OOPS happens on
every boot with this combination.

> Do you have an ath9k card?

No.

Thanks,
Alan
