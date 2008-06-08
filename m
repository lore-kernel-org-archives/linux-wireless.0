Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mbox2.netikka.net ([213.250.81.203]:57917 "EHLO
	mbox2.netikka.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756515AbYFHUHm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jun 2008 16:07:42 -0400
Message-ID: <484C3C08.4010603@mandriva.org> (sfid-20080608_220749_889784_1FD9B430)
Date: Sun, 08 Jun 2008 23:07:36 +0300
From: Thomas Backlund <tmb@mandriva.org>
MIME-Version: 1.0
To: Tomas Winkler <tomasw@gmail.com>
CC: Thomas Backlund <tmb@mandriva.org>,
	Ian Schram <ischram@telenet.be>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: iwl4965 oops in 2.6.26-rc5 x86_64
References: <4848289D.1080205@mandriva.org> <48492E85.6010307@mandriva.org>	 <1ba2fa240806060659wf4e4088s8afdd2f7f854ea09@mail.gmail.com>	 <48494EF6.4020506@mandriva.org>	 <1ba2fa240806060812q28c270c4i12cc08f8665e9cc0@mail.gmail.com>	 <4849AF9F.9010207@mandriva.org>	 <1ba2fa240806061659j7672f9d3w107be4509b533f68@mail.gmail.com>	 <484A8CF5.3060801@mandriva.org>	 <1ba2fa240806080327gec9b38vf6bb1faa0e5014b8@mail.gmail.com>	 <484BCECC.4040004@mandriva.org> <1ba2fa240806080831k4fce156an535caec87e374e19@mail.gmail.com>
In-Reply-To: <1ba2fa240806080831k4fce156an535caec87e374e19@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tomas Winkler skrev:
> On Sun, Jun 8, 2008 at 3:21 PM, Thomas Backlund <tmb@mandriva.org> wrote:
>> Tomas Winkler skrev:
>>> I'm not sure what distro are you running I haven't seen this
>>> ifcfg-wlan0 config options
>>> on my system but can it be that ifcg-wlan0 tries to set wep key which
>>> will conflict
>>> with wpa_supplicant setting. Can you try to remove this line from that
>>> file
>>>
>>> ifcfg-wlan0 -
>>> --- cut ---
>>> WIRELESS_ENC_KEY='s:*************************'
>>>
>>>
>>
>> Nice.
>>
>> The distro is Mandriva Cooker (development) but we have the same in Mandriva
>> 2008.1 Spring.
>>
>> Now this has not been any problem with kernels older than 2.6.25, so it's a
>> regression, isn't it? I mean, shouldn't the module protect itself against
>> empty variables?
>>
> This is not really regression. What happen is that we've enabled hw
> crypto acceleration by default so when
> you switched back to sw crypto it still worked.

Yeah, you're right.
I forgot about that.

> There is bug no question, I believe it's the same bug as Ian Schram
> and Joonwoo Park reported (PSK key is longer then 128 WEP Key)
> 

Any patch ready for testing ?

>> And that config option also exist in Redhat initscripts ifup-wireless...
>>
>> Anyway, you found the initial problem, as the kernel now booted without an
>> oops, and seems to work, but:
>>
> 
> Try to disable this one from th config file MAC80211_DEBUG_PACKET_ALIGNMENT
> 

That did it, thanks.

Thomas
