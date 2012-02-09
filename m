Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:59021 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757787Ab2BIWeW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Feb 2012 17:34:22 -0500
Received: by yenm8 with SMTP id m8so1205379yen.19
        for <linux-wireless@vger.kernel.org>; Thu, 09 Feb 2012 14:34:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAK80WHZF5f1R-iCPRgd3N2J2N-JM9P6qY6pVj_=Twej-RVjd4w@mail.gmail.com>
References: <1327581484-22047-1-git-send-email-victorg@ti.com>
 <1327581484-22047-4-git-send-email-victorg@ti.com> <4F277F85.1090901@sipsolutions.net>
 <CAK80WHbAE0+NhLgLAxE+6BmkHFy2hw=sNV1TBjjOTajhHcdxRw@mail.gmail.com>
 <1328562090.3466.1.camel@jlt3.sipsolutions.net> <CAK80WHZF5f1R-iCPRgd3N2J2N-JM9P6qY6pVj_=Twej-RVjd4w@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Thu, 9 Feb 2012 14:34:01 -0800
Message-ID: <CAB=NE6XApT+FVBiGERxMVCYtBDEj0+SYa3s-rgsystUNvhh41A@mail.gmail.com> (sfid-20120209_233426_061382_E1C1F3A6)
Subject: Re: [RFC 3/9] nl80211/cfg80211: add ability to enable TX on op-channel
To: "Goldenshtein, Victor" <victorg@ti.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian.chadd@gmail.com, j@w1.fi,
	coelho@ti.com, assaf@ti.com, yoni.divinsky@ti.com, igalc@ti.com,
	adrian@freebsd.org, nbd@nbd.name
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 9, 2012 at 1:04 PM, Goldenshtein, Victor <victorg@ti.com> wrote:
> On Mon, Feb 6, 2012 at 11:01 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>> I'm just trying to make sure that you're OK with a simple two-line iw
>> patch being sufficient to start transmitting on radar channels ...
>>
>>> I think the driver should perform this simple "sanity" checks,
>>> otherwise we"ll need to save different DFS states in the mac, not sure
>>> that this is what we want.
>>
>> I disagree -- adding this in each driver, which will surely end up with
>> slightly different semantics, seems like a recipe for disaster.
>>
>
> Zefir Kurtisi and myself thought to rename the start_radar detection +
> en_tx functions to something like
> dfs_start_cac() and dfs_resume_cac(), these two will set/reset
> WIPHY_FLAG_DFS_CAC_IN_PROGRESS flag, which should add some additional
> protection.
> Are you OK with this ?

I'd be more comfortable with a timer for the CAC as well.

  Luis
