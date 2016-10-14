Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:35041 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751736AbcJNPzF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Oct 2016 11:55:05 -0400
Received: by mail-lf0-f67.google.com with SMTP id x79so18605175lff.2
        for <linux-wireless@vger.kernel.org>; Fri, 14 Oct 2016 08:54:30 -0700 (PDT)
Subject: Re: [RFC 0/5] ath6kl: non WMI data service support
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>
References: <1476376769-4708-1-git-send-email-erik.stromdahl@gmail.com>
 <87k2dbbczu.fsf@kamboji.qca.qualcomm.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Erik Stromdahl <erik.stromdahl@gmail.com>
Message-ID: <ce941451-4d1c-4931-0f26-da52f5334f08@gmail.com> (sfid-20161014_175510_345990_517C6350)
Date: Fri, 14 Oct 2016 17:54:27 +0200
MIME-Version: 1.0
In-Reply-To: <87k2dbbczu.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 10/14/2016 09:34 AM, Valo, Kalle wrote:
> Erik Stromdahl <erik.stromdahl@gmail.com> writes:
> 
>> This patch series is intended to prepare the ath6kl driver
>> for newer chipsets that doesn't use the current WMI data
>> endpoints for data traffic.
>>
>> The chipset I have been working with (and used for testing)
>> is QCA6584. It is SDIO based (at least the variant I have
>> been using) with 802.11p WAVE DSRC capabilities.
>>
>> This chipset is different from the AR600X family in that
>> it does not use the WMI data services (service id's 0x101
>> to 0x104 ) for data traffic.
>> Instead it uses the HTT data service for data and wmi unified
>> for control messages.
>> It is also different when it comes to mailbox addresses
>> and HTC header format as well, but these differences are not
>> part of this patch series.
> 
> Do you have more patches implemented, like something already working or
> have just started?
> 

I have an implementation with all features I need so far, but the other
patches will require cleanup before I can submit anything.

I have been using the qcacld driver as a basis for the work and some of
the stuff in that driver is not really compliant with the kernel coding
style (to say the least).

I have so far mainly been focused on getting all features up and running
and that has (unfortunately) resulted in some copy-pasting from qcacld.

I will start having a look at ath10k and see how much work it would be
to add sdio support to it...
