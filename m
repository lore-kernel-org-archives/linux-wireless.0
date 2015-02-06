Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:33955 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754641AbbBFNSP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Feb 2015 08:18:15 -0500
Date: Fri, 6 Feb 2015 18:47:57 +0530
From: Rajkumar <rmanohar@qti.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] ath10k: Bypass PLL setting on target init for QCA9888
Message-ID: <20150206131754.GA21494@qca.qualcomm.com> (sfid-20150206_141819_392189_3DEAF9F8)
References: <1423223238-17530-1-git-send-email-rmanohar@qti.qualcomm.com>
 <CA+BoTQnwo=yXt2-57pv97KRCjw6r=0mtRVNt0jLwaeGsEfThNg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CA+BoTQnwo=yXt2-57pv97KRCjw6r=0mtRVNt0jLwaeGsEfThNg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 06, 2015 at 12:58:40PM +0100, Michal Kazior wrote:
> On 6 February 2015 at 12:47, Rajkumar Manoharan
> <rmanohar@qti.qualcomm.com> wrote:
> > Some of of qca988x solutions are having global reset issue
> > during target initialization.
> 
> What kind of issue? How/when does it manifest?
>
PCI bus error was reported before downloading the firmware. This is
issue is very rarely observed with few qca8888 chips. Postponing PLL
settings is solving the problem.
> 
> > Bypassing PLL setting before
> > downloading firmware and letting the SoC run on REF_CLK is fixing
> > the problem. Corresponding firmware change is also needed to set
> > the clock source once the target is initialized. Since 10.2.4
> > firmware is having this ROM patch, applying skip_clock_init only
> > for 10.2.4 firmware versions.
> 
> Which 10.2.4? There are at least two publicly available blobs. Do all
> of them support this? How do other firmware revisions handle setting
> skip_clock_init to 1?
>
Yes. 10.2.4 firmwares are having this ROM patch fix. Others firmware
revisions do not have this ROM patch.
> 
> > Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
> > ---
> >  drivers/net/wireless/ath/ath10k/core.c | 14 ++++++++++++++
> >  1 file changed, 14 insertions(+)
> >
> > diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
> > index 310e12b..3119192 100644
> > --- a/drivers/net/wireless/ath/ath10k/core.c
> > +++ b/drivers/net/wireless/ath/ath10k/core.c
> > @@ -797,6 +797,20 @@ static int ath10k_download_cal_data(struct ath10k *ar)
> >         ar->cal_mode = ATH10K_CAL_MODE_OTP;
> >
> >  done:
> > +       if ((ar->hw_rev != ATH10K_HW_QCA988X) ||
> > +           (ar->wmi.op_version != ATH10K_FW_WMI_OP_VERSION_10_2_4)) {
> 
> Maybe using fw_features is a better idea, no?
> 
Hmm..Anyway we are using both fw_features & wmi.op_version across
driver. Still want to go with fw_features?

> > +               ath10k_dbg(ar, ATH10K_DBG_BOOT,
> > +                          "boot using calibration mode %s\n",
> > +                          ath10k_cal_mode_str(ar->cal_mode));
> 
> I don't really like the idea of duplicating debug prints.
>
Agree. Me too...:)

Thanks for the review.

-Rajkumar
