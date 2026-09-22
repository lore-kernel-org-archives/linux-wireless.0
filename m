Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A26043DEC3;
	Tue, 22 Sep 2026 13:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790083859; cv=none; b=uLRFnNbLLewwTlIwFcduOJpt5Omgc1XmfuvOBmMU5fou9zHYebdhJAGKzfXoo77W0Ld4CYmOB089jf5eubp9TOTxBDpa3totCnD2LxcPjwdae1+RCCGOEtI5fh0aMj/mOiX297xVPmNL/RJueSWK4EcJlXcJNprgIziKazMGZI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790083859; c=relaxed/simple;
	bh=pWk+vCHIJnjvD6e1PGCGftZo7Nq+trD74kNQogbeQyI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IKvl96a172g+5vpW7SxDtbUzao08QbHn/6SYF4Oyd+FLSy3se2ZVNxYsG6kA279U+SEz088R8UBNY9CWUyIGPRCyLWsSzC5iAUfwMOC8f7wxy5UZMAKWKmlyN0gXhu5jT5HXpXzTXnETFP01bAo88G/v4RNpLh+l7RWN86ptvqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WsFWXUnP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WsFWXUnP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88BF61F000FF;
	Tue, 22 Sep 2026 13:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790083857;
	bh=eZbT6bofTdrcKmONlOQZmDhDpogwkRooaTcmH+dj7Ik=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WsFWXUnP8NJVnX0eK28aiT7KS95kdrLG0pScdcm5eDf+dFcDv4a1g8FAVTo5Wm5Eq
	 GEwbruXLERl1GXQQcnd2h4mpiYdxVI6/a/JbLc7htw7f53T9A85W2+3XYlm/Co090L
	 glSGKATH79oJe1Fw69eI+zPzntl9rpUaCEfRLMHbCdERSkSiXbi2uXpJW7yg/J7o0H
	 Lv68lAtn/8dCIDvbRKMAgdaKO7IeF0HRZH670xonOyBPVynsbW3Ek3E7vCWHh/ZLC5
	 0bRxs/2CfZ1UTKv+MrnbfOSlFVSi4T3jsqZh8WM8ucork6iOamSVE8Wb5jrZIivjbe
	 q65xIIOZaiqUQ==
Date: Tue, 22 Sep 2026 15:30:48 +0200
From: Manivannan Sadhasivam <mani@kernel.org>
To: Juha-Matti Tilli <juha-matti.tilli@iki.fi>
Cc: "David S . Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Jeff Johnson <jjohnson@kernel.org>, linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org, ath11k@lists.infradead.org, 
	ath12k@lists.infradead.org, Bjorn Andersson <andersson@kernel.org>, 
	Chris Lew <christopher.lew@oss.qualcomm.com>, Deepak Kumar Singh <deepak.singh@oss.qualcomm.com>, 
	Raj Kumar Bhagat <raj.bhagat@oss.qualcomm.com>, Jeff Hugo <jeff.hugo@oss.qualcomm.com>
Subject: Re: [PATCH v2 4/4] wifi: ath12k: Connect to the QMI server belonging
 to the device owned by this driver
Message-ID: <g63vg7ho5al6f2hfxbgssrisnjl5ui6isxlrv3265ocatvdmay@anmhz3vcxcbo>
References: <20260921-qrtr-multi-ep-v2-0-27dd80d841a0@oss.qualcomm.com>
 <20260921-qrtr-multi-ep-v2-4-27dd80d841a0@oss.qualcomm.com>
 <e7e8a499-9e89-4efa-a99f-18ce7dc37ab5@app.fastmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e7e8a499-9e89-4efa-a99f-18ce7dc37ab5@app.fastmail.com>

