Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f52.google.com ([209.85.192.52]:40883 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbaEUGvY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 May 2014 02:51:24 -0400
Received: by mail-qg0-f52.google.com with SMTP id a108so2460694qge.25
        for <linux-wireless@vger.kernel.org>; Tue, 20 May 2014 23:51:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAMEF0p_sywFDC_PVa-7sAGvgJ=cRNSTZpVaE4EauV_9Zgmui6g@mail.gmail.com>
References: <CAGnRvuq9pP3f+KiZAZ6Rpz-NKPqW9tnPRX4MmGZ6PK9PT3U_xA@mail.gmail.com>
 <546412005.18351359.1400528308190.JavaMail.root@zimbra65-e11.priv.proxad.net>
 <CAGnRvurBpWcn6ToSVq5bJN=bOuz_8ej9QgcvX6SP97M1ndwCRA@mail.gmail.com>
 <CAGnRvup8OVnkTxxJzV5Pe88XNUFXXVh21tpgygS=f27Hux=uiQ@mail.gmail.com> <CAMEF0p_sywFDC_PVa-7sAGvgJ=cRNSTZpVaE4EauV_9Zgmui6g@mail.gmail.com>
From: Henning Rogge <hrogge@gmail.com>
Date: Wed, 21 May 2014 08:51:03 +0200
Message-ID: <CAGnRvuraX7OgXmWOedxHGhytx0OL2LPs05+HQ4L6ApsnHWBrLg@mail.gmail.com> (sfid-20140521_085127_553728_08AFAAAB)
Subject: Re: 802.11s mode without HWMP
To: Thomas Pedersen <thomas@noack.us>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 20, 2014 at 7:36 PM, Thomas Pedersen <thomas@noack.us> wrote:
> Hi Henning,
> mac80211 keeps a separate table for bridged endpoints (mpp_paths).
> Unfortunately this table currently isn't exported by the cfg80211
> mpath_dump API. If you really need access to this information from
> cfg80211 / userspace, then the quickest thing for now would be to hack
> in support for iterating over both tables.
>
> I'm not really sure why the decision was made to go with 2 different
> path tables (see 79617dee for the initial implementation), but it
> seems the cleaner approach would be to merge these and stick with the
> existing mpath_dump commands.

After looking at both tables (especially the m***_path_add()
functions) I think the two tables could be joined.

Mesh-nodes could be just a special case where mpp and dst is the same
address. The alternative would be to have a flag that states the same
thing.

I don't even think this would slow down the path_lookup that much,
because normally the proxied destinations should be in different hash
buckets than the normal ones.

Of course cfg80211 would have to deliver both mpp and dst to
userspace, I am not quite sure how to do this without breaking
compatibility in the output. Maybe an additional netlink command (dump
"full" mpath?) would be better than putting more output into the
existing one.

Henning Rogge
