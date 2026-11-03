Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=211.75.126.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793676484;
	b=p8uT3y1Ws7vIE9s7w/j0+V4D74cmKcVox5HgCV/r/T2/TWOCCtSqq1k6pNbXU68Xw1G6
	 9vTCmRWRKY3+Ebpjz6ydLPb9UluJDD/BZXNP7rwvmIgRzkhou/bGzHhaHfO0pfEkCr8AO
	 JB+whu4DbRFXVeIkoV4chB842xUc0E/eY8T+59cdS1LRGNdnUP5ozzPe8AR01D1x3xL9y
	 0oqn2UBHm5vnBb1dU4BuSN/h76Cfz5yA808Wdc4aKprbaW6vrJ1Bl92B89C7K0nI4F/pc
	 uejcjrjX7w4Ah36kv+LgofUczcDmSrr8fHOzDQ9N5M2fF0ifU/vK3m5apm3t6Aor8tg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793676484;
	h=DMARC-Filter:X-SpamFilter-By:DKIM-Signature:Received:Received:
	 Received:Received:From:To:CC:Subject:In-Reply-To:References:
	 Message-ID:Date:MIME-Version:Content-Type;
	bh=HP7LPkwvSoSPN0CR18xnY35CqpczR57UM85JND3y8jQ=;
	b=BtEuMSxIRDXsFmmQ1siE+Wz9Gy32zwKoPVNcuZ9b0S8lfu19fP/J8p9UR9AP3812bu8Q
	 bkOFiR/njuD20vWZIEwSlTn0XVHQtUOAGiR/W7K31X3mD4yOWVsIKAwWuHtX4DCFFFYEr
	 K100hg31PwTyNP8D1p3BucXyUvmwLOlWZy4c3tVzrSzIjDrTKr8hEbXYpKnShcG+mV1aP
	 DdrU8cdSBJ3MfGwKMuTR2iO5Ix4ZYl9q6iQIL9Efckw+t26lTgEohQzmXWErOLknpX8li
	 qLD7GvNI1fzfBb6wTrIpEIqFw5fp9AoNbIe9g3tTDuTCr6nZw6LjlnMfRCBChC86xSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=realtek.com;
	spf=pass smtp.mailfrom=realtek.com;
	dkim=pass header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=f5QobS1y;
	arc=none smtp.remote-ip=211.75.126.72
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B6E6606A324
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 03:28:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2B6E6606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=f5QobS1y
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6A33Rx6U22700003, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1793676479; bh=HP7LPkwvSoSPN0CR18xnY35CqpczR57UM85JND3y8jQ=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=f5QobS1yA7fc99utjnWPMyNwCvo6jRAVbXCpSpBCB3+wuoLru4Mc8sUv+L384lrNa
	 91hLUm8RRPwtwYC18RV98HT+FWStr7nCQF16Ku6+alWtuAOE4YTJa/u3MaMKYyuE4L
	 LSRRNS+fyDQlRrq6vLqBlDChlFRK+RtojiGyFOk1JRBwcvkUTyXESLsQ1wpBP9CjuT
	 QxaKmegw3EnRoc8Yy2iJC5YL+cUGx/yP+t/7I8DDUCSyAyQv/kuAz1G4tuya/RHRvA
	 BiLzb4HzEBo+xkeipv93JDHJHbS0A3J4q3jj7YwzsQD+etxF25CU7flcpwFRikz/6C
	 jPsD3JVm4TSYQ==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6A33Rx6U22700003
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 3 Nov 2026 11:27:59 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 3 Nov 2026 11:27:59 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 3 Nov 2026 11:27:59 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56 via Frontend
 Transport; Tue, 3 Nov 2026 11:27:59 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Josef Schlehofer <pepe.schlehofer@gmail.com>,
	<linux-wireless@vger.kernel.org>
CC: Ping-Ke Shih <pkshih@realtek.com>, Mohammed Afifi <i.mafifi17@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>
Subject: Re: [PATCH rtw-next v5] wifi: rtw88: usb: Download the reserved page synchronously
In-Reply-To: <20261013033737.6761-1-pepe.schlehofer@gmail.com>
References: <20261013033737.6761-1-pepe.schlehofer@gmail.com>
Message-ID: <f26bc77e-f1be-4a0f-a041-b02c771e2957@RTKEXHMBS06.realtek.com.tw>
Date: Tue, 3 Nov 2026 11:27:59 +0800
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain

Josef Schlehofer <pepe.schlehofer@gmail.com> wrote:

> From: Mohammed Afifi <i.mafifi17@gmail.com>
> 
> In AP mode the reserved page (which contains the beacon) is downloaded
> to the chip by rtw_fw_write_data_rsvd_page(). That function writes the
> data via rtw_hci_write_data_rsvd_page() and then immediately polls the
> hardware BCN_VALID bit to confirm the firmware accepted the beacon.
> 
> On USB, rtw_usb_write_data_rsvd_page() ends up in rtw_usb_write_port(),
> which submits the URB with usb_submit_urb() and returns as soon as the
> transfer is queued. The completion callback only frees the skb. As a
> result the BCN_VALID poll can run while the beacon is still in flight
> on the bus, and the poll times out even though the download itself is
> fine.
> 
> This shows up as:
> 
>   rtw_8822bu: error beacon valid
>   rtw_8822bu: failed to download drv rsvd page
> 
> The failure is intermittent because the poll retries sometimes cover
> the transfer time. It occurs in bursts when something triggers repeated
> beacon updates, such as stations associating and disassociating.
> 
> Fix this by making rtw_usb_write_data() wait for the URB to complete
> when it's called from rtw_usb_write_data_rsvd_page(). The new
> rtw_usb_write_port_sync() waits the same way usb_bulk_msg() does: if
> the URB doesn't complete within 5 seconds, it is killed before the
> function returns, so the completion handler can't run after that.
> usb_bulk_msg() itself is not used because it can't set URB_ZERO_PACKET,
> which rtw_usb_write_port() sets for every bulk out transfer.
> 
> Only the reserved page path is made synchronous; the normal data TX
> path and the H2C path are left untouched, so throughput is unaffected.
> The chips with a 3081 WCPU also download their firmware through
> rtw_usb_write_data_rsvd_page(), so those chunks are now sent
> synchronously as well.
> 
> The reserved page download runs in process context under rtwdev->mutex,
> so sleeping there is safe.
> 
> Closes: https://github.com/lwfinger/rtw88/issues/451
> Signed-off-by: Mohammed Afifi <i.mafifi17@gmail.com>
> Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
> Co-developed-by: Josef Schlehofer <pepe.schlehofer@gmail.com>
> Signed-off-by: Josef Schlehofer <pepe.schlehofer@gmail.com>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

1 patch(es) applied to rtw-next branch of rtw.git, thanks.

a0756232e960 wifi: rtw88: usb: Download the reserved page synchronously

---
https://github.com/pkshih/rtw.git

