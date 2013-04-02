Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:53420 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754734Ab3DBMYg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Apr 2013 08:24:36 -0400
Message-ID: <515ACE00.7020103@openwrt.org> (sfid-20130402_142440_129037_7A112A44)
Date: Tue, 02 Apr 2013 14:24:32 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Robert Shade <robert.shade@gmail.com>
CC: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Adrian Chadd <adrian@freebsd.org>
Subject: Re: [PATCH] ath9k: Re-enable interrupts after a channel change failure
References: <CAMgrJ3b0EUUae8k1Z2RR92eLbFyPGpqA5px1J_gALDTJ+rmAnA@mail.gmail.com> <5159C697.4040609@openwrt.org> <CAMgrJ3YFCY1gFp6sT5HJw-KVpvGpx82_HiZkWBDQj1Me96Bw=w@mail.gmail.com>
In-Reply-To: <CAMgrJ3YFCY1gFp6sT5HJw-KVpvGpx82_HiZkWBDQj1Me96Bw=w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-04-02 2:03 PM, Robert Shade wrote:
> On Mon, Apr 1, 2013 at 1:40 PM, Felix Fietkau <nbd@openwrt.org> wrote:
>> Your patch is badly whitespace damaged.
> 
> Ouch, must be the gmail web client.  I'll resubmit a fixed one.
> 
>> Why the call to ath9k_hw_set_interrupts here?
> 
> Simply because that's what ath_complete_reset does
OK. You can leave it out, because it's not required for
interrupt-disable refcounting, and it will be called again after a
successful reset.

- Felix
