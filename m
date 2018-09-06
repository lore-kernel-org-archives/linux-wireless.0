Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:53012 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725978AbeIFOOs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Sep 2018 10:14:48 -0400
Subject: Re: [PATCH 39/42] mt76: move some irq code to common mmio module
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-mediatek@lists.infradead.org
References: <1536225538-16454-1-git-send-email-sgruszka@redhat.com>
 <1536225538-16454-40-git-send-email-sgruszka@redhat.com>
 <91c0c1d5-12a9-7155-c4bf-191a511080ee@nbd.name>
 <CAJ0CqmWrDke=WWPukf09rXYkCV3e4JKgcoBgvytVeyy1j8ZvOA@mail.gmail.com>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <786cb12a-a27e-bd82-edfd-9ea5866e5e00@nbd.name> (sfid-20180906_114014_770836_03A0FA4E)
Date: Thu, 6 Sep 2018 11:40:09 +0200
MIME-Version: 1.0
In-Reply-To: <CAJ0CqmWrDke=WWPukf09rXYkCV3e4JKgcoBgvytVeyy1j8ZvOA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-09-06 11:37, Lorenzo Bianconi wrote:
>>
>> On 2018-09-06 11:18, Stanislaw Gruszka wrote:
>> > Move some irq handling code to generic mmio module.
>> >
>> > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
>> Please drop this patch. This won't work on MT7603 and later.
>>
>> - Felix
> 
> I can move that code in a dedicated module with a separated patch.
> I have a pending patchset to fix that kind of issues for usb as well.
> Does it sound good?
I don't think it's worth having yet another dedicated module for these
small things. Just keep it in the common mt76x02 code, even if it
doesn't get used by the usb variants.

- Felix
