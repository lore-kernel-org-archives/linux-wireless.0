Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.181]:48743 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757271AbYEJAM3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 May 2008 20:12:29 -0400
Received: by wa-out-1112.google.com with SMTP id j37so2056601waf.23
        for <linux-wireless@vger.kernel.org>; Fri, 09 May 2008 17:12:29 -0700 (PDT)
Message-ID: <1ba2fa240805091712gccaec9cibdab621e8d1c9ba7@mail.gmail.com> (sfid-20080510_021233_543239_7828ACA2)
Date: Sat, 10 May 2008 03:12:29 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Vincent C Jones" <v.jones@networkingunlimited.com>
Subject: Re: iwl4965 - wpa_supplicant can't see 5Ghz frequencies - 2.6.26-rc1 kernel
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1210376474.3856.7.camel@X61.NetworkingUnlimited.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1210352234.3763.23.camel@X61.NetworkingUnlimited.com>
	 <1ba2fa240805091423y680b6706ta124eaaed73c81c0@mail.gmail.com>
	 <1210376474.3856.7.camel@X61.NetworkingUnlimited.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 10, 2008 at 2:41 AM, Vincent C Jones
<v.jones@networkingunlimited.com> wrote:
>
> On Sat, 2008-05-10 at 00:23 +0300, Tomas Winkler wrote:
>> On Fri, May 9, 2008 at 7:57 PM, Vincent C Jones
>> <v.jones@networkingunlimited.com> wrote:
>> > The channel/frequency reporting by iwlwifi is incompatible with
>> >  wpa_supplicant for 5GHz (802.11A) channels. Version numbers and iwlist
>> >  versus wpa_supplicant scan results are below. Association still works if
>> >  the correct channel is specified using iwconfig, but that is
>> >  incompatible with roaming.
>>
>> Fixed by the patch ' iwlwifi: Fix frequency in rx_status fill'
>>
>> Thanks
>> Tomas
>
> This patch did not apply cleanly to plain 2.6.26-rc1: off by -4 lines in
> iwl-3945.c and by 1078 lines in iwl-4965.c. More important, it did not
> fix the problem of wpa_supplicant thinking the 802.11A access points are
> on channel 0. Same results with 2.6.26-rc1-git7, with & without patch.
> Any idea when this patch (and the patches it appears to depend on) will
> make it into the 2.6.26 release?
>

This patch is against wireless-testing.git, it's just too lines and
doesn't really have logical dependencies on other patches so I didn't
create a separate patch for 2.6.26...It looks maybe I should.
Can you  try to eproduce your problem on wireless-testing kernel with
this patch?
Also some logs will be useful

Thanks
Tomas



> Vince
>
