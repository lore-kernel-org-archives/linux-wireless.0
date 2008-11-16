Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.29]:50860 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661AbYKPGG7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Nov 2008 01:06:59 -0500
Received: by yw-out-2324.google.com with SMTP id 9so865416ywe.1
        for <linux-wireless@vger.kernel.org>; Sat, 15 Nov 2008 22:06:58 -0800 (PST)
Message-ID: <43e72e890811152206s3683ecabm658fac255112a262@mail.gmail.com> (sfid-20081116_070702_383199_9288BE4B)
Date: Sat, 15 Nov 2008 22:06:58 -0800
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Bob Copeland" <me@bobcopeland.com>
Subject: Re: Kernel oops when loading ath5k from compat-wireless in 2.6.27
Cc: "Dan McGee" <dpmcgee@gmail.com>, linux-wireless@vger.kernel.org,
	"Michael Buesch" <mb@bu3sch.de>
In-Reply-To: <43e72e890811152205k13318ab7yad8695d9f6dd409c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <449c10960811132146s40aef6c6ue8dfeef5ba29812a@mail.gmail.com>
	 <43e72e890811132217k160db63ch77e7d03c38e81d5f@mail.gmail.com>
	 <b6c5339f0811140902t7c7cfc0wa54c3cf578a620ff@mail.gmail.com>
	 <449c10960811151811s32fdd2b6p361d2ec9dd674fcc@mail.gmail.com>
	 <449c10960811151838m3fcae118n65139be735c10665@mail.gmail.com>
	 <43e72e890811152148q5f65aa43u49555a3977c205ff@mail.gmail.com>
	 <20081116055312.GA14126@hash.localnet>
	 <43e72e890811152205k13318ab7yad8695d9f6dd409c@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Nov 15, 2008 at 10:05 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Sat, Nov 15, 2008 at 9:53 PM, Bob Copeland <me@bobcopeland.com> wrote:
>> On Sat, Nov 15, 2008 at 09:48:13PM -0800, Luis R. Rodriguez wrote:
>>> Not sure why its 00000001, nor do I know if its poison. One thing I am
>>> fairly positive about is that the reason why this was wrong all along
>>> was because we were trying to get the device's ->driver structure to
>>> get driver->name but the device won't get its ->driver pointer
>>> assigned until *after* a successful probe. Lets review the PCI probe:
>>
>> No, as I later corrected myself, that is pci_dev->driver, but what
>> mac80211 is using is pci_dev->dev.driver.
>
> Right, the dev for the pci_dev which hasn't yet had a driver assigned
> yet, no? Who assigns the pci_dev's dev's driver pointer and when? Or
> am I still missing something?

Oh nevermind yeah pci_dev->driver = drv; but still who then assigns
the dev's driver?

  Luis
