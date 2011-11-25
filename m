Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57887 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134Ab1KYSfg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Nov 2011 13:35:36 -0500
Received: by iage36 with SMTP id e36so4891095iag.19
        for <linux-wireless@vger.kernel.org>; Fri, 25 Nov 2011 10:35:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1322159597.5366.37.camel@jlt3.sipsolutions.net>
References: <1321886416-12597-1-git-send-email-ivan.bezyazychnyy@gmail.com>
	<1322159597.5366.37.camel@jlt3.sipsolutions.net>
Date: Fri, 25 Nov 2011 22:35:35 +0400
Message-ID: <CAG5dHkRGHLW-LCDus_A83gyuJrz7GUWrRM9FU566n29s0bwjCA@mail.gmail.com> (sfid-20111125_193541_428491_674AB6FE)
Subject: Re: [RFC v2 0/8] mesh power saving implementation: indication
From: Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 24 November 2011 22:33, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2011-11-21 at 18:40 +0400, Ivan Bezyazychnyy wrote:
>
>> Based on the latest IEEE 802.11s standard the power saving mechanism
>> can be divided into the following implementation phases:
>> * indication of mesh STAs' power modes in frames;
>> * a buffering and identification sending frames in mesh STA;
>> * Mesh Awake Window implementation;
>> * Peer service periods.
>>
>> This patchset implements the phase of indication of mesh STAs'
>> power modes in frames. There are two types of mesh power modes:
>> * peer power mode: a mesh STA indicates its mesh power mode for each
>> mesh peering and obtains the mesh power modes of its peer mesh STAs;
>> * non-peer power mode: mesh station also indicates mesh power mode for
>> non-peer mesh stations. It determines when non-peer mesh STAs may send
>> Probe Request and Mesh Peering Open Request frames to the mesh STA.
>>
>> Peer power mode should be indicated with Power Management field in the Frame
>> Control field and the Mesh Power Save Level field in all transmitted
>> individually addressed Mesh Data or QoS Null frames on this link.
>>
>> Non-peer power mode should be indicated with the Power Management
>> field in the Frame Control field and the Mesh Power Save Level field
>> in the Mesh Capability field in Beacon and Probe Response frames. A
>> mesh STA shall also indicate its non-peer mesh power mode with the
>> Power Management field in the Frame Control field and the Mesh Power
>> Save Level field in the QoS Control field in group addressed Mesh Data
>> frames.
>>
>> We would appreciate comments and advice.
>
> I just did a cursory review -- I only looked at code style and general
> issues.
>
Thanks for review,

Best regards,
Ivan
