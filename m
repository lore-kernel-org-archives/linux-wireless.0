Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:9032 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbaCZJ2U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Mar 2014 05:28:20 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH 1/8] ath10k: cleanup ath10k_pci_wait_for_target_init()
References: <20140325091311.16651.15747.stgit@potku.adurom.net>
	<20140325091505.16651.15554.stgit@potku.adurom.net>
	<CA+BoTQns9QXCctzrMzd5=o6EyA=d0TG-eLJw3hztE1-MD7HwkQ@mail.gmail.com>
Date: Wed, 26 Mar 2014 11:28:14 +0200
In-Reply-To: <CA+BoTQns9QXCctzrMzd5=o6EyA=d0TG-eLJw3hztE1-MD7HwkQ@mail.gmail.com>
	(Michal Kazior's message of "Tue, 25 Mar 2014 10:32:49 +0100")
Message-ID: <87lhvxz4up.fsf@kamboji.qca.qualcomm.com> (sfid-20140326_102841_544081_AF6BDA77)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 25 March 2014 10:15, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>> ath10k_pci_wait_for_target_init() did really follow the style used elsewhere in
>> ath10k. Use ath10k_pci_read/write() wrappers, simplify the while loop and
>> improve warning messages.
>>
>> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
>> ---
>>  drivers/net/wireless/ath/ath10k/pci.c |   33 ++++++++++++++++++++-------------
>>  1 file changed, 20 insertions(+), 13 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
>> index 9d242d801d9d..0425c76daf3f 100644
>> --- a/drivers/net/wireless/ath/ath10k/pci.c
>> +++ b/drivers/net/wireless/ath/ath10k/pci.c
>> @@ -2385,30 +2385,37 @@ static int ath10k_pci_deinit_irq(struct ath10k *ar)
>>  static int ath10k_pci_wait_for_target_init(struct ath10k *ar)
>>  {
>>         struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
>> -       int wait_limit = 300; /* 3 sec */
>> +       const int wait = 3000; /* ms */
>
> We probably should have a #define for this.

Yeah, I'll change that.

>> -       while (wait_limit-- &&
>> -              !(ioread32(ar_pci->mem + FW_INDICATOR_ADDRESS) &
>> -                FW_IND_INITIALIZED)) {
>> +       timeout = jiffies + msecs_to_jiffies(wait);
>> +
>> +       do {
>> +               val = ath10k_pci_read32(ar, FW_INDICATOR_ADDRESS);
>> +               if (val == FW_IND_INITIALIZED)
>> +                       break;
>> +
>
> It might be worth to add:
>
>  if (val == 0xFFFFFFFF)
>    return -EIO;

What does receiving 0xFFFFFFFF mean here? PCI bus kaput?

Do we really want to stop trying after receiving that? What harm would
it cause to keep on trying? We would return an error anyway after the
timeout, right?

>> +       } while (time_before(jiffies, timeout));
>>
>> -       if (wait_limit < 0) {
>> -               ath10k_err("target stalled\n");
>> -               ret = -EIO;
>> +       if (val != FW_IND_INITIALIZED) {
>> +               ath10k_err("failed to receive initialized event from target after %d ms: %d\n",
>> +                          wait, val);
>
> `val` is u32 so it shouldn't be %d. %08x makes most sense I guess.

I'll change it.

Thanks for the review!

-- 
Kalle Valo
