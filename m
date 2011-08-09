Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:55808 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848Ab1HISLy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 14:11:54 -0400
Received: from wpaz17.hot.corp.google.com (wpaz17.hot.corp.google.com [172.24.198.81])
	by smtp-out.google.com with ESMTP id p79IBm2p005562
	for <linux-wireless@vger.kernel.org>; Tue, 9 Aug 2011 11:11:48 -0700
Received: from yxl11 (yxl11.prod.google.com [10.190.3.203])
	by wpaz17.hot.corp.google.com with ESMTP id p79IBltq009241
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 9 Aug 2011 11:11:47 -0700
Received: by yxl11 with SMTP id 11so256456yxl.21
        for <linux-wireless@vger.kernel.org>; Tue, 09 Aug 2011 11:11:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E39EB52.1090401@candelatech.com>
References: <4E38DDB3.1030801@candelatech.com>
	<CA+yqC4YvAMLaao4dy2aXM7H5zPXySk4eAUZ2KSM4QnP+kQqF-A@mail.gmail.com>
	<4E39EB52.1090401@candelatech.com>
Date: Tue, 9 Aug 2011 11:11:46 -0700
Message-ID: <CA+yqC4a1xCPM4WN5U5Oth9PUqGSg+h6qZ4u2sV80h3zcEtzazg@mail.gmail.com> (sfid-20110809_201158_047651_D8DC247F)
Subject: Re: Bridging wired to STA interfaces.
From: Sam Leffler <sleffler@google.com>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 3, 2011 at 5:44 PM, Ben Greear <greearb@candelatech.com> wrote:
> On 08/03/2011 03:37 PM, Sam Leffler wrote:
>>
>> On Tue, Aug 2, 2011 at 10:33 PM, Ben Greear<greearb@candelatech.com>
>>  wrote:
>>>
>>> We have some interest in being able to bridge wired systems to
>>> (virtual) STA interfaces, primarily for using third-party
>>> traffic generation tools over virtual stations.
>>>
>>> I was thinking of writing a sta-bridge module that mapped
>>> incoming packets on a wired interface to a STA with MAC
>>> that matched the source MAC of the packet.  All packets
>>> received on the STA would be forwarded un-modified out
>>> the wired port.
>>>
>>> I think this would allow someone to create a STA interface
>>> with MAC matching a PC connected to the wired port and effectively
>>> have it be a transparent bridge between STA and PC.
>>>
>>> Has anyone attempted something like this before?
>>>
>>> Any interest in having this feature in the upstream kernel?
>>
>> You've just described what's done in several products and it is indeed
>> useful.  The main issue is supporting it can incur overhead so you may
>> want to make it a compile-time option.
>
> I got some basic functionality working today with some
> user-space bridging code I've already written for other purposes...
>
> Can you think of any reason (beyond a bit of performance) that
> this should be in the kernel?

Doing it in user space seems fine to start.  All the examples I can
think of are on minimal embedded platforms where taking the user-space
hit is infeasible.  All the wireless devices that are interesting can
do this in h/w w/ only minimal kernel support (except for the vif
setup).

FWIW the overhead I was referring to is in the kernel.  A many-to-1
mapping of STA<->AP can be more expensive to support than 1-1.  But
since you already support multi-sta you're already paying the price.

>
> My target hardware is fast enough that copying through user-space
> at moderate (ie, fast as STA can go) speeds isn't too big of a deal, but
> if someone wanted to run this on weak hardware, that might be reason
> enough...  It might also make it easier to filter our management frames
> (EAPOL, etc), but we should be able to do that easily enough in user-space
> with a small bit of work.

Setting up and tearing down the sta's in response to wired traffic was
always the fun part.  Everything else was straightforward from what I
can recall.

-Sam
