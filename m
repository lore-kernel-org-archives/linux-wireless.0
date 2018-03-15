Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:54742 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750745AbeCOH3y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Mar 2018 03:29:54 -0400
Received: by mail-wm0-f41.google.com with SMTP id h76so8501746wme.4
        for <linux-wireless@vger.kernel.org>; Thu, 15 Mar 2018 00:29:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <878taw0zjd.fsf@purkki.adurom.net>
References: <1520260620-4694-1-git-send-email-amitkarwar@gmail.com>
 <1520260620-4694-6-git-send-email-amitkarwar@gmail.com> <878taw0zjd.fsf@purkki.adurom.net>
From: Amitkumar Karwar <amitkarwar@gmail.com>
Date: Thu, 15 Mar 2018 12:59:53 +0530
Message-ID: <CAEhWJFm9rq0+hm3_JnC=nmCSoSPi6_k=Xx0RAtuVnp-H6ibs9g@mail.gmail.com> (sfid-20180315_083009_593175_B97BE971)
Subject: Re: [PATCH 05/10] rsi: roaming enhancements
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 13, 2018 at 8:54 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
> Amitkumar Karwar <amitkarwar@gmail.com> writes:
>
>> From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
>>
>> To support roaming below changes are done:
>> * Station notify frame is send to firmware after sending assoc
>>   request. This will avoid dropping of first EAPOL frame due to
>>   delay in creation of station control block in firmware.
>> * Data queues are unblocked after sending station notify in open
>>   mode, after configuring key in WEP mode, and after receiving
>>   EAPOL4 confirm in WPA mode.
>> * Initial EAPOL frames priority is chaged to MGMT, rekey EAPOL
>>   frames priority changed to VO.
>> * Data frames with wrong BSSID are dropped.
>
> I don't know what Johannes thinks but IMHO the driver should not drop
> any data frames, it should just submit what mac80211 gives to it. All
> filtering should happen in mac80211 (or controlled by it).

This was just an extra check to ensure that when we roam from one AP
to another, we should drop frames for previous AP. We don't have any
evidence that such are received.
I will remove this change in next version.

Regards,
Amitkumar Karwar
