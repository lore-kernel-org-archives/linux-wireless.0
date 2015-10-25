Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:36431 "EHLO
	mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785AbbJYT7n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Oct 2015 15:59:43 -0400
MIME-Version: 1.0
In-Reply-To: <CABXAfNKL_Z0T7k-1ONkQbXdK6SX6A9ou+2uMMsKGObackaqsdA@mail.gmail.com>
References: <1445725885-25995-1-git-send-email-punitvara@gmail.com>
	<1445725885-25995-2-git-send-email-punitvara@gmail.com>
	<20151025191249.GB23928@kroah.com>
	<CABXAfNKL_Z0T7k-1ONkQbXdK6SX6A9ou+2uMMsKGObackaqsdA@mail.gmail.com>
Date: Mon, 26 Oct 2015 01:29:42 +0530
Message-ID: <CABXAfN+feLnS2nNDQPhwchmX=oqtCFUPr27StPsTG-w3JSzgHw@mail.gmail.com> (sfid-20151025_210000_593182_C35F2774)
Subject: Re: [PATCH 1/3] staging: wilc1000: Remove reference preceded by free
From: punit vara <punitvara@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 26, 2015 at 1:01 AM, punit vara <punitvara@gmail.com> wrote:
> On Mon, Oct 26, 2015 at 12:42 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
>> On Sun, Oct 25, 2015 at 04:01:23AM +0530, Punit Vara wrote:
>>> This patch is to the wilc_wfi_cfgoperations.c file that fixes up
>>> following error reported by coccicheck:
>>>
>>> ERROR: reference preceded by free on line 1219
>>>
>>> For (params->seq_len) <= 0 memory is already freed when
>>> (params->seq_len) >0 then memory was alloted. So there is no need to use
>>> kfree whenever params->seq_len <=0 remove it and place kfree inside
>>> (params->seq_len) >0 condition.
>>>
>>> Signed-off-by: Punit Vara <punitvara@gmail.com>
>>> ---
>>>  drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 7 +++----
>>>  1 file changed, 3 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
>>> index bcbf1bd..9b3cf04 100644
>>> --- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
>>> +++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
>>> @@ -1216,11 +1216,10 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
>>>
>>>                               priv->wilc_ptk[key_index]->key = kmalloc(params->key_len, GFP_KERNEL);
>>>
>>> -                             kfree(priv->wilc_ptk[key_index]->seq);
>>> -
>>> -                             if ((params->seq_len) > 0)
>>> +                             if ((params->seq_len) > 0) {
>>> +                                     kfree(priv->wilc_ptk[key_index]->seq);
>>>                                       priv->wilc_ptk[key_index]->seq = kmalloc(params->seq_len, GFP_KERNEL);
>>> -
>>> +                             }
>>
>> Are you sure about this?  It seems like you are changing the logic
>> here...
>>
> Yes this time I am quite confident here . On This file line no 1177
> already freed the allocation of memory ..On the following line if
> (params->seq_len) > 0 then memory is allotted but if it is not then
> memory allocation remains free only. So here kfree is not required
> outside of the if condition. It should be inside the if condition
> because for   (params->seq_len) > 0 memory is already allotted at line
> followed by 1177. Kindly look at it once.
>
> Thanks :-)
Again I went back thinking Greg who is stable kernel maintainer who
doubts about logic .So I again go through these code , you are right .
What you ignore this change and apply this patch ?
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 9b3cf04..3ab7d3e 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1174,9 +1174,9 @@ static int add_key(struct wiphy *wiphy, struct
net_device *netdev, u8 key_index,
                                memcpy(priv->wilc_gtk[key_index]->key,
params->key, params->key_len);

                                /* if there has been previous
allocation for the same index through its seq, free that memory and
allocate again*/
-                               kfree(priv->wilc_gtk[key_index]->seq);

                                if ((params->seq_len) > 0) {
+                                       kfree(priv->wilc_gtk[key_index]->seq);
                                        priv->wilc_gtk[key_index]->seq
= kmalloc(params->seq_len, GFP_KERNEL);

memcpy(priv->wilc_gtk[key_index]->seq, params->seq, params->seq_len);
                                }


?? May send this patch ? I think it will not change the logic .
Comment me if I am wrong
