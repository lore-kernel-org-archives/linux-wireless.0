Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:44689 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754369Ab1A2Afh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Jan 2011 19:35:37 -0500
Received: by iwn9 with SMTP id 9so3637223iwn.19
        for <linux-wireless@vger.kernel.org>; Fri, 28 Jan 2011 16:35:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4D435D76.2040703@candelatech.com>
References: <4D4345A8.6060806@candelatech.com> <4D435D76.2040703@candelatech.com>
From: Daniel Halperin <dhalperi@cs.washington.edu>
Date: Fri, 28 Jan 2011 16:35:16 -0800
Message-ID: <AANLkTimji+Y0KfDCzWDX63KfOjRFzxgKbVAq6HhMcw20@mail.gmail.com>
Subject: Re: hti->control_chan is 15??
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 28, 2011 at 4:21 PM, Ben Greear <greearb@candelatech.com> wrote:
> On 01/28/2011 02:39 PM, Ben Greear wrote:
>>
>> When testing with 60 stations, 30 against a netgear running HT40
>> and 30 against a cheap cisco AP, using HT20, I notice that the
>> stations on the netgear often choose NO_HT instead of HT40
>> for their channel type.
>>
>> The root cause appears to be that the hti->control_chan is 15
>> in the ieee80211_enable_ht method.
>>
>> Everything *should* be running on channel 11.
>>
>> Is this just a bug with the AP, or could this be a local
>> issue?
>
> I sniffed on a separate machine (using ath9k NIC), and it agrees
> that the beacon's control_channel is 14 (I have since set the AP to channel
> 10 instead of 11, but the control_channel remains 4 higher than expected.)
>

How did you configure the AP to HT40 mode? Did you put HT40+ or HT40-
in the hostapd.conf file?

Look at IEEE 802.11n-2009, Annex I and J.  They explain what these
mean and which combinations are valid in which sets.

Looks like you're using a weird domain and/or disabled ath's
regulatory checks? I'd think that they would catch this otherwise.
Or, it could also be a bug related to the Japan regulatory stuff that
seemed to cause problems for iwlwifi also.

Dan
