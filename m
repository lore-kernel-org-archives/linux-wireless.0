Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f173.google.com ([209.85.128.173]:36607 "EHLO
        mail-wr0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1173927AbdDXS7F (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Apr 2017 14:59:05 -0400
Received: by mail-wr0-f173.google.com with SMTP id l50so23068299wrc.3
        for <linux-wireless@vger.kernel.org>; Mon, 24 Apr 2017 11:59:05 -0700 (PDT)
Subject: Re: [PATCH v2] brcmfmac: Make skb header writable before use
To: Eric Dumazet <eric.dumazet@gmail.com>,
        James Hughes <james.hughes@raspberrypi.org>
References: <20170424130322.476-1-james.hughes@raspberrypi.org>
 <1493057382.6453.39.camel@edumazet-glaptop3.roam.corp.google.com>
Cc: Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, netdev@vger.kernel.org
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <254f7f48-e592-e30a-06db-605a37750e42@broadcom.com> (sfid-20170424_205928_927513_F1F171E9)
Date: Mon, 24 Apr 2017 20:59:02 +0200
MIME-Version: 1.0
In-Reply-To: <1493057382.6453.39.camel@edumazet-glaptop3.roam.corp.google.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 24-4-2017 20:09, Eric Dumazet wrote:
> On Mon, 2017-04-24 at 14:03 +0100, James Hughes wrote:
>> The driver was making changes to the skb_header without
>> ensuring it was writable (i.e. uncloned).
>> This patch also removes some boiler plate header size
>> checking/adjustment code as that is also handled by the
>> skb_cow_header function used to make header writable.
>>
>> This patch depends on
>> brcmfmac: Ensure pointer correctly set if skb data location changes
>>
>> Signed-off-by: James Hughes <james.hughes@raspberrypi.org>
>> ---
>> Changes in v2
>>   Makes the _cow_ call at the entry point of the skb in to the
>>   stack, means only needs to be done once, and error handling
>>   is easier.
>>   Split a separate minor bug fix off to a separate patch (which
>>   this patch depends on)
> 
> Best way to handle dependencies is to send a patch series.
> 
> 1/2 brcmfmac: Ensure pointer correctly set if skb data location changes
> 2/2 brcmfmac: Make skb header writable before use

There is actually no real dependency. Both are valid fixes of course but
either one applies to wireless-drivers-next/master on its own.

Regards,
Arend
