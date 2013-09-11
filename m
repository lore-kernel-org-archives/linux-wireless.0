Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:54395 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752136Ab3IKJdf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Sep 2013 05:33:35 -0400
Message-ID: <523038E8.2070806@openwrt.org> (sfid-20130911_113338_363977_852765DE)
Date: Wed, 11 Sep 2013 11:33:28 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Ben Greear <greearb@candelatech.com>
CC: Sujith Manoharan <sujith@msujith.org>,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Always send management frames at MCS-0??
References: <522E1D31.2090403@candelatech.com> <21038.54250.912310.332354@gargle.gargle.HOWL> <522F3F6B.2070203@candelatech.com>
In-Reply-To: <522F3F6B.2070203@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-09-10 5:48 PM, Ben Greear wrote:
> On 09/10/2013 01:10 AM, Sujith Manoharan wrote:
>> Ben Greear wrote:
>>> I had a user request that we support always sending management frames
>>> (such as EAPOL) at the lowest rate.  Evidently, other equipment does this,
>>> where as normal-ish supplicant/linux tends to send them at much higher
>>> rates.
>>>
>>> Any suggestions on how to go about doing this properly?
>>
>> If this is with ath9k_rate_control, then it is a known bug:
>> https://bugzilla.redhat.com/show_bug.cgi?id=927191
> 
> I'm not using ath9k rate control in this case, and at least most messages
> get through fine.  We didn't actually see any obvious improvement when forcing
> everything to 6Mbps, but since my user was asking, I wanted to run the
> idea past the list.
> 
> Rate control is not perfect, and on initial bringup it doesn't have
> many packets to work with so I thought it might still be useful to allow
> users to specify a particular rate for EAPOL packets.  Maybe using
> a socket ioctl so user-space (ie, supplicant/hostapd) can control it,
> for example.
minstrel and minstrel_ht always keep low rates in the rate retry chain
until enough higher rates have been proven to work.
I think adding an interface that allows user space to mess with the rate
selection of EAPOL packets is a bad idea - users will pretty much always
make worse rate decisions than the rate control module.

- Felix
