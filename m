Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.190]:41151 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108AbYKPGFX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Nov 2008 01:05:23 -0500
Received: by rn-out-0910.google.com with SMTP id k40so1694137rnd.17
        for <linux-wireless@vger.kernel.org>; Sat, 15 Nov 2008 22:05:22 -0800 (PST)
Message-ID: <43e72e890811152205k13318ab7yad8695d9f6dd409c@mail.gmail.com> (sfid-20081116_070527_627454_D393E705)
Date: Sat, 15 Nov 2008 22:05:21 -0800
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Bob Copeland" <me@bobcopeland.com>
Subject: Re: Kernel oops when loading ath5k from compat-wireless in 2.6.27
Cc: "Dan McGee" <dpmcgee@gmail.com>, linux-wireless@vger.kernel.org,
	"Michael Buesch" <mb@bu3sch.de>
In-Reply-To: <20081116055312.GA14126@hash.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <449c10960811132146s40aef6c6ue8dfeef5ba29812a@mail.gmail.com>
	 <43e72e890811132217k160db63ch77e7d03c38e81d5f@mail.gmail.com>
	 <b6c5339f0811140902t7c7cfc0wa54c3cf578a620ff@mail.gmail.com>
	 <449c10960811151811s32fdd2b6p361d2ec9dd674fcc@mail.gmail.com>
	 <449c10960811151838m3fcae118n65139be735c10665@mail.gmail.com>
	 <43e72e890811152148q5f65aa43u49555a3977c205ff@mail.gmail.com>
	 <20081116055312.GA14126@hash.localnet>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Nov 15, 2008 at 9:53 PM, Bob Copeland <me@bobcopeland.com> wrote:
> On Sat, Nov 15, 2008 at 09:48:13PM -0800, Luis R. Rodriguez wrote:
>> Not sure why its 00000001, nor do I know if its poison. One thing I am
>> fairly positive about is that the reason why this was wrong all along
>> was because we were trying to get the device's ->driver structure to
>> get driver->name but the device won't get its ->driver pointer
>> assigned until *after* a successful probe. Lets review the PCI probe:
>
> No, as I later corrected myself, that is pci_dev->driver, but what
> mac80211 is using is pci_dev->dev.driver.

Right, the dev for the pci_dev which hasn't yet had a driver assigned
yet, no? Who assigns the pci_dev's dev's driver pointer and when? Or
am I still missing something?

  Luis
