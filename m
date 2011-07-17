Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:55002 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752671Ab1GQMvv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jul 2011 08:51:51 -0400
Received: by wwi14 with SMTP id 14so2588185wwi.29
        for <linux-wireless@vger.kernel.org>; Sun, 17 Jul 2011 05:51:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CABB-i1foCSozXa1ZacqNPf_-vEUrw9uv+V6rraFhM-FoNoo3qg@mail.gmail.com>
References: <1310647673-10144-1-git-send-email-geryk@ti.com>
	<1310647673-10144-2-git-send-email-geryk@ti.com>
	<874o2nx16b.fsf@purkki.adurom.net>
	<CABB-i1foCSozXa1ZacqNPf_-vEUrw9uv+V6rraFhM-FoNoo3qg@mail.gmail.com>
Date: Sun, 17 Jul 2011 15:51:47 +0300
Message-ID: <CABB-i1eXpgA7iiHmrstFBnNjGntUtydQFBL17SJELqt5HU8g3A@mail.gmail.com> (sfid-20110717_145157_291578_8B3129A4)
Subject: Re: [PATCH 2/2] wl12xx Export chip id to sysfs
From: "Kahn, Gery" <geryk@ti.com>
To: Kalle Valo <kvalo@adurom.com>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

On Sun, Jul 17, 2011 at 11:16, Kahn, Gery <geryk@ti.com> wrote:
> On Fri, Jul 15, 2011 at 13:56, Kalle Valo <kvalo@adurom.com> wrote:
>> Gery Kahn <geryk@ti.com> writes:
>>
>>> Export the chip id to userspace. This helps to change application behavior
>>> according to architecture of the wl12xx chip.
>>
>> We already support exporting this type of information through
>> ethtool's ioctl interface using the wiphy.hw_version, which was
>> specifially added for this purpose. That's much better than yet
>> another sysfs file.
>>
> Right.
> In PLT mode it didn't show any information, but
> that might have been a mistake on our part.
>
> I'll send another patch.
>
After some investigation, found that ethtool's ioctl interface doesn't work
at this case.

1.
It demands data for registers while the purpose of the change was to have
only HW version at sysfs.
BTW, if the registers data exists, the ethtool doesn't display
HW version anyway.

2.
The datapath of ioctl SIOCETHTOOL also has problem that can be solved
by changing the cfg80211_get_regs_len() from net/wireless/ethtool.c

static int cfg80211_get_regs_len(struct net_device *dev)
        struct wireless_dev *wdev = dev->ieee80211_ptr;
        return sizeof(wdev->wiphy->hw_version);
}
But i need to check more with other drivers may be.

I am back to suggest my patch for the case.

Gery
