Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64795 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754145Ab1LNETQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Dec 2011 23:19:16 -0500
Received: by yhr47 with SMTP id 47so1016783yhr.19
        for <linux-wireless@vger.kernel.org>; Tue, 13 Dec 2011 20:19:15 -0800 (PST)
Message-ID: <4EE823C0.7080205@lwfinger.net> (sfid-20111214_051922_517434_0E4D909D)
Date: Tue, 13 Dec 2011 22:19:12 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Franky Lin <frankyl@broadcom.com>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Some funny code in brcmsmac
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Franky,

I was looking through the code and noticed the following in routine 
wlc_phy_txpwrctrl_pwr_setup_nphy():

         if (pi->sh->sromrev < 4) {
		...
                 target_pwr_qtrdbm[0] = 13 * 4;
                 target_pwr_qtrdbm[1] = 13 * 4;
		...
         } else {
                 chan_freq_range = wlc_phy_get_chan_freq_range_nphy(pi, 0);
                 switch (chan_freq_range) {
                 case WL_CHAN_FREQ_RANGE_2G:
			...
                         target_pwr_qtrdbm[0] =
                                 pi->nphy_pwrctrl_info[0].max_pwr_2g;
                         target_pwr_qtrdbm[1] =
                                 pi->nphy_pwrctrl_info[1].max_pwr_2g;
			...

                         break;
                 case WL_CHAN_FREQ_RANGE_5GL:
			...
                         target_pwr_qtrdbm[0] =
                                 pi->nphy_pwrctrl_info[0].max_pwr_5gl;
                         target_pwr_qtrdbm[1] =
                                 pi->nphy_pwrctrl_info[1].max_pwr_5gl;
			...
                         break;
                 case WL_CHAN_FREQ_RANGE_5GM:
			...
                         target_pwr_qtrdbm[0] =
                                 pi->nphy_pwrctrl_info[0].max_pwr_5gm;
                         target_pwr_qtrdbm[1] =
                                 pi->nphy_pwrctrl_info[1].max_pwr_5gm;
			...
                         break;
                 case WL_CHAN_FREQ_RANGE_5GH:
			...
                         target_pwr_qtrdbm[0] =
                                 pi->nphy_pwrctrl_info[0].max_pwr_5gh;
                         target_pwr_qtrdbm[1] =
                                 pi->nphy_pwrctrl_info[1].max_pwr_5gh;
			...
                         break;
                 default:
			...
                         target_pwr_qtrdbm[0] = 13 * 4;
                         target_pwr_qtrdbm[1] = 13 * 4;
			...
                         break;
                 }
         }

         target_pwr_qtrdbm[0] = (s8) pi->tx_power_max;
         target_pwr_qtrdbm[1] = (s8) pi->tx_power_max;

After going to some effort to customize the target_pwr_qtrdbm array depending on 
the SPROM version and the particular channel being used, the array is 
unconditionally overwritten in the end. Although gcc probably optimizes out the 
statements that are not needed (I have not looked at the generated code.), 
perhaps the code should be modified to make it clearer for human readers.

Thanks,

Larry
