Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51685 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755532Ab2DJVZE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Apr 2012 17:25:04 -0400
Message-ID: <4F84A52A.7050905@sipsolutions.net> (sfid-20120410_232512_051526_CC91157B)
Date: Tue, 10 Apr 2012 14:24:58 -0700
From: Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
To: Marcel Holtmann <marcel@holtmann.org>
CC: Andrei Emeltchenko <Andrei.Emeltchenko.news@gmail.com>,
	linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [RFCv1] mac80211: Adds Software / Virtual AMP 80211
References: <1334059909-20513-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>  <1334059909-20513-2-git-send-email-Andrei.Emeltchenko.news@gmail.com>  (sfid-20120410_141120_556160_FD038CE7) <4F846257.1060807@sipsolutions.net> <1334092668.16897.54.camel@aeonflux> <4F84A422.3030900@sipsolutions.net> (sfid-20120410_232057_023197_F7AC82E9)
In-Reply-To: <4F84A422.3030900@sipsolutions.net> (sfid-20120410_232057_023197_F7AC82E9)
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4/10/2012 2:20 PM, Johannes Berg wrote:
>>> I don't get this patch at all. Why am I reviewing some very very basic
>>> skeleton code when we should be discussing userspace APIs (we have
>>> already discussed them with a few people years ago), how the AMP is
>>> going to be managed, how the security handshake is going to work, etc.
>>
>> adding AMP (meaning Bluetooth Alternate MAC/PHY in case anybody cares)
>> for SoftMac WiFi cards should be done solely in kernel space between
>> Bluetooth core and mac80211. All the FullMac cards will expose the HCI
>> AMP directly via the Bluetooth core. See Marvell solution for example.
>>
>> If we require a userspace interaction, I think we are doing something
>> wrong here. And as far as I can tell, the only tricky part is the WPA2
>> PSK 4-way handshake. We would need a kernel implementation for that.
>
> You already know I disagree, I don't want this code re-implemented in
> kernel space when adding a few tightly controlled APIs is all it needs
> to use an existing implementation of the relevant mechanisms.

There are also additional complexities like wpa_supplicant having to 
know whether to set up/tear down a BT AMP interface for P2P concurrency 
etc., so it's not really a good idea anyway to implement it purely in 
kernel space and hope it'll all work out.

(My flight is boarding now so I can't elaborate or discuss right now.)

johannes
