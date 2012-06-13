Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:5058 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289Ab2FMBCl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2012 21:02:41 -0400
Date: Tue, 12 Jun 2012 18:02:38 -0700
From: "Pedersen, Thomas" <c_tpeder@qca.qualcomm.com>
To: Joe Perches <joe@perches.com>
CC: <kvalo@qca.qualcomm.com>, <ath6kl-devel@qualcomm.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: support rssi threshold for sched scan
Message-ID: <20120613010238.GA540@pista> (sfid-20120613_030245_564020_A81803E0)
References: <1339533979-32084-1-git-send-email-c_tpeder@qca.qualcomm.com>
 <1339534531.4501.3.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1339534531.4501.3.camel@joe2Laptop>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 12, 2012 at 01:55:31PM -0700, Joe Perches wrote:
> On Tue, 2012-06-12 at 13:46 -0700, Thomas Pedersen wrote:
> > The ath6kl firmware can filter scan results based on rssi. This is
> > useful to limit hosts wakeups on scheduled scans.
> []
> > diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
> > index 6f20998..4f20693 100644
> > --- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
> > +++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
> > @@ -3267,6 +3267,16 @@ static int ath6kl_cfg80211_sscan_start(struct wiphy *wiphy,
> >  			return ret;
> >  	}
> >  
> > +	if (test_bit(ATH6KL_FW_CAPABILITY_RSSI_SCAN_THOLD,
> > +		     ar->fw_capabilities)) {
> > +		ret = ath6kl_wmi_set_rssi_filter_cmd(ar->wmi, vif->fw_vif_idx,
> > +						    request->rssi_thold);
> 
> poor argument alignment.
> 
> > +		if (ret) {
> > +			ath6kl_err("failed to set RSSI threshold for scan");
> 
> missing newline termination.

Rats. Thanks Joe.

Thomas
