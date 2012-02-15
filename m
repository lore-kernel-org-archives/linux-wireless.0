Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:42190 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751048Ab2BOQpr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Feb 2012 11:45:47 -0500
Received: by mail-lpp01m010-f44.google.com with SMTP id l5so1190178lah.3
        for <linux-wireless@vger.kernel.org>; Wed, 15 Feb 2012 08:45:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAB=NE6XApT+FVBiGERxMVCYtBDEj0+SYa3s-rgsystUNvhh41A@mail.gmail.com>
References: <1327581484-22047-1-git-send-email-victorg@ti.com>
	<1327581484-22047-4-git-send-email-victorg@ti.com>
	<4F277F85.1090901@sipsolutions.net>
	<CAK80WHbAE0+NhLgLAxE+6BmkHFy2hw=sNV1TBjjOTajhHcdxRw@mail.gmail.com>
	<1328562090.3466.1.camel@jlt3.sipsolutions.net>
	<CAK80WHZF5f1R-iCPRgd3N2J2N-JM9P6qY6pVj_=Twej-RVjd4w@mail.gmail.com>
	<CAB=NE6XApT+FVBiGERxMVCYtBDEj0+SYa3s-rgsystUNvhh41A@mail.gmail.com>
Date: Wed, 15 Feb 2012 18:45:37 +0200
Message-ID: <CAK80WHZMu_NjN0Kofx39uF+uebSFkUtjZUzC=qYOp4+206gxNA@mail.gmail.com> (sfid-20120215_174615_390932_B0B847E6)
Subject: Re: [RFC 3/9] nl80211/cfg80211: add ability to enable TX on op-channel
From: "Goldenshtein, Victor" <victorg@ti.com>
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian.chadd@gmail.com, j@w1.fi,
	coelho@ti.com, assaf@ti.com, yoni.divinsky@ti.com, igalc@ti.com,
	adrian@freebsd.org, nbd@nbd.name
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 10, 2012 at 12:34 AM, Luis R. Rodriguez
<mcgrof@frijolero.org> wrote:
> On Thu, Feb 9, 2012 at 1:04 PM, Goldenshtein, Victor <victorg@ti.com> wrote:
>> Zefir Kurtisi and myself thought to rename the start_radar detection +
>> en_tx functions to something like
>> dfs_start_cac() and dfs_resume_cac(), these two will set/reset
>> WIPHY_FLAG_DFS_CAC_IN_PROGRESS flag, which should add some additional
>> protection.
>> Are you OK with this ?
>
> I'd be more comfortable with a timer for the CAC as well.
>
>  Luis

Not sure I"m understand what you're saying here, the CAC timer handled
in the hostap, kernel doesn't know anything about it. The
WIPHY_FLAG_DFS_CAC_IN_PROGRESS exactly says that DFS master (hostapd)
performs a channel availability check, which also indicates that the
CAC timer is running (if this what you mean).



-- 
Thanks,
Victor.
