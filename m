Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:58168 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476Ab1EWVnN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 May 2011 17:43:13 -0400
Received: by iwn34 with SMTP id 34so5178865iwn.19
        for <linux-wireless@vger.kernel.org>; Mon, 23 May 2011 14:43:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DDAD3D5.1070001@candelatech.com>
References: <4DD6E9B5.3020905@candelatech.com> <BANLkTindTMFNNpyNpNndhhGv7qWB5_haGQ@mail.gmail.com>
 <4DDA913B.1060002@candelatech.com> <4DDAA9ED.1050606@candelatech.com>
 <4DDAACF3.3050705@candelatech.com> <BANLkTimizNePq-GFsOYxNtfDNLc8kqjJFw@mail.gmail.com>
 <4DDABEE9.9090608@candelatech.com> <BANLkTineDDcWvmr8M5hp-=b0LDRamZyovQ@mail.gmail.com>
 <4DDAC8DC.5060803@candelatech.com> <BANLkTimSUvfSzAHXQJppZ=7T2TKMuP37fQ@mail.gmail.com>
 <4DDACF56.9070403@candelatech.com> <BANLkTikSb-6Uh5jnEUD4wrGCKUNmrF3Zow@mail.gmail.com>
 <4DDAD3D5.1070001@candelatech.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 23 May 2011 14:42:53 -0700
Message-ID: <BANLkTinrM1oBfKUoCzs9_DOw+EmpW=ikig@mail.gmail.com> (sfid-20110523_234320_006853_A00D03B3)
Subject: Re: ath9k 9380: All 5Ghz channels flagged as passive-scanning
To: Ben Greear <greearb@candelatech.com>
Cc: Mohammed Shafi <shafi.wireless@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 23, 2011 at 2:38 PM, Ben Greear <greearb@candelatech.com> wrote:
> On 05/23/2011 02:28 PM, Luis R. Rodriguez wrote:
>>
>> On Mon, May 23, 2011 at 2:19 PM, Ben Greear<greearb@candelatech.com>
>>  wrote:
>
>>> Since it *is* possible to start an AP on a channel with existing AP,
>>> I assume that the NIC must be able to handle this properly..or is
>>> that ability to start on a scanned channel just a bug?  (Please
>>> don't fix it, if it is :P)
>>
>> It a feature, AP functionality is allowed on that channel on a world
>> roaming card given that no CTL is present so the lower regulatory
>> value, from CRDA, is used instead of the CTL value.
>
> So as long as you have a functional CRDA and do not mis-represent
> your country with 'iw reg set',

Atheros cards have an EEPROM value for a regulatory domain which is
always used, regardless of what you tell cfg80211 with 'iw reg set',
'iw reg set' will just help compliance further.

> is there any way to
> actually get the system out of spec if you use "eeprom" reg-domain of 0x0?

No. You can only do this by trying to take the card out of compliance
purposely or unknowingly in software.

 Luis
