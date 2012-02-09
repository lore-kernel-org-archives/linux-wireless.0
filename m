Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35197 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758332Ab2BIWgs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Feb 2012 17:36:48 -0500
Received: by iacb35 with SMTP id b35so3133471iac.19
        for <linux-wireless@vger.kernel.org>; Thu, 09 Feb 2012 14:36:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAK80WHaiOp2f08ErSiLdoSOcN1A1EbFX4x02wGPQY1WJJrKK-g@mail.gmail.com>
References: <1327581484-22047-1-git-send-email-victorg@ti.com>
 <1327581484-22047-5-git-send-email-victorg@ti.com> <4F277FE3.8090006@sipsolutions.net>
 <CAK80WHaiOp2f08ErSiLdoSOcN1A1EbFX4x02wGPQY1WJJrKK-g@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Thu, 9 Feb 2012 14:36:28 -0800
Message-ID: <CAB=NE6XVqqfRF+4QtzxeknuvOyupEiNjzx4Cvjcv7DdPsvU1rA@mail.gmail.com> (sfid-20120209_233652_957634_D0224D5C)
Subject: Re: [RFC 4/9] mac80211: add ability to enable TX on op-channel
To: "Goldenshtein, Victor" <victorg@ti.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian.chadd@gmail.com, j@w1.fi,
	coelho@ti.com, assaf@ti.com, yoni.divinsky@ti.com, igalc@ti.com,
	adrian@freebsd.org, nbd@nbd.name
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 2, 2012 at 8:06 AM, Goldenshtein, Victor <victorg@ti.com> wrote:
> On Tue, Jan 31, 2012 at 7:45 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>> On 1/26/2012 4:37 AM, Victor Goldenshtein wrote:
>>>
>>> Prior starting tx on DFS channels, the DFS master
>>> device shall perform a Channel Availability Check
>>> to ensure that there is no radar interference on
>>> those channels. Once CAC done, the tx can be
>>> enabled with ieee80211_dfs_en_tx().
>>
>>
>> How do you expect this to be used by the device? It seems that it should
>> have the side effect of lifting some TX-prohibited flag instead?
>
> In wl12xx driver we starting the AP role, and clearing FLAG_DFS_CAC_IN_PROGRESS.
> Maybe the function name is misleading here ? maybe we should rename it
> to something like resume_dfs_cac() - because it is called at the end
> of the CAC test.
>
> The other question is whether we want to add DFS flags into mac? I
> mean something like FLAG_DFS_CAC_IN_PROGRESS.

How about that and a CAC timer as sanity checks to cfg80211, not mac80211.

  Luis
