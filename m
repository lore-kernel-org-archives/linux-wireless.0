Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:35781 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753825Ab2BIVEO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Feb 2012 16:04:14 -0500
Received: by lboi8 with SMTP id i8so960683lbo.25
        for <linux-wireless@vger.kernel.org>; Thu, 09 Feb 2012 13:04:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1328562090.3466.1.camel@jlt3.sipsolutions.net>
References: <1327581484-22047-1-git-send-email-victorg@ti.com>
	<1327581484-22047-4-git-send-email-victorg@ti.com>
	<4F277F85.1090901@sipsolutions.net>
	<CAK80WHbAE0+NhLgLAxE+6BmkHFy2hw=sNV1TBjjOTajhHcdxRw@mail.gmail.com>
	<1328562090.3466.1.camel@jlt3.sipsolutions.net>
Date: Thu, 9 Feb 2012 23:04:05 +0200
Message-ID: <CAK80WHZF5f1R-iCPRgd3N2J2N-JM9P6qY6pVj_=Twej-RVjd4w@mail.gmail.com> (sfid-20120209_220421_994618_E482192F)
Subject: Re: [RFC 3/9] nl80211/cfg80211: add ability to enable TX on op-channel
From: "Goldenshtein, Victor" <victorg@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, zefir.kurtisi@neratec.com,
	adrian.chadd@gmail.com, j@w1.fi, coelho@ti.com, assaf@ti.com,
	yoni.divinsky@ti.com, igalc@ti.com, adrian@freebsd.org,
	nbd@nbd.name
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 6, 2012 at 11:01 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> I'm just trying to make sure that you're OK with a simple two-line iw
> patch being sufficient to start transmitting on radar channels ...
>
>> I think the driver should perform this simple "sanity" checks,
>> otherwise we"ll need to save different DFS states in the mac, not sure
>> that this is what we want.
>
> I disagree -- adding this in each driver, which will surely end up with
> slightly different semantics, seems like a recipe for disaster.
>

Zefir Kurtisi and myself thought to rename the start_radar detection +
en_tx functions to something like
dfs_start_cac() and dfs_resume_cac(), these two will set/reset
WIPHY_FLAG_DFS_CAC_IN_PROGRESS flag, which should add some additional
protection.
Are you OK with this ?


-- 
Thanks,
Victor.
