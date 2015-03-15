Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:27385 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296AbbCOIHA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Mar 2015 04:07:00 -0400
Date: Sun, 15 Mar 2015 13:36:41 +0530
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] ath10k: Bypass PLL setting on target init for
 QCA9888
Message-ID: <20150315080637.GA18213@qca.qualcomm.com> (sfid-20150315_090712_949646_D130A06F)
References: <1423460814-2767-1-git-send-email-rmanohar@qti.qualcomm.com>
 <87wq2v4nwz.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <87wq2v4nwz.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 05, 2015 at 02:41:16PM +0200, Kalle Valo wrote:
> Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:
> 
> > Some of of qca988x solutions are having global reset issue
> > during target initialization. Bypassing PLL setting before
> > downloading firmware and letting the SoC run on REF_CLK is fixing
> > the problem. Corresponding firmware change is also needed to set
> > the clock source once the target is initialized. Since 10.2.4
> > firmware is having this ROM patch, applying skip_clock_init only
> > for 10.2.4 firmware versions.
> >
> > Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
> > ---
> >  drivers/net/wireless/ath/ath10k/core.c | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> >
> > diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
> > index 310e12b..cd20805 100644
> > --- a/drivers/net/wireless/ath/ath10k/core.c
> > +++ b/drivers/net/wireless/ath/ath10k/core.c
> > @@ -797,6 +797,16 @@ static int ath10k_download_cal_data(struct ath10k *ar)
> >  	ar->cal_mode = ATH10K_CAL_MODE_OTP;
> >  
> >  done:
> > +	if ((ar->hw_rev == ATH10K_HW_QCA988X) &&
> > +	    (ar->wmi.op_version == ATH10K_FW_WMI_OP_VERSION_10_2_4)) {
> > +		ret = ath10k_bmi_write32(ar, hi_skip_clock_init, 1);
> > +		if (ret) {
> > +			ath10k_err(ar, "could not write skip_clock_init (%d)\n",
> > +				   ret);
> > +			return ret;
> > +		}
> > +	}
> 
> Didn't Michal mention that this should be a firmware feature flag?
> Checking for firmware versions can easily get too complicated, that's
> why we have tried to use feature flags for things like this.
>
Oops.. Sorry for the delay. I missed this mail. IIRC i replied to
Michal's question for previous version. From the existing fw_feature
flag, there is no clear way to identify 10.2.4 firmware version. Since
this patch is needed only for 10.2.4, I used op_version. Otherwise
fw_feature has to be extended for 10.2.4. Am i correct?

> Also I think this should not be hidden inside
> ath10k_download_cal_data(). Maybe ath10k_core_start() is a better place
> to do this?
>
Hmm.. agree.

> I can send v3 for this patch.
> 
Thanks for taking care of this. Please let me know if you need help.

-Rajkumar
