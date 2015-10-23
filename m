Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:53238 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbbJWGKV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2015 02:10:21 -0400
From: "Li, Yanbo" <yanbol@qca.qualcomm.com>
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>
CC: "dreamfly281@gmail.com" <dreamfly281@gmail.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH] ath10k: Adjust the RX packet pad offset at QCA99X0 4addr
 mode
Date: Fri, 23 Oct 2015 06:10:17 +0000
Message-ID: <2cd04da006cb4f2a8eea859b6aad3e10@nasanexm02e.na.qualcomm.com> (sfid-20151023_081025_701301_92DD4DEC)
References: <1445575816-4500-1-git-send-email-yanbol@qca.qualcomm.com>
 <877fme40ny.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <877fme40ny.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



> -----Original Message-----
> From: Valo, Kalle
> Sent: Thursday, October 22, 2015 10:25 PM
> To: Li, Yanbo
> Cc: dreamfly281@gmail.com; ath10k@lists.infradead.org; linux-
> wireless@vger.kernel.org
> Subject: Re: [PATCH] ath10k: Adjust the RX packet pad offset at QCA99X0
> 4addr mode
> 
> Yanbo Li <yanbol@qca.qualcomm.com> writes:
> 
> > The QCA99X0 4 addresses RX packets pad 2 bytes at the beginning of
> > MSDU instead the end of ieee80211 header to keep align. The currently
> > RX data path can't parse the header correctly in this case. This patch
> > fixes it for QCA99X0
> >
> > Signed-off-by: Yanbo Li <yanbol@qca.qualcomm.com>
> >
> > diff --git a/drivers/net/wireless/ath/ath10k/core.c
> > b/drivers/net/wireless/ath/ath10k/core.c
> > index 13de3617d5ab..3c1d07c191d5 100644
> > --- a/drivers/net/wireless/ath/ath10k/core.c
> > +++ b/drivers/net/wireless/ath/ath10k/core.c
> > @@ -58,6 +58,7 @@ static const struct ath10k_hw_params
> ath10k_hw_params_list[] = {
> >  		.otp_exe_param = 0,
> >  		.channel_counters_freq_hz = 88000,
> >  		.max_probe_resp_desc_thres = 0,
> > +		.loc_4addr_pad = ATH10K_4ADDR_PAD_AFT,
> >  		.fw = {
> >  			.dir = QCA988X_HW_2_0_FW_DIR,
> >  			.fw = QCA988X_HW_2_0_FW_FILE,
> > @@ -75,6 +76,7 @@ static const struct ath10k_hw_params
> ath10k_hw_params_list[] = {
> >  		.otp_exe_param = 0,
> >  		.channel_counters_freq_hz = 88000,
> >  		.max_probe_resp_desc_thres = 0,
> > +		.loc_4addr_pad = ATH10K_4ADDR_PAD_AFT,
> >  		.fw = {
> >  			.dir = QCA6174_HW_2_1_FW_DIR,
> >  			.fw = QCA6174_HW_2_1_FW_FILE,
> > @@ -92,6 +94,7 @@ static const struct ath10k_hw_params
> ath10k_hw_params_list[] = {
> >  		.otp_exe_param = 0,
> >  		.channel_counters_freq_hz = 88000,
> >  		.max_probe_resp_desc_thres = 0,
> > +		.loc_4addr_pad = ATH10K_4ADDR_PAD_AFT,
> >  		.fw = {
> >  			.dir = QCA6174_HW_3_0_FW_DIR,
> >  			.fw = QCA6174_HW_3_0_FW_FILE,
> > @@ -109,6 +112,7 @@ static const struct ath10k_hw_params
> ath10k_hw_params_list[] = {
> >  		.otp_exe_param = 0,
> >  		.channel_counters_freq_hz = 88000,
> >  		.max_probe_resp_desc_thres = 0,
> > +		.loc_4addr_pad = ATH10K_4ADDR_PAD_AFT,
> >  		.fw = {
> >  			/* uses same binaries as hw3.0 */
> >  			.dir = QCA6174_HW_3_0_FW_DIR,
> > @@ -128,6 +132,7 @@ static const struct ath10k_hw_params
> ath10k_hw_params_list[] = {
> >  		.continuous_frag_desc = true,
> >  		.channel_counters_freq_hz = 150000,
> >  		.max_probe_resp_desc_thres = 24,
> > +		.loc_4addr_pad = ATH10K_4ADDR_PAD_PRE,
> >  		.fw = {
> >  			.dir = QCA99X0_HW_2_0_FW_DIR,
> >  			.fw = QCA99X0_HW_2_0_FW_FILE,
> > diff --git a/drivers/net/wireless/ath/ath10k/core.h
> > b/drivers/net/wireless/ath/ath10k/core.h
> > index 7cc7cdd56c95..b4db8bbf85ce 100644
> > --- a/drivers/net/wireless/ath/ath10k/core.h
> > +++ b/drivers/net/wireless/ath/ath10k/core.h
> > @@ -646,6 +646,9 @@ struct ath10k {
> >  		 */
> >  		u32 max_probe_resp_desc_thres;
> >
> > +		/* The padding bytes's location is different on various chips */
> > +		enum ath10k_loc_4addr_pad loc_4addr_pad;
> 
> I think that loc prefix is a bit misleading, it reminds me of
> locationing/positioning etc. What about ath10k_hw_4addr_pad?
> 


There is already a  FW feature defined as  "ATH10K_FW_FEATURE_NO_NWIFI_DECAP_4ADDR_PADDIND" and 
the relative string is "no-4addr-pad", if we just remove the "loc" prefix,  it may be confuse with this FW feature.

How about we change the loc to offset in this case or any better suggestion?

Thanks
BR /Yanbo 
 

 
