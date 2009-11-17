Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-72-92-88-10.phlapa.fios.verizon.net ([72.92.88.10]:40203
	"EHLO smtp.roinet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674AbZKQRrb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2009 12:47:31 -0500
Message-ID: <4B02DFF4.1060509@roinet.com>
Date: Tue, 17 Nov 2009 12:40:04 -0500
From: David Acker <dacker@roinet.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Michael Renzmann <mrenzmann@madwifi-project.org>,
	madwifi-devel@lists.sourceforge.net,
	madwifi-users@lists.sourceforge.net,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [Madwifi-devel] Survey: What are you using MadWifi for, and why?
References: <2205.95.222.251.107.1258282369.squirrel@webmail.otaku42.de> <43e72e890911161701p61d0db5ag25a1459f900b3ab7@mail.gmail.com>
In-Reply-To: <43e72e890911161701p61d0db5ag25a1459f900b3ab7@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On Sun, Nov 15, 2009 at 2:52 AM, Michael Renzmann
> <mrenzmann@madwifi-project.org> wrote:
>> Hi all.
>>
>> As you might have noticed, there currently is a discussion [1] going on
>> about the future directions of the MadWifi project, including a decision
>> how to deal with MadWifi driver. It turns out that there are pretty
>> contrary positions in this regard: some would like to see MadWifi being
>> dumped completely as soon as possible, others would prefer to continue
>> development and even implement new features.
>>
>> What do others think? It appears to me that we know too little about what
>> MadWifi is actually used for today and why. Thus I'd like to start a quick
>> survey.
>>
>> It would be great if you could answer some or - ideally - all of the
>> following questions:
>>

Personally, I would love to switch to ath5k but I am stuck using madwifi 
due to a need for features that are missing on ath5k.  I think the 
issues I have are pretty common for the wireless router community.  See 
below for more details.


>>  1. What are you using MadWifi for?
Wireless mesh on embedded systems.

>>
>>  2. Did you already evaluate ath5k/ath9k? If no, why not?
I have monitored the list and saw significant issues with ath5k in AP 
mode early on.  AP mode and WDS mode are the main modes we use.  We 
rarely need client mode.  Also, folks seemed resistant to adding all the 
features of madwifi to ath5k/mac80211.

>>
>>  3. In case you evaluated ath5k/ath9k but did not yet switch: what is the
>> reason for your decision, and what is required before you could switch?
ath5k has been missing features that madwifi has and was reported as 
very unstable in AP mode in the past.  In some platforms I must use 
older kernels (2.6.18) due to limited kernel support from an embedded 
hardware vendor.  In some setups I need DFS support.  I need multiple 
SSID support with each SSID supporting different crypto settings and I 
need hardware crypto support.  These were all issues at different times. 
  Some of them may be resolved at this point but they all existed (or 
seemed to exist to me) at one point and convinced me to avoid working on 
switching from madwifi to ath5k.

There was a thread not too long ago ( 
http://marc.info/?l=linux-wireless&m=125152150203308&w=2 ) that 
discussed some features that are in madwifi but not in ath5k.  I would 
love to see dynamic and static turbo modes supported in ath5k.  Half and 
quarter rates are required to use certain channels on devices from 
Ubiquiti (XR7 and XR9 for example).  Fast frames and hardware 
compression can also improve performance in certain situations.

Also, support for WiSOCs like the PicoStation and Bullet from Ubiquiti 
would be required to switch from madwifi on those platforms.

-ack
