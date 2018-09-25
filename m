Return-Path: <SRS0=9L0z=MH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 128E5C43382
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 09:55:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8FC1E20C0A
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 09:55:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="LFDPVYbw"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8FC1E20C0A
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726927AbeIYQCg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 25 Sep 2018 12:02:36 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:46128 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726201AbeIYQCg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Sep 2018 12:02:36 -0400
Received: by mail-ed1-f66.google.com with SMTP id k14-v6so18775126edr.13
        for <linux-wireless@vger.kernel.org>; Tue, 25 Sep 2018 02:55:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=/X6WN0rM9jLzgBwncpo6+HoVyQ1L0F0YZ/dRzU8LjLM=;
        b=LFDPVYbw/aF5XixIvuId+0dKDD9eDN/p9Yd9ToxqRruFpwGWSOWLybsBuoSRN87rjo
         DzrgnCl2tr9+iPbSjbRQoOXEFo7rFqzb8G86098lOEQ+/XBfcC/yissPDjaM15PXL9ak
         7wQC/Y5jhqMPeqP8I0bOfGQTfiQvi5axyb/GI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=/X6WN0rM9jLzgBwncpo6+HoVyQ1L0F0YZ/dRzU8LjLM=;
        b=kmltNBp+l3yE9aQSzpzn+NFDj1NF+D7czXyY3hqeyiiVvYbB/dBrZetqe7MzQdUyV3
         9vWXb63+7fGEvyrvHnkDcDh/xzjvYDhJsiEp2Kxdpdnf9ahT1GSpE//Q1UJpOl9ZoNzN
         jjbfd7eh2GP9maeiIk0qvsC0gKgYi7RN/F1UVEb/IjbOKzLSEhvXaWJEznOdk58zsUjF
         b8iDlOg1KgKw6sT0mwC7M58CqhX6Y9Lf53CrywBfuH5dqEzW8ML7alZb+m8ZJe78WmHn
         9ciVGQFUjvXCt4r5KTDwofqYPqLWvdQf7uYwy+DBoS+Q24A73+pv3go8iOANIH1mIXbw
         HpAw==
X-Gm-Message-State: ABuFfohtBzH6/vrT6jmds2iiZR5KU1hMAI+/+Yx7AC397v7dZObxLKWB
        RRm+svnUt725y1xOf7Tx3WKe6Q==
X-Google-Smtp-Source: ACcGV61Faqkv8P6NZL0H4ePGTBWAzHWRhLKHWC/iGN7Lw9nJ71/oH+OJpNq2l1uswost7hrlR/Pi6Q==
X-Received: by 2002:a50:e40d:: with SMTP id d13-v6mr1496500edm.263.1537869350056;
        Tue, 25 Sep 2018 02:55:50 -0700 (PDT)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id h19-v6sm122976edq.23.2018.09.25.02.55.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Sep 2018 02:55:49 -0700 (PDT)
Subject: Re: [PATCH] mt76x0: add quirk to disable 2.4GHz band for Archer T1U
To:     Stanislaw Gruszka <sgruszka@redhat.com>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
References: <1537858188-7815-1-git-send-email-sgruszka@redhat.com>
 <20180925075445.GA3872@localhost.localdomain>
 <f3c1e576-4756-7a3e-4bfe-3abaf3e1107d@nbd.name>
 <20180925090746.GC3872@localhost.localdomain>
 <20180925094837.GD2029@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org,
        Sid Hayn <sidhayn@gmail.com>
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <8bcdd4fc-4dc6-f098-073e-83feb09a117f@broadcom.com>
Date:   Tue, 25 Sep 2018 11:55:48 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <20180925094837.GD2029@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 9/25/2018 11:48 AM, Stanislaw Gruszka wrote:
> On Tue, Sep 25, 2018 at 11:07:47AM +0200, Lorenzo Bianconi wrote:
>> On Sep 25, Felix Fietkau wrote:
>>> On 2018-09-25 09:54, Lorenzo Bianconi wrote:
>>>>>
>>>>> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
>>>>> index 76d607f73758..b7a1069ecd0e 100644
>>>>> --- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
>>>>> +++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
>>>>> @@ -45,7 +45,8 @@
>>>>>  	{ USB_DEVICE(0x20f4, 0x806b) },	/* TRENDnet TEW-806UBH  */
>>>>>  	{ USB_DEVICE(0x7392, 0xc711) }, /* Devolo Wifi ac Stick */
>>>>>  	{ USB_DEVICE(0x0df6, 0x0079) }, /* Sitecom Europe B.V. ac  Stick */
>>>>> -	{ USB_DEVICE(0x2357, 0x0105) }, /* TP-LINK Archer T1U */
>>>>> +	{ USB_DEVICE(0x2357, 0x0105),
>>>>> +	  .driver_info = 1,	     }, /* TP-LINK Archer T1U */
>>>>
>>>> Hi Stanislaw,
>>>>
>>>> what about using 'ieee80211-freq-limit' OF property to limit available wireless
>>>> band? In this way we can take into account even the opposite case (no 5GHz).
>>> That doesn't make sense for USB devices, which can be plugged into any
>>> machine.
>>
>> Ack, right.
>> What about a more general solution like adding an enum { NO_5GHz = 1, NO_2GHz }?
>> Does it worth to implement it now?
>
> I do not see reason for that. Basically band information should be
> read from EEPROM, I do not expect need for more quirks like this.

Well. Never say never :-p And the phrase "quirks like this" does seem to 
leave the door open for other quirks. Or did you mean "quirks using 
driver_info"?

Regards,
Arend

