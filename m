Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.231]:3502 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760260AbYENTJO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 May 2008 15:09:14 -0400
Received: by rv-out-0506.google.com with SMTP id l9so36557rvb.1
        for <linux-wireless@vger.kernel.org>; Wed, 14 May 2008 12:09:13 -0700 (PDT)
Message-ID: <b6c5339f0805141209p4a8b1b2do1cb2ec1c11de07e8@mail.gmail.com> (sfid-20080514_210918_106237_696B3246)
Date: Wed, 14 May 2008 15:09:13 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: "Zack Weinberg" <zackw@panix.com>
Subject: Re: Getting ath5k driver working with Thinkpad T61 [168c:1014]
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <eb97335b0805141145v3436e0e3ld7bd2721cbf0d15f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <eb97335b0805141024w6afa864j860b312b072faa8a@mail.gmail.com>
	 <b6c5339f0805141138o5575095du1f12c62624c80630@mail.gmail.com>
	 <eb97335b0805141145v3436e0e3ld7bd2721cbf0d15f@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 14, 2008 at 2:45 PM, Zack Weinberg <zackw@panix.com> wrote:
> On Wed, May 14, 2008 at 2:38 PM, Bob Copeland <me@bobcopeland.com> wrote:
>> On Wed, May 14, 2008 at 1:24 PM, Zack Weinberg <zackw@panix.com> wrote:
>>> [15498.709195] ACPI: PCI interrupt for device 0000:03:00.0 disabled
>>> [15498.709205] ath5k_pci: probe of 0000:03:00.0 failed with error -5
>>
>> Did you try power-cycling your machine?  Looks like chip is hung.
>
> exactly the same thing happens immediately after cold boot with
> nothing else having touched the chip.

Interesting...  can you confirm that madwifi also will not start from a cold
boot?  I only ask because I had a similar issue with my pci-e card that was
fixed a while ago.  Madwifi would work from a cold boot, though, if ath5k
had never been loaded.

Here's someone else with the same PCI ID, same symptom:

http://kerneltrap.org/mailarchive/linux-ath5k-devel/2007/12/12/496961

Perhaps the best thing to do is add printks to ath5k_hw_nic_wakeup and see
where it hangs?

-- 
Bob Copeland %% www.bobcopeland.com
