Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f53.google.com ([209.85.214.53]:34475 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753Ab3GOGz6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jul 2013 02:55:58 -0400
Received: by mail-bk0-f53.google.com with SMTP id e11so4390773bkh.40
        for <linux-wireless@vger.kernel.org>; Sun, 14 Jul 2013 23:55:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87y59d5tgu.fsf@kamboji.qca.qualcomm.com>
References: <1372804925-1701-1-git-send-email-greearb@candelatech.com>
	<87y59d5tgu.fsf@kamboji.qca.qualcomm.com>
Date: Mon, 15 Jul 2013 08:55:56 +0200
Message-ID: <CA+BoTQkNmzOjHXyk4q+=W60Dx2B=i9htzNsE0moUzhMopQX=fw@mail.gmail.com> (sfid-20130715_085601_945630_89BCC9A0)
Subject: Re: [ath9k-devel] [PATCH] ath10k: Fix crash when using v1 hardware.
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: Ben Greear <greearb@candelatech.com>, ath10k@lists.infradead.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 11 July 2013 11:36, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> greearb@candelatech.com writes:
>
>> From: Ben Greear <greearb@candelatech.com>
>>
>> I put a v1 NIC from an TP-LINK AC 1750 AP in
>> a 64-bit PC, and the OS crashes on bootup.  I'm not
>> sure how broken my hardware is (possibly completely non
>> functional), but at least with this patch it will no longer
>> crash the OS.  Not sure it ever got far enough to try,
>> but I also do not have firmware for the NIC.
>>
>> With this patch I get this info on module load:
>>
>> ath10k_pci 0000:05:00.0: BAR 0: assigned [mem 0xf4400000-0xf45fffff 64bit]
>> ath10k_pci 0000:05:00.0: BAR 0: error updating (0xf4400004 != 0xffffffff)
>> ath10k_pci 0000:05:00.0: BAR 0: error updating (high 0x000000 != 0xffffffff)
>> ath10k_pci 0000:05:00.0: Refused to change power state, currently in D3
>> ath10k: MSI-X interrupt handling (8 intrs)
>> ath10k: Unable to wakeup target
>> ath10k: target takes too long to wake up (awake count 1)
>> ath10k: src_ring ffff88020c0d0a00:  write_index is out of bounds: 4294967295  nentries_mask: 15.
>> ath10k: dest_ring ffff88020db2c000:  write_index is out of bounds: 4294967295  nentries_mask: 511.
>> ath10k: dest_ring ffff880210d56400:  write_index is out of bounds: 4294967295  nentries_mask: 31.
>> ath10k: src_ring ffff880210d57600:  write_index is out of bounds: 4294967295  nentries_mask: 31.
>> ath10k: src_ring ffff88020fe70000:  write_index is out of bounds: 4294967295  nentries_mask: 2047.
>> ath10k: src_ring ffff880212989b40:  write_index is out of bounds: 4294967295  nentries_mask: 1.
>> ath10k: dest_ring ffff880212989960:  write_index is out of bounds: 4294967295  nentries_mask: 1.
>> ath10k: Failed to get pcie state addr: -5
>> ath10k: early firmware event indicated
>> ------------[ cut here ]------------
>> WARNING: at /home/greearb/git/linux.wireless-testing/drivers/net/wireless/ath/ath10k/ce.c:771 ath10k_ce_per_engine_service+0x53/0x1b4 [ath10k_pci]()
>> ....
>> (it hits the warning case about 5-6 times and then seems to quiesce OK).
>
> I haven't seen this myself so it might be a hw problem, but difficult to
> say.
>
>> +     /* On v1 hardware at least, setup can fail, causing ce_id_state to
>> +      * be cleaned up, but this method is still called a few times.  Check
>> +      * for NULL here so we don't crash.  Probably a better fix is to stop
>> +      * the ath10k_pci_ce_tasklet sooner.
>> +      */
>> +     if (WARN_ONCE(!ce_state, "ce_id_to_state[%i] is NULL\n", ce_id))
>> +             return;
>> +
>> +     ctrl_addr = ce_state->ctrl_addr;
>> +
>
> The tests you add look like workarounds. I would prefer to try fix these
> by going to the source of the problem. Maybe we should add
> ath10k_pci_wake() and ath10k_do_pci_wake()?

The teardown sequence is broken. Interrupts aren't
disabled/unregistered soon enough. I have a pending patch that should
fix this (although it's still more of a workaround than a real fix
since we need proper variable init code/ hw init code separation to be
done). However the patch depends on my recovery patchset so I haven't
posted it yet.


Pozdrawiam / Best regards,
Michał Kazior.
