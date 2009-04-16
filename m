Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:16810 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756437AbZDPSra convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Apr 2009 14:47:30 -0400
Received: by fg-out-1718.google.com with SMTP id e12so177964fga.17
        for <linux-wireless@vger.kernel.org>; Thu, 16 Apr 2009 11:47:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1239902910.26575.14.camel@johannes.local>
References: <69e28c910904141733m72ce521ap8f1865bec991fff7@mail.gmail.com>
	<1239902910.26575.14.camel@johannes.local>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Thu, 16 Apr 2009 20:47:13 +0200
Message-ID: <69e28c910904161147h5a68d3b5nd054b043d6ad2719@mail.gmail.com> (sfid-20090416_204733_723731_297F9014)
Subject: Re: [Proposal]TX flags
To: Johannes Berg <johannes@sipsolutions.net>
Cc: radiotap@radiotap.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/4/16 Johannes Berg <johannes@sipsolutions.net>:
> On Wed, 2009-04-15 at 02:33 +0200, G=E1bor Stefanik wrote:
>
>> =A0 =A0- Define bit 1 (mask 0x0002) as "CTS-to-self protection",
>> =A0 =A0- Define bit 2 (mask 0x0004) as "RTS/CTS handshake",
>
> Since you're defining these for injection too I think it would be use=
ful
> to also define a way to _not_ use RTS or CTS, or define a way to use =
the
> default that the device would use from dot11RTSThreshold for example.
>
> Otherwise, when leaving out these bits, it wouldn't be clear whether
> that means "do not use, overriding default" or "use default".
>
> johannes
>

Here is how I think this can be done:
Because it's impossible to have a packet protected both by CTS-to-self
and by RTS/CTS, we can define the case where both the CTS and RTS
flags are set as "Automatically use RTS or CTS as needed". The same
should be true when the TX flags field is missing entirely. When the
TX flags field is present, and both flags are 0, that should be
interpreted as "don't protect the packet".

So, in summary, this is how things should be interpreted:

TX Flags absent: Use RTS & CTS as needed.
TX Flags present: {
RTS=3D0, CTS=3D0: Use neither RTS nor CTS.
RTS=3D0, CTS=3D1: Use CTS-to-self.
RTS=3D1, CTS=3D0: Use RTS/CTS-handshake.
RTS=3D1, CTS=3D1: Use RTS & CTS as needed.
}

Alternatively, the meanings of the {0,0} and {1,1} cases could be
switched around (making the {0,0} case more logical, at the expense of
the {1,1} one):

TX Flags absent: Use RTS & CTS as needed.
TX Flags present: {
RTS=3D0, CTS=3D0: Use RTS & CTS as needed.
RTS=3D0, CTS=3D1: Use CTS-to-self.
RTS=3D1, CTS=3D0: Use RTS/CTS-handshake.
RTS=3D1, CTS=3D1: Use neither RTS nor CTS.
}

(By reading the second proposal again, I find it more and more
sympathetic... but let the discussion decide.)

--G=E1bor

--=20
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