On Tue, Sep 22, 2026 at 02:43:05PM +0300, Juha-Matti Tilli wrote:
> On Mon, Sep 21, 2026, at 14:23, Manivannan Sadhasivam via B4 Relay wrote:
> > From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
> > 
> > When two identical ath12k PCIe devices are connected to the same host, both
> > advertise the WLFW service with the same service and instance id. The QMI
> > lookup reports both servers to each device, so a device may connect to the
> > firmware running on the other device.
> > 
> > But now, QRTR provides each MHI endpoint a unique node id which is
> > different from the node id announced by the device. So use the same id to
> > pick the correct server. Add a get_qrtr_node_id() HIF callback that returns
> > the node id derived from the MHI controller index and zero for transports
> > that do not assign one. In the new_server callback, skip any service whose
> > node id does not match. A node id of zero disables the check, so transports
> > that do not assign one keep their current behavior.
> 
> Tested-by: Juha-Matti Tilli <juha-matti.tilli@iki.fi>
> Tested-on: 2x WCN7850 hw2.0 WLAN.IOE_HMT.1.1-00018-QCAHMTSWPL_V1.0_V2.0_SILICONZ-1
> Tested-on: 1x WCN6855 ath11k + 1x WCN7850 ath12k
> 
> I'm having some issues with regdb on ath12k cards so I had to test using
> the low-frequency 2.4GHz channels. I tried updating linux-firmware to
> 20260810 to match my 6.12.110+multi-QRTR kernel, didn't help. The error
> is:
> 
> ath12k_pci 0001:01:00.0: No reg rules available
> ath12k_pci 0001:01:00.0: failed to extract regulatory info from received event
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 12 at /drivers/net/wireless/ath/ath12k/wmi.c:5841 ath12k_reg_chan_list_event+0x171/0x1e0 [ath12k]
> Modules linked in: xt_gmmark(O) xt_bemark(O) w24e2identificator(O) qrtr_mhi ath12k mhi qmi_helpers mac80211 libarc4 cfg80211
> CPU: 0 UID: 0 PID: 12 Comm: kworker/u8:0 Tainted: G           O       6.12.110-yocto-standard-gec77603762c7 #1
> Tainted: [O]=OOT_MODULE
> Hardware name: Freescale LS1021A
> Workqueue: ath12k_qmi_driver_event ath12k_qmi_driver_event_work [ath12k]
> Call trace: 
>  unwind_backtrace from show_stack+0xb/0xc
>  show_stack from dump_stack_lvl+0x35/0x40
>  dump_stack_lvl from __warn+0xaf/0xb0
>  __warn from warn_slowpath_fmt+0xe5/0xe8
>  warn_slowpath_fmt from ath12k_reg_chan_list_event+0x171/0x1e0 [ath12k]
>  ath12k_reg_chan_list_event [ath12k] from ath12k_wmi_op_rx+0x219/0xc08 [ath12k]
>  ath12k_wmi_op_rx [ath12k] from ath12k_htc_rx_completion_handler+0x215/0x2d4 [ath12k]
>  ath12k_htc_rx_completion_handler [ath12k] from ath12k_ce_recv_process_cb+0x149/0x198 [ath12k]
>  ath12k_ce_recv_process_cb [ath12k] from ath12k_pci_ce_tasklet+0x13/0x28 [ath12k]
>  ath12k_pci_ce_tasklet [ath12k] from tasklet_action_common+0x87/0xa8
>  tasklet_action_common from handle_softirqs+0xbf/0x1b4
>  handle_softirqs from irq_exit+0x55/0x78
>  irq_exit from call_with_stack+0xd/0x10
> ---[ end trace 0000000000000000 ]---
> 
> This error happens with 2x ath12k and 1x ath12k 1x ath11k too.
> 
> But, the dual ath12k setup works, and the errors are entirely different
> than what QRTR node id clash does.
> 
> So, I believe the patch works.
> 

Thanks a lot for testing. I asked our WLAN team member to test this series on
multi-ath12k setup and found one issue with QRTR_TYPE_RESUME_TX. After fixing
it, multi-ath12k setup works fine.

I'll submit v3 with that fix. Please give it a shot on this setup, one final
time :) Appreciate your help here.

- Mani

-- 
மணிவண்ணன் சதாசிவம்
