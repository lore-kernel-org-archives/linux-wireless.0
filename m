Return-Path: <SRS0=RZRw=QM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83D69C282CB
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Feb 2019 09:37:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B96420844
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Feb 2019 09:37:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1280-bit key) header.d=sw1v.org header.i=@sw1v.org header.b="lMGdF+1k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728334AbfBEJhF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 5 Feb 2019 04:37:05 -0500
Received: from faith.sw1v.org ([109.74.200.146]:33190 "EHLO faith.sw1v.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725898AbfBEJhF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Feb 2019 04:37:05 -0500
X-Greylist: delayed 342 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Feb 2019 04:37:04 EST
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sw1v.org;
         s=sw1v_02; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version
        :Date:Message-ID:From:References:Cc:To:Subject;
        bh=0/lVgst+lyWdF9xrRxNKNt70dhCVq/lVsFdroAJbC/A=; b=lMGdF+1kAyEXUNW+TQ70G5NteN
        x7exCNIPyFSXMKLG5UAhAdj3NUjsjVHobHjUcrNtK2WYjm5wqW6xyLk3NsSyFzgPgA+IYFJWk+CPo
        IEBMqDuNdyFeAwZAosiy7hS/Ma+Nf2LMTjh4JaNo1LmZsqni/aMQxGT3LbReHjIQwj/EgqwPLuX1+
        qnqUH6al8snO3Kykw/S2bXAgHazD0aFQrQ==;
Received: from [2001:8b0:ba7a:e98f:790b:795:fb14:47c5]
        by faith.sw1v.org (envelope-from <richard@sw1v.org>)
        with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        id 1gqx4b-0005qK-TU; Tue, 05 Feb 2019 09:31:21 +0000
Subject: Re: brcmfmac regression in 4.19 ?
To:     Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>
References: <08b120bb-484f-4c08-30ae-bb023f484a56@redhat.com>
 <CAF7Mx6qrbZr-hVFKPH3kMzTczBWTZmPqZbviKmMCb_uo6O+s+w@mail.gmail.com>
 <d21a57e6-3cf3-efb4-6fe3-3448a1b89b5c@broadcom.com>
From:   Richard van der Hoff <richard@sw1v.org>
Message-ID: <4dea14ba-12f4-b787-63af-221be5ac91b6@sw1v.org>
Date:   Tue, 5 Feb 2019 09:31:21 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <d21a57e6-3cf3-efb4-6fe3-3448a1b89b5c@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-SMTP-SW1V-Spam-User: 
X-SMTP-SW1V-Spam-Level: 
X-SMTP-SW1V-Spam-Bar: 
X-SMTP-SW1V-Spam-Report: 
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


On 12/01/2019 13:29, Arend Van Spriel wrote:
> On 1/11/2019 4:34 PM, Arend Van Spriel wrote:
>> - list (HTML filtering)
>>
>> Op vr 11 jan. 2019 16:18 schreef Hans de Goede <hdegoede@redhat.com 
>> <mailto:hdegoede@redhat.com>:
>>
>>     Hi,
>>
>>     We (Fedora) have been getting bugreports that brcmfmac wifi drops
>>     out and needs a rmmod + modprobe
>>     to restore functionality starting with kernel 4.19:
>>
>>     https://bugzilla.redhat.com/show_bug.cgi?id=1658178
>>
>>
>> Will look into this. Maybe it is similar to what Russell King reported.
> 
> Probably not. The bug report above is with PCIe device. The dmesg 
> attached to the bug report shows user is doing system suspend/resume 
> over and over until the following occurs:
> 
> [28151.874963] brcmfmac: brcmf_psm_watchdog_notify: PSM's watchdog has 
> fired!
> [29354.351337] brcmfmac: brcmf_psm_watchdog_notify: PSM's watchdog has 
> fired!
> 
> PSM is the hardware block which processes the 802.11 packets received 
> from firmware and passes them to the phy layer. When this watchdog barks 
> the firmware will end up in a trap. We do collect a devcoredump upon the 
> watchdog, but unfortunately that will not tell much about the failure in 
> the hardware block. On monday I will try to come up with a patch to 
> obtain more information from the device regarding this watchdog.

Arend, did you manage to look any further into this? I've also noticed 
problems with brcmfmac dropping out since 4.19, though haven't seen any 
notices about PSM: https://bugzilla.kernel.org/show_bug.cgi?id=201853.
