Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vk0-f50.google.com ([209.85.213.50]:33685 "EHLO
	mail-vk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422674AbcFNAa4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jun 2016 20:30:56 -0400
Received: by mail-vk0-f50.google.com with SMTP id d185so76757726vkg.0
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jun 2016 17:30:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <2259a8e8239c9497571d30fa86e7f84c@smile.fr>
References: <4eed6159efdc3f86e4f549bb31ce6a74@smile.fr> <CAKVVYBk2Rf6RMPW1uySq4M7LeFCRHBGipYdiOqwQSHxFNmst=A@mail.gmail.com>
 <053ed5ba9d69bc5e6f36ed7e95526663@smile.fr> <4fdb1514a02744ad9b8ac11b96e57130@SC-EXCH04.marvell.com>
 <404feff5a5bca118ba53b69301700e2f@smile.fr> <db092693c63a4a06ada95537e22d5abf@SC-EXCH04.marvell.com>
 <2259a8e8239c9497571d30fa86e7f84c@smile.fr>
From: Raymond Hayes <hayesr@google.com>
Date: Mon, 13 Jun 2016 17:30:54 -0700
Message-ID: <CAKVVYBmb1X0OFz9kanTcGKxHTYDJt8u_ZusFEdPWk4Mu3FMBBQ@mail.gmail.com> (sfid-20160614_023100_276943_DFE0137A)
Subject: Re: mwifiex+wpa_supplicant cannot set up WPA/WPA2 ADHOC
To: Vincent CESSON <vincent.cesson@smile.fr>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
	linux-wireless@vger.kernel.org, Shengzhen Li <szli@marvell.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From the RSN log, the dual 4-way handshakes succeeded, but the GTK was
not installed:

nl80211: set_key failed; err=-22 Invalid argument)

and it looks like there was a problem marking the peer authorized:

AUTH: 48:45:20:3b:31:75 authorizing port
Could not set station 48:45:20:3b:31:75 flags for kernel driver (errno=11)

Ray

On Mon, Jun 13, 2016 at 7:42 AM, Vincent CESSON <vincent.cesson@smile.fr> wrote:
> Hi Amitkumar,
>
> Here are the wpa_supplicant logs (with CONFIG_IBSS_RSN=y enabled) from the
> two devices. Beside wpa_supplicant, I manually set IPs 192.168.1.xy with
> command "ifconfig mlan0 192.168.1.xy" and then I try to ping each other,
> without success.
>
> Vincent
>
>
>
> Le 2016-06-13 15:40, Amitkumar Karwar a écrit :
>>
>> Hi Vincent,
>>
>>> From: Vincent CESSON [mailto:vincent.cesson@smile.fr]
>>> Sent: Monday, June 13, 2016 7:09 PM
>>> To: Amitkumar Karwar
>>> Cc: Raymond Hayes; linux-wireless@vger.kernel.org
>>> Subject: RE: mwifiex+wpa_supplicant cannot set up WPA/WPA2 ADHOC
>>>
>>> About the strange behaviour with the two devices connecting despite the
>>> bad passwords, I made a little mistake: on the device 2, wpa_supplicant
>>> was not built with option CONFIG_IBSS_RSN=y. But still, device 1 should
>>> not accept device 2...
>>>
>>> Note that with option CONFIG_IBSS_RSN=y enabled on both devices, WPA-PSK
>>> connection does not work, even with the right password...
>>>
>>
>> I see. Please share the wpa_supplicant logs with CONFIG_IBSS_RSN=y
>> enabled for analysis.
>>
>> Regards,
>> Amitkumar
