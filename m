Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:47130 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751227Ab1LKJwN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Dec 2011 04:52:13 -0500
Message-ID: <4EE47D45.4060609@openwrt.org> (sfid-20111211_105223_031138_2DF88FD0)
Date: Sun, 11 Dec 2011 10:52:05 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Julian Calaby <julian.calaby@gmail.com>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mcgrof@qca.qualcomm.com
Subject: Re: [PATCH] ath9k_hw: make bluetooth coexistence support optional
 at compile time
References: <1323550849-16651-1-git-send-email-nbd@openwrt.org> <CAGRGNgWVG9gEfwRTcF7V-jzfwVQ3RSoYMHmTSp-SKpsbWo7k6w@mail.gmail.com>
In-Reply-To: <CAGRGNgWVG9gEfwRTcF7V-jzfwVQ3RSoYMHmTSp-SKpsbWo7k6w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-12-11 5:20 AM, Julian Calaby wrote:
> Felix,
> 
> On Sun, Dec 11, 2011 at 08:00, Felix Fietkau <nbd@openwrt.org> wrote:
>> Many systems (e.g. embedded systems) do not have wifi modules connected to
>> bluetooth modules, so bluetooth coexistence is irrelevant there. With the
>> addition of MCI support, ath9k picked up quite a bit of extra code that
>> can be compiled out this way.
>>
>> This patch redefines ATH9K_HW_CAP_MCI and adds an inline wrapper for
>> querying the bluetooth coexistence scheme, allowing the compiler to
>> eliminate code that uses it, with only very little use of #ifdef.
>>
>> On MIPS this reduces the total size for the modules by about 20k.
>>
>> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
>> ---
>>
>> diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.c b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
>> index 8599822..4905af9 100644
>> --- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
>> +++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
>> @@ -85,6 +85,9 @@ void ar9003_mci_remote_reset(struct ath_hw *ah, bool wait_done)
>>  {
>>        u32 payload[4] = { 0xffffffff, 0xffffffff, 0xffffffff, 0xffffff00};
>>
>> +       if (!ATH9K_HW_CAP_MCI)
>> +               return;
>> +
> 
> IMHO, the checks for ATH9K_HW_CAP_MCI don't make it obvious that
> they're checking whether coexistence is enabled, and are more about
> whether *part* of it is enabled - which could cause confusion if
> another scheme is ever added, or it gets a not-insignificant re-write.
> Surely it wouldn't be too bad to do some #defining around this code
> and in the headers etc. so that the coexistence only functions aren't
> even looked at by the compiler if isn't enabled? IMHO putting the
> btcoex code in #ifdef blocks is better documentation as it's saying
> "these are the btcoex functions, and they're only used if this config
> variable is enabled" not "this random function can be skipped if some
> hardware feature is disabled".
If another different scheme is added, it will be in a separate source
file. I intentionally wanted to avoid compiling out this code using
#ifdef directly, because I want the compiler to check the code for
compile errors, even when it is disabled.

- Felix
