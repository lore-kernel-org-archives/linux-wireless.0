Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from usul.saidi.cx ([204.11.33.34]:35175 "EHLO usul.overt.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751293AbYHBTPM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Aug 2008 15:15:12 -0400
Message-ID: <4894B22F.2070400@overt.org> (sfid-20080802_211516_459037_A957B332)
Date: Sat, 02 Aug 2008 12:14:55 -0700
From: Philip Langdale <philipl@overt.org>
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Matthew Garrett <mjg59@srcf.ucam.org>, toshiba_acpi@memebeam.org,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/1] toshiba_acpi: Add support for bluetooth toggling
 through rfkill (v2)
References: <488CBBA0.2050106@overt.org>
In-Reply-To: <488CBBA0.2050106@overt.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Philip Langdale wrote:
> As requested by Henrique, I have reworked this patch against 
> wireless-testing
> and it uses the new-style rfkill API and to report the input device as a 
> switch.
> 
> I did some digging to try and find a usable gpe event but had only limited
> success. From another look through the AML, it uses GPE08 for almost 
> everything
> - inspecting a bunch of state for each event and then sending 
> notifications on
> different objects. I couldn't find one for the hardware kill switch 
> itself but I
> did manage to find one that's emitted when the bluetooth device enters the
> equivalent of the SOFT_BLOCKED state. This is useful for noticing that the
> hardware switch has been released, but it also fires on transitions from 
> UNBLOCKED
> to SOFT_BLOCKED - so I had to try and avoid turning around and 
> unblocking the
> device! I'm not particularly happy with how I did it 
> (ignore-the-next-event)
> but I can't think of a better way.

I've updated the diff to use force_state instead of get_state. I'm a little
unhappy in that it requires poking the rfkill state from the input poll
function but that's the only way we know anything changed.

The event handling is still the same as before because I realised that there's
no fundamental state I can use to distinguish the two transitions - at the time
the event fires, the kill switch is inactive and the bluetooth device is
disconnected but we simply don't know where we came from (hard killed or on),
so we have to maintain some form of state in the driver and the current mechanism
is as good (or bad) as any other.

--phil
