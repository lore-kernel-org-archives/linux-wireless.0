Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:37495 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbbCBJXy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Mar 2015 04:23:54 -0500
Received: by wivr20 with SMTP id r20so13225552wiv.2
        for <linux-wireless@vger.kernel.org>; Mon, 02 Mar 2015 01:23:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1425287785.1906.0.camel@sipsolutions.net>
References: <1425287344-30594-1-git-send-email-michal.kazior@tieto.com>
	<1425287344-30594-2-git-send-email-michal.kazior@tieto.com>
	<1425287785.1906.0.camel@sipsolutions.net>
Date: Mon, 2 Mar 2015 10:23:53 +0100
Message-ID: <CA+BoTQnrS74yx=V_sPvTgzkoZeWbOBFawqXZMAv6oEhUypmoQA@mail.gmail.com> (sfid-20150302_102359_087675_0642F7A9)
Subject: Re: [PATCH 2/3] ath10k: always save/restore pci config space
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2 March 2015 at 10:16, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2015-03-02 at 10:09 +0100, Michal Kazior wrote:
>> The check isn't really necessary and couldn't even
>> work because becase pci_restore_state() restores
>> only first 64 bytes of PCI configuration space.
>>
>> This is necessary for future WoWLAN support.
>
>> +     pci_save_state(pdev);
>> +     pci_disable_device(pdev);
>
> I believe the whole thing isn't necessary at all since the kernel's PCIe
> layer will take care of it.

You mean only the pci_save_state() and pci_disable_device() or, the
resume counterpart as well? Hmm.

Earlier the resume counterpart didn't do any restore stuff and the
device ended up pretty confused..


Michał
