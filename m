Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:52158 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760836Ab2COJhj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 05:37:39 -0400
Received: by mail-lpp01m010-f42.google.com with SMTP id l5so2457187lah.29
        for <linux-wireless@vger.kernel.org>; Thu, 15 Mar 2012 02:37:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAK80WHZMu_NjN0Kofx39uF+uebSFkUtjZUzC=qYOp4+206gxNA@mail.gmail.com>
References: <1327581484-22047-1-git-send-email-victorg@ti.com>
	<1327581484-22047-4-git-send-email-victorg@ti.com>
	<4F277F85.1090901@sipsolutions.net>
	<CAK80WHbAE0+NhLgLAxE+6BmkHFy2hw=sNV1TBjjOTajhHcdxRw@mail.gmail.com>
	<1328562090.3466.1.camel@jlt3.sipsolutions.net>
	<CAK80WHZF5f1R-iCPRgd3N2J2N-JM9P6qY6pVj_=Twej-RVjd4w@mail.gmail.com>
	<CAB=NE6XApT+FVBiGERxMVCYtBDEj0+SYa3s-rgsystUNvhh41A@mail.gmail.com>
	<CAK80WHZMu_NjN0Kofx39uF+uebSFkUtjZUzC=qYOp4+206gxNA@mail.gmail.com>
Date: Thu, 15 Mar 2012 11:37:37 +0200
Message-ID: <CAK80WHZeAV7MCo6y6=2VkicUjUe4nU2YdUF5vk_0-m2_R8wdXA@mail.gmail.com> (sfid-20120315_103743_239463_19307292)
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

On Wed, Feb 15, 2012 at 6:45 PM, Goldenshtein, Victor <victorg@ti.com> wrote:
> On Fri, Feb 10, 2012 at 12:34 AM, Luis R. Rodriguez
> > I'd be more comfortable with a timer for the CAC as well.
> >
> >  Luis
>
> Not sure I"m understand what you're saying here, the CAC timer handled
> in the hostap, kernel doesn't know anything about it. The
> WIPHY_FLAG_DFS_CAC_IN_PROGRESS exactly says that DFS master (hostapd)
> performs a channel availability check, which also indicates that the
> CAC timer is running (if this what you mean).
>

To add an additional protection will also save a time stamp of the
last start radar detection command (something like
"last_dfs_cac_time"), and prior enabling the tx on the DFS channels
will validate whether DFS_MIN_CAC_TIME (60 seconds) has passed since
"last_dfs_cac_time".

--
Thanks,
Victor.
