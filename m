Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:50489 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752751AbeBSPBa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Feb 2018 10:01:30 -0500
Received: by mail-wm0-f65.google.com with SMTP id k87so15741870wmi.0
        for <linux-wireless@vger.kernel.org>; Mon, 19 Feb 2018 07:01:30 -0800 (PST)
From: cantabile <cantabile.desu@gmail.com>
Subject: Re: [PATCH] mt7601u: Fix system freeze after resuming from
 hibernation
To: Jakub Kicinski <kubakici@wp.pl>
Cc: mcgrof@kernel.org, linux-wireless@vger.kernel.org
References: <d9ca2742-7f85-afe3-2de6-6637eb56d9b3@gmail.com>
 <20180214164549.72ee26c3@cakuba.netronome.com>
 <f542e9c6-5106-c79c-6e38-7a2f50e6be2d@gmail.com>
 <20180215134738.722654a9@cakuba.netronome.com>
 <7cebda93-4b7a-e8b3-271f-0144c5e94248@gmail.com>
 <20180218215520.65c1e9fd@cakuba.netronome.com>
Message-ID: <6783d9b9-3523-761f-a8b4-b87732006b3c@gmail.com> (sfid-20180219_160134_768454_AC290EB1)
Date: Mon, 19 Feb 2018 17:01:27 +0200
MIME-Version: 1.0
In-Reply-To: <20180218215520.65c1e9fd@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 19/02/18 07:55, Jakub Kicinski wrote:
> On Sat, 17 Feb 2018 13:23:29 +0200, cantabile wrote:
>>> Thanks for the info.  Would it be cleaner to EXPORT fw_add_devm_name()
>>> and just call that in case driver sees FW is already loaded?  That
>>> should inform the fw subsystem that we want the image around in case of
>>> hibernation, but there is no need to load it immediately?
>>
>> No, I don't believe it's cleaner to expose a private function that you
>> don't even really need. Remember that calling request_firmware every
>> time your driver's probe and resume functions are called is normal. It's
>> the expected behaviour.
> 
> I'm asking you the extend functionality of a subsystem to be able to
> cleanly communicate the intent.  Not export internal functions.
> 
> Requesting firmware you don't need and risking failing probe even if FW
> is already pre-loaded is not correct.  Reordering you suggest is
> brittle and makes little logical sense unless someone guesses your use
> case.
> 
> Please at least try to do as advised.  Otherwise:
> 
> Nacked-by: Jakub Kicinski <kubakici@wp.pl>
> 

You're right about the reordering not making sense to someone unfamiliar 
with the problem. I can fix that with a comment.

I can change the patch so that request_firmware will only make the probe 
function fail if the firmware is not already running.

If that's not satisfactory, I will try to do what you suggested. (The 
lack of comment from mcgrof@kernel.org doesn't look promising, but maybe 
I'm just impatient.)
