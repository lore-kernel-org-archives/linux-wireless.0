Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55063 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411Ab1FVOHk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jun 2011 10:07:40 -0400
Received: by iyb12 with SMTP id 12so691524iyb.19
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jun 2011 07:07:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110621220510.GG2628@joana>
References: <1308592212-5755-1-git-send-email-aloisio.almeida@openbossa.org>
 <1308592212-5755-4-git-send-email-aloisio.almeida@openbossa.org> <20110621220510.GG2628@joana>
From: Aloisio Almeida <aloisio.almeida@openbossa.org>
Date: Wed, 22 Jun 2011 11:07:20 -0300
Message-ID: <BANLkTimo9r8jyMn76V9+9+AqrYekRkF8Xw@mail.gmail.com> (sfid-20110622_160744_903836_3019E55D)
Subject: Re: [RFC][PATCH v2 3/7] NFC: add nfc generic netlink interface
To: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	sameo@linux.intel.com, johannes@sipsolutions.net,
	lauro.venancio@openbossa.org, marcio.macedo@openbossa.org,
	Waldemar.Rymarkiewicz@tieto.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Gustavo,

On Tue, Jun 21, 2011 at 7:05 PM, Gustavo F. Padovan
<padovan@profusion.mobi> wrote:
>>  static int __init nfc_init(void)
>>  {
>> +     int rc;
>> +
>>       printk(KERN_INFO "NFC Core ver %s\n", VERSION);
>>
>> -     return class_register(&nfc_class);
>> +     rc = class_register(&nfc_class);
>> +     if (rc)
>> +             goto err;
>
> Just return rc here and get rid of the label.
>
ok

>> +/**
>> + * nfc_genl_exit() - Deinitialize netlink interface
>> + *
>> + * This exit function unregisters the nfc netlink family.
>> + */
>> +void nfc_genl_exit(void)
>
> You may want __exit here.

The nfc_genl_exit() is called in  '__init nfc_init(void)' if any error
occurs. In that case we will have an __exit code inside an __init
code, resulting in a section mismatch.

Aloisio
