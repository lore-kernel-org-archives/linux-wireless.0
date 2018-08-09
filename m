Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ed1-f68.google.com ([209.85.208.68]:37442 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728175AbeHIL4q (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Aug 2018 07:56:46 -0400
Received: by mail-ed1-f68.google.com with SMTP id b10-v6so2564163eds.4
        for <linux-wireless@vger.kernel.org>; Thu, 09 Aug 2018 02:32:45 -0700 (PDT)
Subject: Re: [PATCH v2 0/2] Change sk_pacing_shift in ieee80211_hw for best tx
 throughput
To: Peter Oh <peter.oh@bowerswilkins.com>,
        Wen Gong <wgong@codeaurora.org>, ath10k@lists.infradead.org,
        johannes@sipsolutions.net
References: <1533724802-30944-1-git-send-email-wgong@codeaurora.org>
 <4dbcc269-1f2b-b165-fe9e-8704fd77d1c5@bowerswilkins.com>
Cc: linux-wireless@vger.kernel.org
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5B6C0A3C.3020908@broadcom.com> (sfid-20180809_113259_851894_3DD7AFD3)
Date: Thu, 9 Aug 2018 11:32:44 +0200
MIME-Version: 1.0
In-Reply-To: <4dbcc269-1f2b-b165-fe9e-8704fd77d1c5@bowerswilkins.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8/8/2018 9:00 PM, Peter Oh wrote:
>
>
> On 08/08/2018 03:40 AM, Wen Gong wrote:
>> Add a field for ath10k to adjust the sk_pacing_shift, mac80211 set
>> the default value to 8, and ath10k will change it to 6. Then mac80211
>> will use the changed value 6 as sk_pacing_shift since 6 is the best
>> value for tx throughput by test result.
> I don't think you can convince people with the numbers unless you
> provide latency along with the numbers and also measurement result on
> different chipsets as Michal addressed (QCA4019, QCA9984, etc.) From
> users view point, I also agree on Toke that we cannot scarify latency
> for the small throughput improvement.

Yeah. The wireless industry (admittedly that is me too :-p ) has been 
focused on just throughput long enough. All the preaching about 
bufferbloat from Dave and others is (just) starting to sink in here and 
there.

Now as for the value of the sk_pacing_shift I think we agree it depends 
on the specific device so in that sense the api makes sense, but I think 
there are a lot of variables so I was wondering if we could introduce a 
sysctl parameter for it. Does that make sense?

Regards,
Arend
