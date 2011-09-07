Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:58401 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472Ab1IGSYD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Sep 2011 14:24:03 -0400
Received: by pzk37 with SMTP id 37so97109pzk.1
        for <linux-wireless@vger.kernel.org>; Wed, 07 Sep 2011 11:24:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1315418920.4002.13.camel@jlt3.sipsolutions.net>
References: <1315347976-13950-1-git-send-email-javier@cozybit.com> <1315418920.4002.13.camel@jlt3.sipsolutions.net>
From: Javier Cardona <javier@cozybit.com>
Date: Wed, 7 Sep 2011 11:23:43 -0700
Message-ID: <CAPjQAd88HXmm4y0P-rbBivB8h2V+gGC8sH=obnQRUWBVGPnzTw@mail.gmail.com> (sfid-20110907_202408_405926_2B32780F)
Subject: Re: [PATCH 0/2] QoS headers for mesh
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org, linux-wireless@vger.kernel.org,
	jlopex@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 7, 2011 at 11:08 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2011-09-06 at 15:26 -0700, Javier Cardona wrote:
>> Mesh frames are required to have QoS headers to indicate the presence of a Mesh
>> Control Header in the payload.  These patches add QoS headers to mesh frames,
>> but note that they don't implement full QoS support: mesh stations don't
>> currently advertise QoS capabilities.
>
> Uh, so does mesh want full QoS support or just QoS headers? The latter
> seems a little odd to me. But if it wants QoS how about zd1211rw? I
> don't think that even supports QoS?
>
> That's one thing that bothers me a little bit about this patchset --
> previously, QoS frames could only happen when the device actually
> supported 4 queues, now this rule seems to be broken. I don't expect
> this to be a major issue, but it certainly is unexpected and will
> probably be forgotten by a lot of people in the future ...

Some background:  The 11s task group needed a way to indicate the
presence of the mesh control header but there were no more bits
available in the frame control header.  Some earlier draft versions
stated something like "the mesh control header is present in all data
frames between mesh stations" which would require analyzing peering
frames in order to correctly parse mesh frames.  The current draft
(which will become a standard this Friday) calls for using a bit in
the QoS header.  Not pretty but definitely better than the previous
alternative.

What is unclear to me from the current spec is whether it is mandatory
that mesh stations support QoS.  If it is, we would also only support
mesh if the device supported 4 queues. I'll try to clarify this point.

Thanks,

Javier
