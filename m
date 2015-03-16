Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:35902 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757198AbbCPRvP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Mar 2015 13:51:15 -0400
Message-ID: <5507180F.1010400@gmail.com> (sfid-20150316_185132_842755_6EFEBCDA)
Date: Mon, 16 Mar 2015 18:51:11 +0100
From: "christophe.ricard" <christophe.ricard@gmail.com>
MIME-Version: 1.0
To: Nicolas Iooss <nicolas.iooss_linux@m4x.org>, sameo@linux.intel.com,
	lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org
CC: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NFC: st21nfca: fix st21nfca_get_iso14443_3_uid data copy
References: <54F17F43.7060605@m4x.org> <1425358732-31752-1-git-send-email-nicolas.iooss_linux@m4x.org> <5506CC74.107@m4x.org>
In-Reply-To: <5506CC74.107@m4x.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Nicolas,

Sorry for the late reply.

I am planning to include your patch with a Acked-by in a future patch serie.

Thanks a lot
Best Regards
Christophe

On 16/03/2015 13:28, Nicolas Iooss wrote:
> Hello,
> I have not received any comments about this patch so I'm sending it
> again.  Could you please review it?
>
> Nicolas
>
> On 03/03/2015 12:58 PM, Nicolas Iooss wrote:
>> st21nfca_get_iso14443_3_uid() does not correctly copy the uid from
>> uid_skb->data to its gate parameter.  "gate = uid_skb->data;" only puts
>> a pointer to uid_skb->data to the local variable gate.  This means that
>> in st21nfca_hci_target_from_gate() the content of "u8
>> uid[NFC_NFCID1_MAXSIZE]" local variable is never initialized before
>> being used in memcpy(target->nfcid1, uid, len).
>>
>> Fix this by replacing the local variable assignment with a memcpy.
>>
>> This was found by compiling Linux with "gcc -Wunused-but-set-parameter".
>>
>> Signed-off-by: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
>> ---
>>
>> As I did not get any reply from https://lkml.org/lkml/2015/2/28/25 and
>> got confirmation by other people that this may be a real bug, I am now
>> sending a patch to fix it.
>>
>>   drivers/nfc/st21nfca/st21nfca.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/nfc/st21nfca/st21nfca.c b/drivers/nfc/st21nfca/st21nfca.c
>> index 24d3d240d5f4..ff70d2838b29 100644
>> --- a/drivers/nfc/st21nfca/st21nfca.c
>> +++ b/drivers/nfc/st21nfca/st21nfca.c
>> @@ -588,7 +588,7 @@ static int st21nfca_get_iso14443_3_uid(struct nfc_hci_dev *hdev, u8 *gate,
>>   		goto exit;
>>   	}
>>   
>> -	gate = uid_skb->data;
>> +	memcpy(gate, uid_skb->data, uid_skb->len);
>>   	*len = uid_skb->len;
>>   exit:
>>   	kfree_skb(uid_skb);
>>

