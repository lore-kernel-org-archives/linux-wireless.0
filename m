Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:41039 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753069AbbBSLfF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Feb 2015 06:35:05 -0500
Received: by labpv20 with SMTP id pv20so6962078lab.8
        for <linux-wireless@vger.kernel.org>; Thu, 19 Feb 2015 03:35:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1708052.J876aMsZU2@lx-wigig-72>
References: <1708052.J876aMsZU2@lx-wigig-72>
Date: Thu, 19 Feb 2015 13:35:03 +0200
Message-ID: <CANUX_P3AO=EwS0GjVz8MHGWOtMd_6GNA=mWDwb=nTCU30m+eDA@mail.gmail.com> (sfid-20150219_123539_200866_40DD164F)
Subject: Re: [RFC] zero-copy AMSDU processing
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Vladimir Kondratiev <QCA_vkondrat@qca.qualcomm.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 19, 2015 at 12:51 PM, Vladimir Kondratiev
<QCA_vkondrat@qca.qualcomm.com> wrote:
>
> I am looking for ideas how can one process AMSDU in the software, without copying data.
> Current implementation like ieee80211_amsdu_to_8023s() do copy packet data.
>
> Assume I got in the driver, MPDU that is AMSDU containing several MSDU's.
> It is in the single memory buffer that was allocated for DMA.
> Can I construct skb's per MSDU with minimal data copy, having most of the
> original data in place? Any ideas for this?
>

You already have the TCP header inside the MSDUs. I guess all you need
to do is to clone the skb and update the offset in the frag?
Note that tn that case, the page will be shared. I am really not an
expert in all this kind of things.

Note that iwlwifi can technically have 2 Rx packets in the same page,
we handle that.

> Thanks, Vladimir.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
