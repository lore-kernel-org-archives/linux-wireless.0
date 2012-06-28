Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:58034 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642Ab2F1OW2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2012 10:22:28 -0400
Received: by obbuo13 with SMTP id uo13so3082809obb.19
        for <linux-wireless@vger.kernel.org>; Thu, 28 Jun 2012 07:22:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FEC6447.7010007@cern.ch>
References: <4FE03291.5030202@cern.ch>
	<CAD2nsn1U0UHjrDp7vh7rfvTP=BLB3FA+zLV9sgt1_T7gVvAYgg@mail.gmail.com>
	<4FE0CA6C.3080002@cern.ch>
	<4FEC6447.7010007@cern.ch>
Date: Thu, 28 Jun 2012 19:52:27 +0530
Message-ID: <CAD2nsn3L6K6obTzpvnjetrWuGk+e+nKV=RsdQfYk3iVCsej66Q@mail.gmail.com> (sfid-20120628_162231_286663_E5F60F26)
Subject: Re: Mysterious hangs - cfg80211 - ath9k
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Jon Wikne <Jon.Wikne@cern.ch>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Thu, Jun 28, 2012 at 7:33 PM, Jon Wikne <Jon.Wikne@cern.ch> wrote:
> On 06/19/2012 08:52 PM, Jon Wikne wrote:
>>
>> On 06/19/2012 11:39 AM, Mohammed Shafi wrote:
>>>
>>> On Tue, Jun 19, 2012 at 1:34 PM, Jon Wikne<Jon.Wikne@cern.ch> wrote:
>>>>
>>>> Hi List,
>>>>
>>>> I am experiencing a puzzling problem with WLAN on a Toshiba Qosmio
>>>> F750 laptop, running CERN SLC 5.8 (mostly identical to RHEL 5.8),
>>>> but with kernel 2.6.39.4. (The kernel that came with the distro did
>>>> not work properly with WLAN on this machine at all.)
>>>
>>>
>>> please quickly try
>>>
>>> http://linuxwireless.org/en/users/Download#Where_to_download_bleeding_edge
>>
>>
>> I tried to install compat-wireless-2012-05-10. It worked for 4½ hours,
>> then same problem.
>>
>> Maybe there is something wrong with my understanding here, but I do not
>> see why the "cfg80211: Calling CRDA to update world regulatory domain"
>> should occur hours after the connection has been established, and what
>> triggers it, apparently at random....
>>
>>> or the latest wireless testing tree
>>>
>>> http://linuxwireless.org/en/developers/Documentation/git-guide#Cloning_latest_wireless-testing
>>
>>
>> Is there a reason to believe it could make a difference if I try
>> this too?
>
>
> Now I downloaded this (more than 1GB), just to realize that it is a
> complete kernel tree for kernel 3.5.0-rc3. I don't really feel ready
> for an experimental upgrade from 2.6.39.4 to that right now....
>
> With basis in compat-wireless-2012-05-10 I tried to comment out the
> call to call_crda in net/wireless/reg.c and return -EALREADY in line
> 1483, just to see if that circumvented the problem. It did not. The
> damage (whatever that might be) already seems to be done _before_ the
> call_crda is made in reg.c.
>
> I am a bit at a loss as to how to proceed. There are several things
> i do not understand.
>
> 1) The call to update CRDA (even with my crude, experimental, dummy
> return) seems to cause no trouble when it is done the first time
> the line comes up. Could someone please explain to me what causes
> the subsequent calls at highly irregular intervals, and why that
> seems to be necessary or desirable?
>
> 2) Is this a known problem that is being worked on (in which case I
> will just shut up and wait), or am I the first to report it?
>
> Thanks in advance for any further info or suggestions.

please provide the complete log. you can also enable ath9k debugging.
sudo modprobe -v ath9k debug=0x601
http://linuxwireless.org/en/users/Drivers/ath9k/debug
so you need to bring the interface up/down to make it working right ?
a recent fix, but not relevant to this i think
http://permalink.gmane.org/gmane.linux.kernel.wireless.general/92657

>
> Regards,
> -- Jon Wikne
>
>



-- 
thanks,
shafi
