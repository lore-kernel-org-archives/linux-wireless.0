Received: from mta1.migadu.com (out-246.mta1.migadu.com [95.215.58.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E1404DF4C7
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 09:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.246
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791970928; cv=none; b=WaOUg8176nExptaA5Wn4bUEYd4GEpclrVZH9nqhthvSPCIXP9NZQ4bldm2aTcgXMeOWdDYFr0np/0cEko6KzCW4xwITKs+u7Er5dNkH5tTY4zNRbewVDyiIcQJVzEq7nH4HByzakkQeg8C6582UG9K8f++HkgpY1hwMdJG1Yd98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791970928; c=relaxed/simple;
	bh=uqtRq22guiVeugkWbdaQ03+jc67CIoBpWl0b8DPULV4=;
	h=Mime-Version:Content-Type:Date:Message-Id:To:Cc:Subject:From:
	 References:In-Reply-To; b=Wdl0brZiTKTYQxafxl/7nTNuh83yz/kY0Xlm5Ph7ChvcrQxOqU8eQ9mjtOzIKaHtn3pACI1oU0lL4bsW128u0hzHcfiQ965+Z5rBxq8EAUKg/+82sBwhNQHkm4ZXZJSHh+mFfTEgG3WDV7m03i0Wr+0Nye6lad+ntcFd4p1xjUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Gq5H1pOU; arc=none smtp.client-ip=95.215.58.246
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Gq5H1pOU"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=uqtRq22guiVeugkWbdaQ03+jc67CIoBpWl0b8DPULV4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791970924; v=1; x=1792575724;
 b=Gq5H1pOUKY/FGhB1Qze5NX3hY0qGIZ5RFyDmDJ7E0pcEJJOjTcB1c9DiqCdR1Gw2DydF7OVm
 FDTiN11EMnSrDrq5OL3UObV+imNN5ynXGrYvqz+DBJ6RhzwmABm6ys+WrcqFnrKetAKTTwP/V4y
 VkxfqxgRAPrLs9ke/i/2BKRc=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 53d22616e6a5f879;
	Wed, 14 Oct 2026 09:42:04 +0000
X-Mizu-Trace-ID: 53d22616e6a5f879
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 14 Oct 2026 09:42:04 +0000
Message-Id: <DM4GODU3YQTM.25D25F2A98RO8@linux.dev>
To: "Abdurrahman Karadag" <abdurrahmankaradag19@gmail.com>,
 <linux-wireless@vger.kernel.org>
Cc: <pkshih@realtek.com>, <linux-kernel@vger.kernel.org>,
 <rtl8821cerfe2@gmail.com>
Subject: Re: [PATCH rtw-next v3] wifi: rtw88: wake the TX queues after
 ieee80211_restart_hw()
From: "Luka Gejak" <luka.gejak@linux.dev>
X-Mailer: aerc 0.22.0
References: <20261013220726.38031-1-abdurrahmankaradag19@gmail.com>
In-Reply-To: <20261013220726.38031-1-abdurrahmankaradag19@gmail.com>

Hi Abdurrahman,

On Tue Oct 13, 2026 at 10:07 PM UTC, Abdurrahman Karadag wrote:
> @@ -882,8 +882,10 @@ static void rtw_reconfig_complete(struct ieee80211_h=
w *hw,
>       struct rtw_dev *rtwdev =3D hw->priv;
>
>       mutex_lock(&rtwdev->mutex);
> -     if (reconfig_type =3D=3D IEEE80211_RECONFIG_TYPE_RESTART)
> +     if (reconfig_type =3D=3D IEEE80211_RECONFIG_TYPE_RESTART) {
>               clear_bit(RTW_FLAG_RESTARTING, rtwdev->flags);
> +             ieee80211_wake_queues(hw);
> +     }
>       mutex_unlock(&rtwdev->mutex);

This looks right to me for the restart case. After rtw_pci_stop() the ring =
is
empty and rewound, so nothing is left to complete and the wake in
rtw_pci_tx_isr() can never run.

One thing I am not sure about. The same callback runs with
IEEE80211_RECONFIG_TYPE_SUSPEND after a plain resume, and the wake is skipp=
ed
there. I could not find anything that clears the driver stop reason except =
the
driver itself, and rtw_core_stop() goes through rtw_pci_stop() on the way
down, so a queue stopped by the ring-full path just before suspend looks li=
ke
it ends up in the same state. Is that reachable, or is it released somewher=
e I
missed?

Small thing for the commit message. ieee80211_wake_queues() releases every
queue with the driver reason, not just the one the ring-full path stopped, =
and
the offload scan and PCIe error paths use that reason as well. I think the =
first
sentence reads narrower than it is.

Best regards,
Luka Gejak
