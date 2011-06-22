Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53820 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756726Ab1FVQtj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jun 2011 12:49:39 -0400
Received: by iwn6 with SMTP id 6so844306iwn.19
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jun 2011 09:49:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1308728084.3883.9.camel@jlt3.sipsolutions.net>
References: <1308592212-5755-1-git-send-email-aloisio.almeida@openbossa.org>
 <1308592212-5755-4-git-send-email-aloisio.almeida@openbossa.org> <1308728084.3883.9.camel@jlt3.sipsolutions.net>
From: Aloisio Almeida <aloisio.almeida@openbossa.org>
Date: Wed, 22 Jun 2011 13:49:18 -0300
Message-ID: <BANLkTinBNRGJomeif=DHB0Q93__u+=PTUA@mail.gmail.com> (sfid-20110622_184944_894859_757E9A4D)
Subject: Re: [RFC][PATCH v2 3/7] NFC: add nfc generic netlink interface
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	sameo@linux.intel.com, lauro.venancio@openbossa.org,
	marcio.macedo@openbossa.org, Waldemar.Rymarkiewicz@tieto.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On Wed, Jun 22, 2011 at 4:34 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
>> + * @NFC_ATTR_TARGET_SENS_RES: extra information for NFC-A targets
>> + * @NFC_ATTR_TARGET_SEL_RES: extra information for NFC-A targets
>
> Those descriptions aren't very useful to me, but hopefully if I knew
> anything about NFC I'd understand :)

Yes. But I can change a little bit:

@NFC_ATTR_TARGET_SENS_RES: NFC-A targets extra information such as NFCID
@NFC_ATTR_TARGET_SEL_RES: NFC-A targets extra information (useful if
the target is not NFC-Forum compliant)

>> +     dev->targets_generation++;
>> +
>> +     kfree(dev->targets);
>> +     dev->targets = kzalloc(n_targets * sizeof(struct nfc_target),
>> +                                                     GFP_ATOMIC);
>> +     if (!dev->targets) {
>> +             dev->n_targets = 0;
>> +             spin_unlock_bh(&dev->targets_lock);
>> +             return -ENOMEM;
>> +     }
>> +
>> +     memcpy(dev->targets, targets, n_targets * sizeof(struct nfc_target));
>> +     dev->n_targets = n_targets;
>
> If you really want to keep the array thing at least you should use
> kmemdup(). I'd argue that the overhead won't be huge even if you don't,
> since as you said yourself you don't expect tons of targets (and if you
> do have tons of targets, this approach breaks down anyway).

Ok, I will change kmalloc()/memcpy() by kmemdup().

>> @@ -298,7 +353,10 @@ int nfc_register_device(struct nfc_dev *dev)
>>       rc = device_add(&dev->dev);
>>       mutex_unlock(&nfc_devlist_mutex);
>>
>> -     return rc;
>> +     if (rc < 0)
>> +             return rc;
>> +
>> +     return nfc_genl_device_added(dev);
>
> No rollback if nfc_genl_device_added() fails? Either you need to ignore
> the error or roll back I think.
>
>> +int nfc_genl_device_added(struct nfc_dev *dev)
>> +{
>> +     struct sk_buff *msg;
>> +     void *hdr;
>> +
>> +     pr_debug("%s\n", __func__);
>> +
>> +     msg = nlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
>> +     if (!msg)
>> +             return -ENOMEM;
>
> I'd probably ignore the errors since any error just means userspace
> wasn't notified, but it can still later look up the devices.

Yes, you're right. I'll fix that.

Aloisio
