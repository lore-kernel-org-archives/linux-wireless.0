Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28295 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634AbaCUOiL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Mar 2014 10:38:11 -0400
Date: Fri, 21 Mar 2014 17:37:38 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Subject: Re: [PATCH v2] ath10k: add soft/hard firmware crash option to
 simulate_fw_crash
Message-ID: <20140321143737.GA5140@mwanda> (sfid-20140321_153817_277408_0C195448)
References: <20140313082431.10798.10888.stgit@potku.adurom.net>
 <87pplih81g.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87pplih81g.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 19, 2014 at 11:06:19AM +0200, Kalle Valo wrote:
> Hi Dan,
> 
> Kalle Valo <kvalo@qca.qualcomm.com> writes:
> 
> > From: Marek Puzyniak <marek.puzyniak@tieto.com>
> >
> > Command WMI_FORCE_FW_HANG_CMDID is not supported in firmware 10.1.
> > In order to have firmware crash simulation functionality also
> > in firmware 10.1 driver can force firmware crash by performing not allowed
> > operation. Driver can deliberately crash firmware when setting vdev param for
> > vdev id out of range.  This patch introduces two keywords to simulate_fw_crash:
> >
> > 'soft' which will cause firmware crash that is recoverable
> >        by warm firmware reset but supported only in main firmware.
> > 'hard' which will cause firmware crash recoverable by cold
> >        firmware reset, this option works for both firmwares.
> >
> > Commands to trigger firmware soft/hard crash:
> >
> > echo 'soft' > /sys/kernel/debug/ieee80211/phyX/ath10k/simulate_fw_crash
> > echo 'hard' > /sys/kernel/debug/ieee80211/phyX/ath10k/simulate_fw_crash
> >
> > kvalo: use strncmp(), remove '\n' before checking the command and
> > document how buf is null terminated
> >
> > Signed-off-by: Marek Puzyniak <marek.puzyniak@tieto.com>
> > Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
> 
> [...]
> 
> > @@ -479,14 +488,30 @@ static ssize_t ath10k_write_simulate_fw_crash(struct file *file,
> >  		goto exit;
> >  	}
> >  
> > -	ath10k_info("simulating firmware crash\n");
> > +	/* drop the possible '\n' from the end */
> > +	if (buf[count - 1] == '\n') {
> > +		buf[count - 1] = 0;
> > +		count--;
> > +	}
> >  
> > -	ret = ath10k_wmi_force_fw_hang(ar, WMI_FORCE_FW_HANG_ASSERT, 0);
> > -	if (ret)
> > -		ath10k_warn("failed to force fw hang (%d)\n", ret);
> > +	if (!strncmp(buf, "soft", sizeof(buf))) {
> > +		ath10k_info("simulating soft firmware crash\n");
> > +		ret = ath10k_wmi_force_fw_hang(ar, WMI_FORCE_FW_HANG_ASSERT, 0);
> > +	} else if (!strncmp(buf, "hard", sizeof(buf))) {
> > +		ath10k_info("simulating hard firmware crash\n");
> > +		ret = ath10k_wmi_vdev_set_param(ar, TARGET_NUM_VDEVS + 1,
> > +					ar->wmi.vdev_param->rts_threshold, 0);
> > +	} else {
> > +		ret = -EINVAL;
> > +		goto exit;
> > +	}
> 
> Fengguan's buildbot got warnings here and I assume they are coming from
> smatch:
> 
> drivers/net/wireless/ath/ath10k/debug.c:500 ath10k_write_simulate_fw_crash() error: strncmp() '"hard"' too small (5 vs 32)
> drivers/net/wireless/ath/ath10k/debug.c:497 ath10k_write_simulate_fw_crash() error: strncmp() '"soft"' too small (5 vs 32)
> 
> I wanted to use strncmp() instead of strcmp(), but I'm not sure what to
> do here. In my opinion it's guaranteed that the string "hard" is null
> terminated, so it shouldn't matter even if strlen("soft") (5) is less
> than sizeof(buf) (32), right? Or am I missing something here?
> 

I am on vacation until next week.  I didn't think these particular
emails went out automatically.  Anyway, I have changed this in the
latest smatch but it will take some months for the kbuild bot to update.

http://repo.or.cz/w/smatch.git/commitdiff/f10f27a7612c5b1e69b5d9080a0194d012beb6aa

I'll take a closer look next week.

regards,
dan carpenter

