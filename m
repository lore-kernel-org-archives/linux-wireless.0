Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:64893 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932070AbaETRgo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2014 13:36:44 -0400
Received: by mail-we0-f169.google.com with SMTP id u56so891542wes.0
        for <linux-wireless@vger.kernel.org>; Tue, 20 May 2014 10:36:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGnRvup8OVnkTxxJzV5Pe88XNUFXXVh21tpgygS=f27Hux=uiQ@mail.gmail.com>
References: <CAGnRvuq9pP3f+KiZAZ6Rpz-NKPqW9tnPRX4MmGZ6PK9PT3U_xA@mail.gmail.com>
 <546412005.18351359.1400528308190.JavaMail.root@zimbra65-e11.priv.proxad.net>
 <CAGnRvurBpWcn6ToSVq5bJN=bOuz_8ej9QgcvX6SP97M1ndwCRA@mail.gmail.com> <CAGnRvup8OVnkTxxJzV5Pe88XNUFXXVh21tpgygS=f27Hux=uiQ@mail.gmail.com>
From: Thomas Pedersen <thomas@noack.us>
Date: Tue, 20 May 2014 10:36:23 -0700
Message-ID: <CAMEF0p_sywFDC_PVa-7sAGvgJ=cRNSTZpVaE4EauV_9Zgmui6g@mail.gmail.com> (sfid-20140520_193647_812763_698927EA)
Subject: Re: 802.11s mode without HWMP
To: Henning Rogge <hrogge@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Henning,

On Tue, May 20, 2014 at 5:32 AM, Henning Rogge <hrogge@gmail.com> wrote:
> Hi,
>
> after spending a day reading through the 802.11s implementation of
> Linux I have to admit I am lost...
>
> I am using 802.11s bridged to ethernet on both wlan interfaces and it
> works very well.
>
> Unfortunately the cfg802.11 is not telling me which ethernet mac
> address is behind which wifi mac address, something that has to be
> known to the kernel to forward the bridged ethernet frames.
>
> Is there a trick to get this information or is this just a missing
> functionality in the cfg80211 API (or the "iw <mesh-if> mpath ..."
> commands) ?

mac80211 keeps a separate table for bridged endpoints (mpp_paths).
Unfortunately this table currently isn't exported by the cfg80211
mpath_dump API. If you really need access to this information from
cfg80211 / userspace, then the quickest thing for now would be to hack
in support for iterating over both tables.

I'm not really sure why the decision was made to go with 2 different
path tables (see 79617dee for the initial implementation), but it
seems the cleaner approach would be to merge these and stick with the
existing mpath_dump commands.

-- 
thomas
