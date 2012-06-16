Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:57038 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755426Ab2FPCW1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jun 2012 22:22:27 -0400
Received: by gglu4 with SMTP id u4so2848840ggl.19
        for <linux-wireless@vger.kernel.org>; Fri, 15 Jun 2012 19:22:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAH5vBdJJzru9=s9KtPbbnPMWGQBrCPsxcgtOYSmhzPD5=6YNPw@mail.gmail.com>
References: <bug-2338-2785@http.bugzilla.intellinuxwireless.org/>
 <20120607161818.241F322210D14@mail.opensource.intel.com> <CAH5vBdK0a_R_4PXcVqUrkak9MStQJR+z6-P+L8dbLHnWz-vCYg@mail.gmail.com>
 <CAH5vBdJJzru9=s9KtPbbnPMWGQBrCPsxcgtOYSmhzPD5=6YNPw@mail.gmail.com>
From: cheng renquan <crquan@gmail.com>
Date: Fri, 15 Jun 2012 19:22:05 -0700
Message-ID: <CAH5vBdLaQXU47-aC4pdTjfXQV1cmtmwD+66mYCotbVFjn3VoJA@mail.gmail.com> (sfid-20120616_042231_070034_2A5903C1)
Subject: Re: [Bug 2338] unstable roaming (WPA2 Enterprise encryption + domain
 user/pass authentication)
To: Meenakshi V <meenakshi.venkataraman@intel.com>
Cc: ilw@linux.intel.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

can we make this line not printing so frequently?

drivers/net/wireless/iwlwifi/iwl-agn-rs.c:603:rate_n_flags_from_tbl

                if (use_green) {
                        rate_n_flags |= RATE_MCS_GF_MSK;
                        if (is_siso(tbl->lq_type) && tbl->is_SGI) {
                                rate_n_flags &= ~RATE_MCS_SGI_MSK;
                                IWL_ERR(priv, "GF was set with SGI:SISO\n");
                        }
        	}
        }
        return rate_n_flags;
}


In kernel v3.4.0 with home WPA wifi, it's now printing almost every second,
overflowing kernel msg log buffer very soon,

with this .config:

$ grep IWLWIFI .config
CONFIG_IWLWIFI=m
CONFIG_IWLWIFI_DEBUG=y
# CONFIG_IWLWIFI_DEBUG_EXPERIMENTAL_UCODE is not set
CONFIG_IWLWIFI_DEVICE_TRACING=y
# CONFIG_IWLWIFI_P2P is not set
# CONFIG_IWLWIFI_EXPERIMENTAL_MFP is not set

But at this moment, the wifi is working ok, seems no any problem

[247044.692749] iwlwifi 0000:03:00.0: GF was set with SGI:SISO
[247045.449760] iwlwifi 0000:03:00.0: GF was set with SGI:SISO
[247046.476281] iwlwifi 0000:03:00.0: GF was set with SGI:SISO
[247047.224943] iwlwifi 0000:03:00.0: GF was set with SGI:SISO
[247047.249201] iwlwifi 0000:03:00.0: GF was set with SGI:SISO
[247047.252083] iwlwifi 0000:03:00.0: GF was set with SGI:SISO
[247048.101599] iwlwifi 0000:03:00.0: GF was set with SGI:SISO
[247051.325215] iwlwifi 0000:03:00.0: GF was set with SGI:SISO
[247051.325229] iwlwifi 0000:03:00.0: GF was set with SGI:SISO
[247051.354703] iwlwifi 0000:03:00.0: GF was set with SGI:SISO
[247052.941342] iwlwifi 0000:03:00.0: GF was set with SGI:SISO
[247053.098138] iwlwifi 0000:03:00.0: GF was set with SGI:SISO
[247053.173333] iwlwifi 0000:03:00.0: GF was set with SGI:SISO
[247053.179197] iwlwifi 0000:03:00.0: GF was set with SGI:SISO
[247053.191748] iwlwifi 0000:03:00.0: GF was set with SGI:SISO
[247053.455591] iwlwifi 0000:03:00.0: GF was set with SGI:SISO
[247053.458575] iwlwifi 0000:03:00.0: GF was set with SGI:SISO
[247054.465627] iwlwifi 0000:03:00.0: GF was set with SGI:SISO
[247057.488204] iwlwifi 0000:03:00.0: GF was set with SGI:SISO
[247058.095448] iwlwifi 0000:03:00.0: GF was set with SGI:SISO
[247058.167588] iwlwifi 0000:03:00.0: GF was set with SGI:SISO
