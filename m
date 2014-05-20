Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f171.google.com ([209.85.216.171]:50182 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754319AbaETRlv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2014 13:41:51 -0400
Received: by mail-qc0-f171.google.com with SMTP id x13so1299433qcv.2
        for <linux-wireless@vger.kernel.org>; Tue, 20 May 2014 10:41:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAMEF0p_sywFDC_PVa-7sAGvgJ=cRNSTZpVaE4EauV_9Zgmui6g@mail.gmail.com>
References: <CAGnRvuq9pP3f+KiZAZ6Rpz-NKPqW9tnPRX4MmGZ6PK9PT3U_xA@mail.gmail.com>
 <546412005.18351359.1400528308190.JavaMail.root@zimbra65-e11.priv.proxad.net>
 <CAGnRvurBpWcn6ToSVq5bJN=bOuz_8ej9QgcvX6SP97M1ndwCRA@mail.gmail.com>
 <CAGnRvup8OVnkTxxJzV5Pe88XNUFXXVh21tpgygS=f27Hux=uiQ@mail.gmail.com> <CAMEF0p_sywFDC_PVa-7sAGvgJ=cRNSTZpVaE4EauV_9Zgmui6g@mail.gmail.com>
From: Henning Rogge <hrogge@gmail.com>
Date: Tue, 20 May 2014 19:41:30 +0200
Message-ID: <CAGnRvup1oBzKTgzMttY+JMoAN242L2yy+fojrmenMGsXEQh9wg@mail.gmail.com> (sfid-20140520_194154_629051_0EAE36E1)
Subject: Re: 802.11s mode without HWMP
To: Thomas Pedersen <thomas@noack.us>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am not convinced merging them is a good idea, because they contain
different information.

One of them is the list of AODV ("HWMP") capable MACs, the other is
"attached/bridged" MACs.

I will have a look at both tables and see what I can do with them,
maybe a second netlink command is necessary in cfg80211.

Thank you for the tip.

Henning Rogge

On Tue, May 20, 2014 at 7:36 PM, Thomas Pedersen <thomas@noack.us> wrote:
> Hi Henning,
>
> On Tue, May 20, 2014 at 5:32 AM, Henning Rogge <hrogge@gmail.com> wrote:
>> Hi,
>>
>> after spending a day reading through the 802.11s implementation of
>> Linux I have to admit I am lost...
>>
>> I am using 802.11s bridged to ethernet on both wlan interfaces and it
>> works very well.
>>
>> Unfortunately the cfg802.11 is not telling me which ethernet mac
>> address is behind which wifi mac address, something that has to be
>> known to the kernel to forward the bridged ethernet frames.
>>
>> Is there a trick to get this information or is this just a missing
>> functionality in the cfg80211 API (or the "iw <mesh-if> mpath ..."
>> commands) ?
>
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
>
> --
> thomas
