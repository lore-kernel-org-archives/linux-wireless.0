Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DE0B13FEE
	for <linux-wireless@vger.kernel.org>; Thu,  2 Apr 2026 03:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775099407; cv=none; b=OKk/fHpfRALnqke8J+ieQQIHqBXkO2llGlGtdlzhluhslshs/0fp25g11t4+693WSI3y15X3CePpXNLkIG4CoHArTH3XT8k0Tuv3lLAapYYefl8u6kfuIdqJwo/sX61CYurStrgIbEv+JZ7csML02PflCs0kb4lelieCA5cxRGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775099407; c=relaxed/simple;
	bh=HRHzPLoAsORN7Q7I+Lzt1v8rVVqTUIgDhbdBFHKu0Fs=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=L5vPnq6t/uXq6h6YbX+uV0FjOH9MfLVpX1JvAra6C5HQl9isFW6h8mx1yJOOfp2ENkogivq9wD6Tam8cHQwv7gawCcw3YF/TgS+JjuxZ95O+/Kenq2/x1/lylTx42H0MqS2zzujE8o4QSJh1LgZcgGP1SrWBMv9hyQzvgg5eCLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=kFrH4I51; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="kFrH4I51"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 63239bPG22325734, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1775099377; bh=e3A3aUEXqJeScuMROUjBG01x2nX4hV9erxlbqnAiCpA=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=kFrH4I51IeFmt9Y45itzJoRQe1vl7OxSjjvCXH0G2us+EeLMqGANWhhpO/IsETIw8
	 Ajdb0ZR/MLPHQhj5rORLqLzNIkFyiKuqQuZ/sLTI3IF6fEDzz+ys4OgikH5pIdWDWI
	 PzJ5gIDCBY1yXIn0DyCjH3Rytdjdc4Sam+wqUj0E03NrIxtQOEzxWyYRSvfj5bEizY
	 FCgOsqNuimv6v0LTkpo58evIbQUV7WPdS1CVhUco4+sXJIBYeuoXx7jE+nCut08L4z
	 dDxiZEvCyZA4J7rSWUmzwJfaPoDYay2Et+Qu9grRbwxo6Xc+VoOLFQl8qObQOGZSAc
	 tdvHeSb8hkaIw==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.26/5.94) with ESMTPS id 63239bPG22325734
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 2 Apr 2026 11:09:37 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Thu, 2 Apr 2026 11:09:33 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS05.realtek.com.tw
 (10.21.1.55) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1748.10 via Frontend
 Transport; Thu, 2 Apr 2026 11:09:27 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Lucid Duck <lucid_duck@justthetip.ca>, <pkshih@realtek.com>
CC: <linux-wireless@vger.kernel.org>, <rtl8821cerfe2@gmail.com>,
        <morrownr@gmail.com>, Lucid Duck <lucid_duck@justthetip.ca>
Subject: Re: [PATCH v5] wifi: rtw89: usb: fix TX flow control by tracking in-flight URBs
In-Reply-To: <20260330025959.399018-1-lucid_duck@justthetip.ca>
References: <20260323233347.158745-1-lucid_duck@justthetip.ca> <20260330025959.399018-1-lucid_duck@justthetip.ca>
Message-ID: <8abb4220-a97a-4075-ace3-788017d1f1dc@RTKEXHMBS05.realtek.com.tw>
Date: Thu, 2 Apr 2026 11:09:27 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Lucid Duck <lucid_duck@justthetip.ca> wrote:

> rtw89_usb_ops_check_and_reclaim_tx_resource() returns a hardcoded
> placeholder value (42) instead of actual TX resource availability.
> This violates mac80211's flow control contract, preventing backpressure
> and causing uncontrolled URB accumulation under sustained TX load.
> 
> Fix by adding per-channel atomic counters (tx_inflight[]) that track
> in-flight URBs. Increment before usb_submit_urb() with rollback on
> failure, decrement in the completion callback, and return the
> remaining capacity to mac80211. The firmware command channel (CH12)
> always returns 1 since it has its own flow control.
> 
> The pre-increment pattern prevents a race where USB core completes the
> URB on another CPU before the submitting code increments the counter.
> 
> 128 URBs per channel provides headroom for RTL8832CU at 160 MHz
> bandwidth. Tested on RTL8852AU (USB3 80 MHz) where 64 and 128 showed
> equivalent throughput, and on RTL8832AU where 128 sustained full
> throughput under 8-stream parallel load.
> 
> Tested on D-Link DWA-X1850 (RTL8832AU), kernel 6.19.8, Fedora 43:
> 
>                      Unpatched -> Patched (128 URBs)
>   USB3 5GHz UL:      844 -> 837 Mbps (no regression)
>   USB3 5GHz retx:    3 -> 0
>   USB3 2.4GHz UL:    162 -> 164 Mbps (no regression)
>   4-stream UL:       858 -> 826 Mbps (within variance)
>   8-stream UL:       872 -> 826 Mbps (within variance)
>   UDP flood:         0% loss (690K datagrams)
>   60-second soak:    855 Mbps, 0 retransmits
> 
> Reported-by: morrownr <morrownr@gmail.com>
> Signed-off-by: Lucid Duck <lucid_duck@justthetip.ca>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

Failed to apply patch. Please rebase onto rtw.git rtw-next branch as footnote.

  Applying: wifi: rtw89: usb: fix TX flow control by tracking in-flight URBs
  Using index info to reconstruct a base tree...
  M	drivers/net/wireless/realtek/rtw89/usb.c
  M	drivers/net/wireless/realtek/rtw89/usb.h
  Falling back to patching base and 3-way merge...
  Auto-merging drivers/net/wireless/realtek/rtw89/usb.h
  CONFLICT (content): Merge conflict in drivers/net/wireless/realtek/rtw89/usb.h
  Auto-merging drivers/net/wireless/realtek/rtw89/usb.c
  error: Failed to merge in the changes.
  Patch failed at 0001 wifi: rtw89: usb: fix TX flow control by tracking in-flight URBs

Set patchset state to Changes Requested

[v5] wifi: rtw89: usb: fix TX flow control by tracking in-flight URBs

---
https://github.com/pkshih/rtw.git

