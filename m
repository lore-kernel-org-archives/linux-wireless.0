Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ed1-f46.google.com ([209.85.208.46]:32791 "EHLO
        mail-ed1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728067AbeHDVVN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 4 Aug 2018 17:21:13 -0400
Received: by mail-ed1-f46.google.com with SMTP id x5-v6so3332635edr.0
        for <linux-wireless@vger.kernel.org>; Sat, 04 Aug 2018 12:19:33 -0700 (PDT)
Subject: Re: iw scanning broken?
To: Dan Kosek <daniel.kosek@gmail.com>, linux-wireless@vger.kernel.org
References: <C17ECAF6-E13C-40DB-A582-C9945D9BE7D7@gmail.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5B65FC42.3010604@broadcom.com> (sfid-20180804_212003_881838_71B1595A)
Date: Sat, 4 Aug 2018 21:19:30 +0200
MIME-Version: 1.0
In-Reply-To: <C17ECAF6-E13C-40DB-A582-C9945D9BE7D7@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8/4/2018 3:08 PM, Dan Kosek wrote:
> If you enter the following command, you should get a single channel scan:
>
> sudo iw wlan0 scan freq 2412
>
> You do not.  Instead you get a full (all) channels scan, which takes 3-5 seconds.

Do you have any logs to support that claim. Please note that the command 
returns all BSS-es that are listed in wireless subsystem, ie. in 
cfg80211. That includes BSS-es found in previous scans unless their 
lifetime expired. What happens if you do...

$ sudo iw wlan0 scan freq 2412 flush

> This has been tested on Raspberry Pi Raspian 9 and Peppermint OS 7 ( Linux 4.4.0-53-generic #74-Ubuntu) with the same results.
>
> i believe iw is broken or some command knowledge is missing.

So what drivers are involved. Please include kernel logs.

Regards,
Arend
