Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:47321 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161677Ab2COVFA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 17:05:00 -0400
Received: by mail-yw0-f41.google.com with SMTP id 47so4308234yhr.0
        for <linux-wireless@vger.kernel.org>; Thu, 15 Mar 2012 14:04:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAK80WHZeAV7MCo6y6=2VkicUjUe4nU2YdUF5vk_0-m2_R8wdXA@mail.gmail.com>
References: <1327581484-22047-1-git-send-email-victorg@ti.com>
	<1327581484-22047-4-git-send-email-victorg@ti.com>
	<4F277F85.1090901@sipsolutions.net>
	<CAK80WHbAE0+NhLgLAxE+6BmkHFy2hw=sNV1TBjjOTajhHcdxRw@mail.gmail.com>
	<1328562090.3466.1.camel@jlt3.sipsolutions.net>
	<CAK80WHZF5f1R-iCPRgd3N2J2N-JM9P6qY6pVj_=Twej-RVjd4w@mail.gmail.com>
	<CAB=NE6XApT+FVBiGERxMVCYtBDEj0+SYa3s-rgsystUNvhh41A@mail.gmail.com>
	<CAK80WHZMu_NjN0Kofx39uF+uebSFkUtjZUzC=qYOp4+206gxNA@mail.gmail.com>
	<CAK80WHZeAV7MCo6y6=2VkicUjUe4nU2YdUF5vk_0-m2_R8wdXA@mail.gmail.com>
Date: Thu, 15 Mar 2012 22:04:59 +0100
Message-ID: <CAKd1q9paVnkBp2Lm7JDUc=THunDwUs_e=YxOTSi=S32TSg_TyQ@mail.gmail.com> (sfid-20120315_220522_411741_A908F130)
Subject: Re: [RFC 3/9] nl80211/cfg80211: add ability to enable TX on op-channel
From: "Coelho, Luciano" <coelho@ti.com>
To: "Goldenshtein, Victor" <victorg@ti.com>
Cc: "Luis R. Rodriguez" <mcgrof@frijolero.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian.chadd@gmail.com, j@w1.fi,
	assaf@ti.com, yoni.divinsky@ti.com, igalc@ti.com,
	adrian@freebsd.org, nbd@nbd.name
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Victor,

On 3/15/12, Goldenshtein, Victor <victorg@ti.com> wrote:
> To add an additional protection will also save a time stamp of the
> last start radar detection command (something like
> "last_dfs_cac_time"), and prior enabling the tx on the DFS channels
> will validate whether DFS_MIN_CAC_TIME (60 seconds) has passed since
> "last_dfs_cac_time".

Remember to also reset the last_dfs_cac_time when you receive a
RADAR_DETECTED event, as we discussed.  This will make sure we never
allow TX in DFS channels unless the DFS_MIN_CAC_TIME has passed since
detection started AND since the last radio signal was detected.

This will prevent the userspace from TXing illegally in DFS channels.

-- 
Cheers,
Luca.
