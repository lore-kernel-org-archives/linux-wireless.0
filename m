Received: from lahtoruutu.iki.fi (lahtoruutu.iki.fi [185.185.170.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAEEB47CC67;
	Tue, 22 Sep 2026 11:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=185.185.170.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790077421; cv=pass; b=UWRovbnAp00v07TgUD2rJLZvFaQTevqOkoYNWJwfNxKwSv7EHY2f46GG2rK60P0dSTx+ij6jq2XrSiiy6PA8keng68Kx/qwUIg8STUzfV5wmKi2BMGKx3XSJMxUQOHQ8zPkcSqmDGUx2UlkPrs2EFJU1H+QlHuf/MpQFhnc+VAw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790077421; c=relaxed/simple;
	bh=kSDLKQ3fFz6Q2v+DGB/iXJKvLM0o4PsJsvctLJETZpc=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=cQMLp0sKH/kslQUICV/c0NMJNcfA1NCAh8T3UvDnW7AHSQuA0KB2al5HjwMRhILaJQ63UZUXE8dGNmrCfLhA4NO1oBSVllxhyuI7D7PI/3H4C8ImrHFT0lnqGhiIsAQmmkXghz7XUh+NhSRkgan5DbsXACdm5na8A9JPE/7Ey3U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi; spf=pass smtp.mailfrom=iki.fi; dkim=pass (2048-bit key) header.d=iki.fi header.i=@iki.fi header.b=qUEqdHYI; arc=pass smtp.client-ip=185.185.170.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iki.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iki.fi header.i=@iki.fi header.b="qUEqdHYI"
Received: from fauth-c2-smtp.messagingengine.com (fauth-c2-smtp.messagingengine.com [204.75.18.201])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: jmtilli)
	by lahtoruutu.iki.fi (Postfix) with ESMTPSA id 4hpysb40S4z49Pxq;
	Tue, 22 Sep 2026 14:43:31 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi; s=lahtoruutu;
	t=1790077412;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HDCJSXoI0WbQ0p3ihA1hkvhJFyDcDNp+TMZs8wSGHg4=;
	b=qUEqdHYIF7fA4Tca/903IzrekZXn5/glnh2FFa5Um1E5x55MCwkv7r8pfOPGw3eKBWc0SY
	cWWvDZIB14ZsIn6uFm57bfSk0v/a7/akqFWGXe+7i7luAJKQS+LgAtQXjRmnjnnuCaE1ST
	4iVV/bIzpQrjL63UN1/AcsTXjpygD8LxRdoPIQsko/GHTGvhzPq4cjqh6za7AU0JQPQOEl
	24hfwHk+QIjrlSoMFkFFTPoifuZJXhQg3ViUPeaaZPbwA1DoWwUFT2RzyBcptGSAL07fwE
	mJBYYX9zGpHqIsSpLLLdQcqjiN3uAZHloXgEh81ndWf/522xC2ADTzsqC7T2aA==
ARC-Seal: i=1; a=rsa-sha256; d=iki.fi; s=lahtoruutu; cv=none; t=1790077412;
	b=k6NBgY5kLTlUAphNIBBMkE+kYrNiXBuTkQgzF/OZXI0A7tZdrMwZrG5wtl0JIevtnsC6fy
	NvwSqje6YmyBlnGnrXN5b1Bd5doto4LYzgSetUCHBkZLfVGSuIIWMaGRlaAxFIBNHz8daw
	o34f6/QNmms3mPKN3iDrqjOFNZno/rWhk9Z65XlVYfYK2Yh9GxDDfh3f8vhbV+4SMm+yTl
	Fn+rDXYHqqc9gHM4KFov7jEEVZpIJ+9Ay2IwJEZVdhNtDxrzNIHiO4EK5TtTgAaQIszQu1
	l2n6wNNdBhWq01buuRSicleo45cnf1hoSPPoMXyEWnpiYDZiGRdcbokEUjmwXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi;
	s=lahtoruutu; t=1790077412;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HDCJSXoI0WbQ0p3ihA1hkvhJFyDcDNp+TMZs8wSGHg4=;
	b=mLofDnIX0DDtUTiy4UJY97SkRAkHo4+Enf2gHhItbHVh/W92QClCKt8TXFRiodLjKKV/vz
	xjGkB2kx8OGm1w7hFGU0my51kdp0TUZEHGw8ztlK4fOpJulyMQvew4mKw7mcBoCA5zdQKC
	NuMzMVe3xSCJhF0011njhZ7xQR+Ya7AxUP8iylKFqrPuvtYNkqna47QNeiLRwpJf/g1+Dv
	aUl5nusQTPmXBSlOE5xt9ZJc2NhtVNiio+x5pZ03df4HCBRFDNkM7Svf/lTPsvR4HapaC+
	7CBh+UH5iC91Pjsv2wletqIuCtSNvtmM7yyT41zpnpQ2CDI4JeTCe8liJwz5Tw==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=jmtilli smtp.mailfrom=juha-matti.tilli@iki.fi
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 794151980062;
	Tue, 22 Sep 2026 07:43:30 -0400 (EDT)
Received: from ams-imap-13 ([10.64.2.33])
  by ams-compute-02.internal (MEProxy); Tue, 22 Sep 2026 07:43:30 -0400
X-ME-Sender: <xms:32myatg49o2er3dLEHE4r7I9rXsYaGObsp32cn7WyFIZ8RMCdYb-qg>
    <xme:32myas0Xlzs7SINZs582WaVh3NHceaIt_mfkk9PrpgJZ0sjaIll1l3HZRWoRGBNM5
    BMbO2czBXLn0qo2YVS27LFjostcQP_vP4_8DYAs49WB2PTs8c47nfdx>
X-ME-Proxy-Cause: dmFkZTEtbiTwXaJq8lyTxx63pXM8gv6tRPzvjR2XlgYzsPY53oPiafl5LAiPT+3EqcPRxj
    v+lnvvbg4B8Av2KIvQrtjz0yr+Yq5f7CFnPLCrFT2IdzdKDplNdf8L8t7MZx3Cd/fIDKRA
    s8ZACR28W2YjgpG0ngf+cr56Qgak+Lbi068lHJIEZWBixODjiI1oxDGT4AxdKTzzYaJL/z
    jecy55fw/Ba0ydPGzUnkf7k8Xd2WKon0j+ZdBjpgyCnv5XBP0lEqPIChyId3c/E70ctqLW
    ezkbv0P3olAwKi8GjrrFnskjocGLPncShuhlmTHbIlPxm5wc+VsIYo4qDP3LRm60ZhxrRU
    UQG+3ayrCDzbUcm0I/qAM9LTWJXZLqJhUiHnvcCn0crK92EN48dWQbzKVxFWK6UqAYb1Ok
    cotm9QPvuoD56VyyhLXJxuknc5itdvROGsFq3e2LaFnjciBYsgDaDvCtROBhps7EwFg5dE
    yLxz9saybj0Ru87aZmKqTgp1073H2oEdLV/hJJyzVWl/UYJmvg8VxnM5+YaH6bI+BX9LBz
    Sm90ijWfu3nY/1tXOMQt6xMt4pDtaM+HwWxJhOXsXtI8DpmPoJNWIR/le2GLmSJBttPEBw
    E1lzIwDeQWRCwG40xq115NO2pqU7gWGrNVaNEVMvpzupOEaKf75gmaBS0r0A
X-ME-Proxy: <xmx:4mmyauydh2N1Y6AboU5ILm0kGpsGkeUyAWIrQk4BPNDxzZPh4TNfeQ>
    <xmx:4mmyakzt6yCgAfqi5gpyTsC75SC8YC0XdoVNMXRrxDjyOEwJJEuGHw>
    <xmx:4mmyatTu2-u8iMHX_oChV13_xnlwREiNIeABWz4ReB1xVEqwAw1YGg>
    <xmx:4mmyanPvEyQ1Y3PO_u0I9QwNqDtPpw7x5Al8EF_ZHOmQ-sgIRRqFlA>
    <xmx:4mmyaoSJYJL9gXz42aPZALcY5cbEB_PMn2dlcjywAGEGIDjHliwnWCCo>
Feedback-ID: i02414972:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 6F7D7F80089; Tue, 22 Sep 2026 07:43:27 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: AtmlxWozq_rN
Date: Tue, 22 Sep 2026 14:43:05 +0300
From: "Juha-Matti Tilli" <juha-matti.tilli@iki.fi>
To: "Manivannan Sadhasivam" <manivannan.sadhasivam@oss.qualcomm.com>,
 "Manivannan Sadhasivam" <mani@kernel.org>,
 "David S . Miller" <davem@davemloft.net>,
 "Eric Dumazet" <edumazet@google.com>, "Jakub Kicinski" <kuba@kernel.org>,
 "Paolo Abeni" <pabeni@redhat.com>, "Simon Horman" <horms@kernel.org>,
 "Jeff Johnson" <jjohnson@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
 ath11k@lists.infradead.org, ath12k@lists.infradead.org,
 "Bjorn Andersson" <andersson@kernel.org>,
 "Chris Lew" <christopher.lew@oss.qualcomm.com>,
 "Deepak Kumar Singh" <deepak.singh@oss.qualcomm.com>,
 "Raj Kumar Bhagat" <raj.bhagat@oss.qualcomm.com>,
 "Jeff Hugo" <jeff.hugo@oss.qualcomm.com>
Message-Id: <e7e8a499-9e89-4efa-a99f-18ce7dc37ab5@app.fastmail.com>
In-Reply-To: <20260921-qrtr-multi-ep-v2-4-27dd80d841a0@oss.qualcomm.com>
References: <20260921-qrtr-multi-ep-v2-0-27dd80d841a0@oss.qualcomm.com>
 <20260921-qrtr-multi-ep-v2-4-27dd80d841a0@oss.qualcomm.com>
Subject: Re: [PATCH v2 4/4] wifi: ath12k: Connect to the QMI server belonging to the
 device owned by this driver
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Mon, Sep 21, 2026, at 14:23, Manivannan Sadhasivam via B4 Relay wrote:
> From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
> 
> When two identical ath12k PCIe devices are connected to the same host, both
> advertise the WLFW service with the same service and instance id. The QMI
> lookup reports both servers to each device, so a device may connect to the
> firmware running on the other device.
> 
> But now, QRTR provides each MHI endpoint a unique node id which is
> different from the node id announced by the device. So use the same id to
> pick the correct server. Add a get_qrtr_node_id() HIF callback that returns
> the node id derived from the MHI controller index and zero for transports
> that do not assign one. In the new_server callback, skip any service whose
> node id does not match. A node id of zero disables the check, so transports
> that do not assign one keep their current behavior.

Tested-by: Juha-Matti Tilli <juha-matti.tilli@iki.fi>
Tested-on: 2x WCN7850 hw2.0 WLAN.IOE_HMT.1.1-00018-QCAHMTSWPL_V1.0_V2.0_SILICONZ-1
Tested-on: 1x WCN6855 ath11k + 1x WCN7850 ath12k

I'm having some issues with regdb on ath12k cards so I had to test using
the low-frequency 2.4GHz channels. I tried updating linux-firmware to
20260810 to match my 6.12.110+multi-QRTR kernel, didn't help. The error
is:

ath12k_pci 0001:01:00.0: No reg rules available
ath12k_pci 0001:01:00.0: failed to extract regulatory info from received event
------------[ cut here ]------------
WARNING: CPU: 0 PID: 12 at /drivers/net/wireless/ath/ath12k/wmi.c:5841 ath12k_reg_chan_list_event+0x171/0x1e0 [ath12k]
Modules linked in: xt_gmmark(O) xt_bemark(O) w24e2identificator(O) qrtr_mhi ath12k mhi qmi_helpers mac80211 libarc4 cfg80211
CPU: 0 UID: 0 PID: 12 Comm: kworker/u8:0 Tainted: G           O       6.12.110-yocto-standard-gec77603762c7 #1
Tainted: [O]=OOT_MODULE
Hardware name: Freescale LS1021A
Workqueue: ath12k_qmi_driver_event ath12k_qmi_driver_event_work [ath12k]
Call trace: 
 unwind_backtrace from show_stack+0xb/0xc
 show_stack from dump_stack_lvl+0x35/0x40
 dump_stack_lvl from __warn+0xaf/0xb0
 __warn from warn_slowpath_fmt+0xe5/0xe8
 warn_slowpath_fmt from ath12k_reg_chan_list_event+0x171/0x1e0 [ath12k]
 ath12k_reg_chan_list_event [ath12k] from ath12k_wmi_op_rx+0x219/0xc08 [ath12k]
 ath12k_wmi_op_rx [ath12k] from ath12k_htc_rx_completion_handler+0x215/0x2d4 [ath12k]
 ath12k_htc_rx_completion_handler [ath12k] from ath12k_ce_recv_process_cb+0x149/0x198 [ath12k]
 ath12k_ce_recv_process_cb [ath12k] from ath12k_pci_ce_tasklet+0x13/0x28 [ath12k]
 ath12k_pci_ce_tasklet [ath12k] from tasklet_action_common+0x87/0xa8
 tasklet_action_common from handle_softirqs+0xbf/0x1b4
 handle_softirqs from irq_exit+0x55/0x78
 irq_exit from call_with_stack+0xd/0x10
---[ end trace 0000000000000000 ]---

This error happens with 2x ath12k and 1x ath12k 1x ath11k too.

But, the dual ath12k setup works, and the errors are entirely different
than what QRTR node id clash does.

So, I believe the patch works.

BR, Juha-Matti
