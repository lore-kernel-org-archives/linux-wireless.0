Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:64538 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbbGILh0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jul 2015 07:37:26 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	<wil6210@qca.qualcomm.com>,
	Vladimir Shulman <QCA_shulmanv@QCA.qualcomm.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>,
	Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH 11/13] wil6210: TSO implementation
Date: Thu, 9 Jul 2015 14:37:22 +0300
Message-ID: <2576505.6RpAF3j2eF@lx-wigig-72> (sfid-20150709_133729_932403_29268958)
In-Reply-To: <CANUX_P0OLXxf_kj2SaYOeeQmQ7XHOhjMWia76--CLq15pXKWRQ@mail.gmail.com>
References: <1436081080-27305-1-git-send-email-qca_vkondrat@qca.qualcomm.com> <1436081080-27305-12-git-send-email-qca_vkondrat@qca.qualcomm.com> <CANUX_P0OLXxf_kj2SaYOeeQmQ7XHOhjMWia76--CLq15pXKWRQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday, July 08, 2015 10:06:37 PM Emmanuel Grumbach wrote:
> So your device is able to replicate and update the IP / TCP header?
> I don't really follow what your device is able to do.
> You seem to be cutting the frags so that their length sums up to mss.
> Which hints that your device can't segment the buffer by itself. OTOH,
> I don't see how you treat the IP / TCP header copy and modification.
> 
Emmanuel:
Yes, it is correct - hardware know to replicate IP/TCP header; and
DMA written in such a way that I have to arrange fragments to
sums up to MSS.

So this code fragment is OK. We tested it with lots of traffic.
However, after your comments for another code fragment,
I found there is a way to do it better. I'll rework and send updated patch.

Kalle: please drop this patch. The rest of patches should apply cleanly
without this one.

Thanks, Vladimir
