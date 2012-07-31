Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:50531 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab2GaHRv (ORCPT
	<rfc822;groupwise-linux-wireless@vger.kernel.org:0:0>);
	Tue, 31 Jul 2012 03:17:51 -0400
Received: by vbbff1 with SMTP id ff1so5457990vbb.19
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jul 2012 00:17:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120730114515.GA3722@redhat.com>
References: <1343645143-10602-1-git-send-email-machen@suse.com>
	<20120730114515.GA3722@redhat.com>
Date: Tue, 31 Jul 2012 15:17:41 +0800
Message-ID: <CALx5=V92rTav6rckZ7Q0XocOhnc6STjnFggmyojspCtmuePOeA@mail.gmail.com> (sfid-20120731_091824_394347_254D0BA4)
Subject: Re: [rt2x00-users] [PATCH v2] rt2x00 : fix rt3290 resuming failed.
From: Matt Chen <machen@suse.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: users@rt2x00.serialmonkey.com, kevin.chou@mediatek.com,
	woody.hung@mediatek.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

2012/7/30 Stanislaw Gruszka <sgruszka@redhat.com>:
>> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
>> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
>> @@ -400,6 +400,14 @@ int rt2800_load_firmware(struct rt2x00_dev *rt2x00dev,
>>  {
>>       unsigned int i;
>>       u32 reg;
>> +
>> +     int retval;
>> +
>> +     if (rt2x00_rt(rt2x00dev, RT3290)) {
>> +             retval = rt2800_enable_wlan_rt3290(rt2x00dev);
>> +             if (retval)
>> +                     return -EBUSY;
>> +     }
>
> Since we call that here, why we need this also in rt2800pci_probe_hw() ?
hmm....this is worth testing. I will remove it from
rt2800pci_probe_hw(), see if it is working fine.
> Stanislaw
>



-- 
Thank you.
