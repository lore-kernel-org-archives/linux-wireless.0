Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from idris.smile.fr ([91.216.209.19]:54025 "EHLO idris.smile.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423481AbcFMNii (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jun 2016 09:38:38 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Mon, 13 Jun 2016 15:38:35 +0200
From: Vincent CESSON <vincent.cesson@smile.fr>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: Raymond Hayes <hayesr@google.com>, <linux-wireless@vger.kernel.org>
Subject: RE: =?UTF-8?Q?mwifiex+wpa=5Fsupplicant=20cannot=20set=20up=20WPA/?=
 =?UTF-8?Q?WPA=32=20ADHOC?=
In-Reply-To: <4fdb1514a02744ad9b8ac11b96e57130@SC-EXCH04.marvell.com>
References: <4eed6159efdc3f86e4f549bb31ce6a74@smile.fr>
 <CAKVVYBk2Rf6RMPW1uySq4M7LeFCRHBGipYdiOqwQSHxFNmst=A@mail.gmail.com>
 <053ed5ba9d69bc5e6f36ed7e95526663@smile.fr>
 <4fdb1514a02744ad9b8ac11b96e57130@SC-EXCH04.marvell.com>
Message-ID: <404feff5a5bca118ba53b69301700e2f@smile.fr> (sfid-20160613_153842_799095_D7867FDE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

About the strange behaviour with the two devices connecting despite the 
bad passwords, I made a little mistake: on the device 2, wpa_supplicant 
was not built with option CONFIG_IBSS_RSN=y. But still, device 1 should 
not accept device 2...

Note that with option CONFIG_IBSS_RSN=y enabled on both devices, 
WPA-PSK connection does not work, even with the right password...

Vincent


Le 2016-06-13 15:23, Amitkumar Karwar a écrit :
> Hi Vincent,
> 
>> From: linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-
>> owner@vger.kernel.org] On Behalf Of Vincent CESSON
>> Sent: Monday, June 13, 2016 1:52 PM
>> To: Raymond Hayes
>> Cc: linux-wireless@vger.kernel.org
>> Subject: Re: mwifiex+wpa_supplicant cannot set up WPA/WPA2 ADHOC
>> 
>> Here are the logs.
>> 
>> I don't know if there is 4-way handshake in each direction, I don't 
>> have
>> logs on computer side, I use GUI. I tried to use the same
>> wpa_supplicant-rsn.conf on my computer and start it with 
>> wpa_supplicant,
>> but nothing happen... Embedded device does not react at all.
>> 
>> I found something new (and strange). I took a second embedded device,
>> set the same wpa_supplicant-rsn.conf except the passwords (I set 2
>> different passwords), and I use the same command line:
>> wpa_supplicant -dd -i mlan0 -c /etc/wpa_supplicant-rsn.conf -D
>> nl80211,wext Result, the two devices join and ping! When I start the
>> second device, no logs appear on the first device...
>> How is it possible psk is not taken into account?
>> 
> 
> Thanks for reporting the problem. We will try this at our end and
> check the issue.
> 
> Regards,
> Amitkumar
