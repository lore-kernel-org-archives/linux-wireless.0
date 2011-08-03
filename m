Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:14074 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754882Ab1HCWhJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Aug 2011 18:37:09 -0400
Received: from kpbe14.cbf.corp.google.com (kpbe14.cbf.corp.google.com [172.25.105.78])
	by smtp-out.google.com with ESMTP id p73Mb4j8001634
	for <linux-wireless@vger.kernel.org>; Wed, 3 Aug 2011 15:37:04 -0700
Received: from iye1 (iye1.prod.google.com [10.241.50.1])
	by kpbe14.cbf.corp.google.com with ESMTP id p73MZeIr016785
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 3 Aug 2011 15:37:03 -0700
Received: by iye1 with SMTP id 1so127388iye.13
        for <linux-wireless@vger.kernel.org>; Wed, 03 Aug 2011 15:37:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E38DDB3.1030801@candelatech.com>
References: <4E38DDB3.1030801@candelatech.com>
Date: Wed, 3 Aug 2011 15:37:02 -0700
Message-ID: <CA+yqC4YvAMLaao4dy2aXM7H5zPXySk4eAUZ2KSM4QnP+kQqF-A@mail.gmail.com> (sfid-20110804_003713_504184_2F0CA0B8)
Subject: Re: Bridging wired to STA interfaces.
From: Sam Leffler <sleffler@google.com>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 2, 2011 at 10:33 PM, Ben Greear <greearb@candelatech.com> wrote:
> We have some interest in being able to bridge wired systems to
> (virtual) STA interfaces, primarily for using third-party
> traffic generation tools over virtual stations.
>
> I was thinking of writing a sta-bridge module that mapped
> incoming packets on a wired interface to a STA with MAC
> that matched the source MAC of the packet.  All packets
> received on the STA would be forwarded un-modified out
> the wired port.
>
> I think this would allow someone to create a STA interface
> with MAC matching a PC connected to the wired port and effectively
> have it be a transparent bridge between STA and PC.
>
> Has anyone attempted something like this before?
>
> Any interest in having this feature in the upstream kernel?

You've just described what's done in several products and it is indeed
useful.  The main issue is supporting it can incur overhead so you may
want to make it a compile-time option.

-Sam
