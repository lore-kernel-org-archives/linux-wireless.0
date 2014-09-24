Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:50735 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbaIXHJP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Sep 2014 03:09:15 -0400
Received: by mail-we0-f170.google.com with SMTP id x48so4238594wes.29
        for <linux-wireless@vger.kernel.org>; Wed, 24 Sep 2014 00:09:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5421A44C.8080307@candelatech.com>
References: <1411426820-4047-1-git-send-email-greearb@candelatech.com>
	<CA+BoTQn9sECMNZsxQpB4i3wHPxfVL+LXq9=2GBd-opH6+9TD=A@mail.gmail.com>
	<5421A44C.8080307@candelatech.com>
Date: Wed, 24 Sep 2014 09:09:13 +0200
Message-ID: <CA+BoTQ=mry3tPD-LK+gFD2bC6RU0KvY6LC9=FOAGTLi_1rzUog@mail.gmail.com> (sfid-20140924_090920_807483_F1278F73)
Subject: Re: [PATCH] ath10k: use configured nss instead of max nss.
From: Michal Kazior <michal.kazior@tieto.com>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 23 September 2014 18:48, Ben Greear <greearb@candelatech.com> wrote:
> On 09/23/2014 01:59 AM, Michal Kazior wrote:
>> On 23 September 2014 01:00,  <greearb@candelatech.com> wrote:
>>> From: Ben Greear <greearb@candelatech.com>
[...]
>>> @@ -4086,6 +4086,10 @@ ath10k_default_bitrate_mask(struct ath10k *ar,
>>>         u32 legacy = 0x00ff;
>>>         u8 ht = 0xff, i;
>>>         u16 vht = 0x3ff;
>>> +       u16 nrf = ar->num_rf_chains;
>>> +
>>> +       if (ar->cfg_tx_chainmask)
>>> +               nrf = get_nss_from_chainmask(ar->cfg_tx_chainmask);
[...]
>> I think it might be a good idea to convey the limitation of tx/rx
>> chainmask to the user: you can't change the tx/rx chainmask on the fly
>> easily (while connected/have associated stations). Or do you plan to
>> schedule peer reassoc in __ath10k_set_antenna() in a follow up
>> patch(es) later?
>
> My user-space tools assume you have to re-connect (requested from user-space)
> after changing the chainmask.  I was under the impression that this
> is how ath9k works, though I could be wrong.

ath9k doesn't have firmware and it doesn't have a blackbox rate
control so maybe it doesn't need to worry about this as much as ath10k
needs to.

But then this is not something you normally use except some very
specific use cases so I think it might not be worth the hassle to
implement full-blown reconfig after chainmask is updated.


> I would rather keep this requirement in user-space...
>
> I am not sure where to document this...just a comment in the code?

Hmm.. Perhaps in ath10k_set_antenna? Or maybe we should just put it up
on the wiki?

But it's still probably a good idea to comment the quoted code chunk
above explaining why nrf is overriden by chainmask (i.e. due to
firmware rate control issues, right?).


Michał
