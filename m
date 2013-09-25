Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:36331 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036Ab3IYQqZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Sep 2013 12:46:25 -0400
Received: by mail-ob0-f172.google.com with SMTP id gq1so7187727obb.3
        for <linux-wireless@vger.kernel.org>; Wed, 25 Sep 2013 09:46:25 -0700 (PDT)
Message-ID: <5243135D.30700@lwfinger.net> (sfid-20130925_221656_913692_FDC7D461)
Date: Wed, 25 Sep 2013 11:46:21 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Dan Williams <dcbw@redhat.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: No connection with TP-Link TL-WN823N (rtl8192cu)
References: <CAEZsi7Hde5NyTRgm7Lf_4LvHMAEJouzaqMNUwxr-iSipuEcsyQ@mail.gmail.com>   <522E4315.4040806@lwfinger.net> <1378764913.31180.9.camel@dcbw.foobar.com>  <524215AD.6060300@lwfinger.net> <1380113275.7555.18.camel@dcbw.foobar.com>
In-Reply-To: <1380113275.7555.18.camel@dcbw.foobar.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/25/2013 07:47 AM, Dan Williams wrote:
> On Tue, 2013-09-24 at 17:43 -0500, Larry Finger wrote:
>> On 09/09/2013 05:15 PM, Dan Williams wrote:
>>> On Mon, 2013-09-09 at 16:52 -0500, Larry Finger wrote:
>>
>>>> I have been running rtl8192cu for the past 24 hours without a permanent
>>>> disconnect. Under NetworkManager, I see some reason 7 deauthentications, but
>>>
>>> Running wpa_supplicant with debugging on might shed some light on these;
>>> basically:
>>>
>>> mv /usr/sbin/wpa_supplicant /
>>> killall -TERM wpa_supplicant
>>> /wpa_supplicant -dddtu <piped to your favorite log file>
>>>
>>> and NM should automatically reconnect, and then we can figure out what's
>>> going on in the supplicant.
>>
>> Dan,
>>
>> The log of wpa_supplicant associated with the reason 7 disconnects are as follows:
>
> So reason 7 is "Incorrect frame type or subtype received from
> unassociated station" which seems like the AP thinks we got
> disconnected, and would seem to be a driver/mac80211 issue still, right?

Yes. These only happen with rtl8192ce and rtl8192cu. They are a bit more common 
when running NetworkManager than with ifup. In my current run, they have been at 
intervals of 1000 to 30,000 seconds apart. Capturing them with wireshark may not 
be practical.

--snip--

> And got reconnected after a bit more than one second.  So at least it
> recovers quickly, but the question is more about why the reason 7
> happened, and what frames caused it, I think.

I agree. The sequence seems to start with an MLME Event 39:

.908249: nl80211: MLME event 39
.908252: nl80211: MLME event frame - hexdump(len=26): c0 00 3a 01 1c 65 9d 5a c3 
9d 20 e5 2a 01 f7 ea 20 e5 2a 01 f7 ea a0 f6 07 00
.908269: wlan3: Event DEAUTH (12) received
.908273: wlan3: Deauthentication notification

All that happens within 25 usec, but I have no clue what triggers that. In 
addition, I have been unable to find any documentation on MLME events. Any 
suggestions regarding a source would be appreciated.

Thanks,

Larry

