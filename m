Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vk0-f49.google.com ([209.85.213.49]:36200 "EHLO
	mail-vk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239AbcFOQSC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jun 2016 12:18:02 -0400
Received: by mail-vk0-f49.google.com with SMTP id u64so36460411vkf.3
        for <linux-wireless@vger.kernel.org>; Wed, 15 Jun 2016 09:18:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <10ea53e5030e54e51caa61380bd24c47@smile.fr>
References: <4eed6159efdc3f86e4f549bb31ce6a74@smile.fr> <CAKVVYBk2Rf6RMPW1uySq4M7LeFCRHBGipYdiOqwQSHxFNmst=A@mail.gmail.com>
 <053ed5ba9d69bc5e6f36ed7e95526663@smile.fr> <4fdb1514a02744ad9b8ac11b96e57130@SC-EXCH04.marvell.com>
 <404feff5a5bca118ba53b69301700e2f@smile.fr> <db092693c63a4a06ada95537e22d5abf@SC-EXCH04.marvell.com>
 <2259a8e8239c9497571d30fa86e7f84c@smile.fr> <CAKVVYBmb1X0OFz9kanTcGKxHTYDJt8u_ZusFEdPWk4Mu3FMBBQ@mail.gmail.com>
 <a11a109dbfbcd5c2fd952563de1a4c8c@smile.fr> <CAKVVYBnrC6h1EvEW3jpMOsCqgAQ9L-mu_985QyFOOYFY+vZn1Q@mail.gmail.com>
 <10ea53e5030e54e51caa61380bd24c47@smile.fr>
From: Raymond Hayes <hayesr@google.com>
Date: Wed, 15 Jun 2016 09:17:58 -0700
Message-ID: <CAKVVYBkxH+7Gtr_ZBw03gUYdUOeqBCCqXHpvFTPS8WOspVnRJg@mail.gmail.com> (sfid-20160615_181831_291166_E76A2A4E)
Subject: Re: mwifiex+wpa_supplicant cannot set up WPA/WPA2 ADHOC
To: Vincent CESSON <vincent.cesson@smile.fr>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
	linux-wireless@vger.kernel.org, Shengzhen Li <szli@marvell.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm not sure what to tell you.  Did you look into the GTK installation
failure?  For WPA-PSK, there's 1 4-way handshake and the STA installs
1 PTK and 1 GTK.  For WPA2-PSK for IBSS, there are 2 4-way handshakes
and the STA installs 1 PTK and 2 GTKs.  If the peer's GTK isn't
installed, the STA won't be able to decrypt the peer's broadcast
frames.  Do you have a sniff of the failure?  What's failing?  Does it
work if you use static IP addresses and static ARP entries?

Ray

On Wed, Jun 15, 2016 at 7:17 AM, Vincent CESSON <vincent.cesson@smile.fr> wrote:
> I set a successful AP network with WPA-PSK (see conf and log attached). As
> you can see on log, the message "Could not set station 48:45:20:3b:31:75
> flags for kernel driver" appears too, but the connection is OK.
>
>
>
>
> Le 2016-06-15 13:35, Raymond Hayes a écrit :
>>
>> The logs were from wpa_supplicant so I suggest starting there; but
>> the problem could be on either side, so you'll probably have to look
>> into mwiflex too.
>>
>> Ray
>>
>> On Wednesday, June 15, 2016, Vincent CESSON <vincent.cesson@smile.fr>
>> wrote:
>>
>>> Hi Raymond,
>>>
>>> Who is trying to mark the peer authorized? Should I look into mwifiex
>>> driver? cfg80211.ko? libnl? wpa_supplicant? I am a bit lost among all these
>>> elements.
>>>
>>> Vincent
>>>
>>> Le 2016-06-14 02:30, Raymond Hayes a écrit :
>>>
>>>> From the RSN log, the dual 4-way handshakes succeeded, but the GTK was
>>>> not installed:
>>>>
>>>> nl80211: set_key failed; err=-22 Invalid argument)
>>>>
>>>> and it looks like there was a problem marking the peer authorized:
>>>>
>>>> AUTH: 48:45:20:3b:31:75 authorizing port
>>>> Could not set station 48:45:20:3b:31:75 flags for kernel driver
>>>> (errno=11)
>>>>
>>>> Ray
>>>>
>>>> On Mon, Jun 13, 2016 at 7:42 AM, Vincent CESSON
>>>> <vincent.cesson@smile.fr> wrote:
>>>>
>>>>> Hi Amitkumar,
>>>>>
>>>>> Here are the wpa_supplicant logs (with CONFIG_IBSS_RSN=y enabled) from
>>>>> the
>>>>> two devices. Beside wpa_supplicant, I manually set IPs 192.168.1.xy
>>>>> with
>>>>> command "ifconfig mlan0 192.168.1.xy" and then I try to ping each
>>>>> other,
>>>>> without success.
>>>>>
>>>>> Vincent
>>>>>
>>>>> Le 2016-06-13 15:40, Amitkumar Karwar a écrit :
>>>>>
>>>>>> Hi Vincent,
>>>>>>
>>>>>>> From: Vincent CESSON [mailto:vincent.cesson@smile.fr]
>>>>>>> Sent: Monday, June 13, 2016 7:09 PM
>>>>>>> To: Amitkumar Karwar
>>>>>>> Cc: Raymond Hayes; linux-wireless@vger.kernel.org
>>>>>>> Subject: RE: mwifiex+wpa_supplicant cannot set up WPA/WPA2 ADHOC
>>>>>>>
>>>>>>> About the strange behaviour with the two devices connecting despite
>>>>>>> the
>>>>>>> bad passwords, I made a little mistake: on the device 2,
>>>>>>> wpa_supplicant
>>>>>>> was not built with option CONFIG_IBSS_RSN=y. But still, device 1
>>>>>>> should
>>>>>>> not accept device 2...
>>>>>>>
>>>>>>> Note that with option CONFIG_IBSS_RSN=y enabled on both devices,
>>>>>>> WPA-PSK
>>>>>>> connection does not work, even with the right password...
>>>>>>
>>>>>>
>>>>>> I see. Please share the wpa_supplicant logs with CONFIG_IBSS_RSN=y
>>>>>> enabled for analysis.
>>>>>>
>>>>>> Regards,
>>>>>> Amitkumar
