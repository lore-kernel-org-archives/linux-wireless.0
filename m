Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:38936 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752735Ab1HJK0j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2011 06:26:39 -0400
Received: by mail-bw0-f45.google.com with SMTP id zv3so405344bkb.18
        for <linux-wireless@vger.kernel.org>; Wed, 10 Aug 2011 03:26:37 -0700 (PDT)
Subject: Re: [PATCH 08/40] wl12xx: wl12xx-fw-3 - update commands & events
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <CAB3XZEcdxPhw=L4EA6ZJVnEOw6EZTu+WfZR8NJj_vrPMmU6-vQ@mail.gmail.com>
References: <1312881233-9366-1-git-send-email-eliad@wizery.com>
	 <1312881233-9366-9-git-send-email-eliad@wizery.com>
	 <1312967955.2407.452.camel@cumari>
	 <CAB3XZEcdxPhw=L4EA6ZJVnEOw6EZTu+WfZR8NJj_vrPMmU6-vQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Aug 2011 13:26:34 +0300
Message-ID: <1312971994.2407.473.camel@cumari> (sfid-20110810_122643_287083_95106A8F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-08-10 at 12:53 +0300, Eliad Peller wrote: 
> hi Luca,
> 
> thanks for your (ongoing) reviews.
> i'll apply your comments in the next version.

Thanks.  It will still take some time for me to finish going through all
these 40 patches, as I don't want to starve my other workqueues. ;)


> On Wed, Aug 10, 2011 at 12:19 PM, Luciano Coelho <coelho@ti.com> wrote:
> > On Tue, 2011-08-09 at 12:13 +0300, Eliad Peller wrote:
> >>       /* unmask required mbox events  */
> >>       wl->event_mask = BSS_LOSE_EVENT_ID |
> >>               SCAN_COMPLETE_EVENT_ID |
> >>               PS_REPORT_EVENT_ID |
> >> -             JOIN_EVENT_COMPLETE_ID |
> >>               DISCONNECT_EVENT_COMPLETE_ID |
> >>               RSSI_SNR_TRIGGER_0_EVENT_ID |
> >>               PSPOLL_DELIVERY_FAILURE_EVENT_ID |
> >>               SOFT_GEMINI_SENSE_EVENT_ID |
> >>               PERIODIC_SCAN_REPORT_EVENT_ID |
> >> -             PERIODIC_SCAN_COMPLETE_EVENT_ID;
> >> +             PERIODIC_SCAN_COMPLETE_EVENT_ID |
> >> +             DUMMY_PACKET_EVENT_ID |
> >> +             PEER_REMOVE_COMPLETE_EVENT_ID |
> >> +             BA_SESSION_RX_CONSTRAINT_EVENT_ID |
> >> +             REMAIN_ON_CHANNEL_COMPLETE_EVENT_ID;
> >>
> >>       if (wl->bss_type == BSS_TYPE_AP_BSS)
> >> -             wl->event_mask |= STA_REMOVE_COMPLETE_EVENT_ID |
> >> -                               INACTIVE_STA_EVENT_ID |
> >> +             wl->event_mask |= INACTIVE_STA_EVENT_ID |
> >>                                 MAX_TX_RETRY_EVENT_ID;
> >
> > Do we really need to mask this stuff separately?
> >
> we thought of masking the needed events according to the active role.
> anyway, i since there is no overlapping, and in the future there will
> be multiple roles, i guess we can just unmask them all together.

Yes, that was my point.  I think we don't need to care about unmasking
different events for different roles, because the events shouldn't be
sent in the wrong roles.

Actually, I started wondering why do we need an event mask at all! Okay,
someone will say, for power-saving blahblah, but do we really have any
real use case where we can use this feature in a smart way?


> >> -int wl1271_cmd_join(struct wl1271 *wl, u8 bss_type)
> >> +int wl1271_cmd_role_enable(struct wl1271 *wl, u8 role_type, u8 *role_id)
> >
> > s/wl1271_cmd_role_enable/wl12xx_cmd_role_enable/
> >
> > Same thing for wl1271_cmd_role_disable and all the other functions whose
> > declaration changed.
> >
> > I was thinking that we could use the role_id directly from the wl struct
> > here, but then I changed my mind, because I think it's not good that the
> > cmd functions themselves change the wl struct.  At some point we need to
> > split the HW-related part of wl (phy) from the context-related elements
> 
> well, that exactly our plan. after applying the all the pending series
> we'll start splitting up wl into global and per-vif data, in order to
> support multiple vifs.

Of course, I don't really see many different other options here. ;)


> > (vif).  For most of the cases, if not all, the cmd functions only use
> > the HW-related elements.
> >
> every command that takes role_id as param is basically per-vif, so i
> guess you're wrong here :)

Right, but what I meant was *before* your patchset.  And also I meant
the elements that are needed to send the command itself (like wl->flags,
wl->cmd_box_addr), not the elements that will actually go into the cmd
parameters.  Anyway, what matters here is that we're aligned. :)


> >> +
> >> +       memcpy(cmd->mac_address, wl->mac_addr, ETH_ALEN);
> >
> > To keep aligned with my comment about phy vs. vif context, I think it
> > would be nicer to pass the MAC address as an argument to this function
> > as well.  When we implement multirole, we will need different MAC
> > addresses for each role, so we can't really use the value from wl.
> >
> you are right, but let's leave it for a later stage.
> (i have some patch that replaces all the wl->mac_addr to vif->addr)

Okay, when I wrote this I had actually not seen the other many commands
that take stuff from the wl struct.  Let's do it all together.


> again, thanks for your reviews.
> i'll just apply all the required changes instead of ACKing each one :)

Yeah, easier like that.

-- 
Cheers,
Luca.

