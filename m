Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.61
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792588521;
	b=H3MW0MWKo4BOYRY4ENCdl0yhIN4dSpWMjzu41886/zHq1rfnXH4nJSJh+CON6SxINlIu
	 SjdiPxf+UF1qZ2WA1v1gWyn33pjw2IjJUx53nyLvrLy10mDPQkCc2nyccKGQnS0j7t+Rw
	 lNBWyZr275gM0tXzj6OsIZvb1a20D/n6PQPUOfHJ6O0G7FgoJjMId+Nz/qHb9PTDtNnE9
	 Z0ZkMA/ZPwQCNPZwG2x6GFxrwQ7i5sxmAhYYQx3QXfnecPLCS17o6brY8iYf56jd/hjCZ
	 cAymM/gHmCFRYBiu0Mco/ibipFY3p2Lc0Dn6ie58+cvoH5XMtDuZSIG0eDTGNeB6N/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792588521;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:MIME-Version:Date:Content-Type:
	 Content-Transfer-Encoding:From:Message-ID:TLS-Required:Subject:To:Cc:
	 In-Reply-To:References;
	bh=25tT0iWAaza7QxGD2QYScSMgIohEN6wH5AsbhN95NF0=;
	b=U2hVreDd8i7dd4tQJxKL0+Hkl+wQ7nRx4n8qpHuaGjDXrQFpdNBu+F3ijvSrg1srgu0V
	 27lAZIpJ3+QvXgPxBZyWUNBWjd7xlArU1OR8MgryIKNkPuUVr+ubVtzFutlbcIqOE98R8
	 8+JRjxNfnXW4xKnb0YmCm7Q9CUT1VhBIctzcw6uK1jokCnx+xIHILJsWpTc/u0IbMXPWd
	 6Jd2aUc0g7X7EzPMwnjccpB0lFyFSeLBecC/EYMnSTo91btplO6xVxurXIbgpX1VaOwV3
	 ZRO4Vyr9HXgQGEj/W0GhRLookkVj8nCu8qp4KLW5HQ8X4ICwtcbsOVseCth2g8uY19A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	arc=none smtp.remote-ip=95.215.58.61
Received: from mta1.migadu.com (out-61.mta1.migadu.com [95.215.58.61])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3184606A319
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 13:15:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C3184606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=6Qz2Ilvep7wV32LmbUggAolqH0DqXa97icyiQTw6Km8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792588511; v=1; x=1793193311;
 b=xUSrS+OFrGJFVVvqlbdQjc4+H/uAbm7viQrHs1gFLbGlcSeL9VIsoY6jOIZQYxQ7/vnZFXY/
 pgP0d8ecrN9ffd+a02H4MSy+9WKUOCII9DhH5eBa8LheNnh//dM/3v7vX7/CJkLosLqgk5NXQPh
 h1F5FX9dtP65+0a/Dvam/FcQ=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 8513f95346aa54ba;
	Wed, 21 Oct 2026 13:15:10 +0000
X-Mizu-Trace-ID: 8513f95346aa54ba
X-Migadu-Flow: FLOW_OUT
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Date: Wed, 21 Oct 2026 13:15:10 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Luka Gejak" <luka.gejak@linux.dev>
Message-ID: <d62975cc45c5b17a85f1e5cb7f9c1e326f27ffa5@linux.dev>
TLS-Required: No
Subject: Re: [PATCH rtw-next v4] wifi: rtw88: pci: wake the TX queues after
 restart_hw and interface up
To: "Abdurrahman Karadag" <abdurrahmankaradag19@gmail.com>,
 linux-wireless@vger.kernel.org
Cc: pkshih@realtek.com, linux-kernel@vger.kernel.org, rtl8821cerfe2@gmail.com
In-Reply-To: <20261021101315.1974894-1-abdurrahmankaradag19@gmail.com>
References: <20261021101315.1974894-1-abdurrahmankaradag19@gmail.com>

October 21, 2026 at 12:13 PM, "Abdurrahman Karadag" <abdurrahmankaradag19=
@gmail.com> wrote:

> Wake only when a ring was recorded as stopped:
> mac80211 keeps a single non-refcounted DRIVER stop per queue, so an
> unconditional wake here would also release the stop that
> rtw_hw_scan_start() takes before it reaches rtw_pci_start() from idle.

The gated wake still releases that stop when a ring was left stopped. A
stalled ring followed by a disconnect keeps queue_stopped set through
rtw_enter_ips(), and the next scan from idle then does:

        rtw_hw_scan_start()
          ieee80211_stop_queues()
          rtw_core_scan_start()
            rtw_leave_ips()
              rtw_core_start()
                rtw_pci_start()
                  ieee80211_wake_queues()

Nothing transmits in idle, so this is harmless, but the v3 thread settled
on saying the wake can't be narrowed to the queue the ring-full path
stopped. Could the message say that, rather than suggest the gate keeps
the scan stop intact?

Other than that I have no objections with the code itself.

Best regards,
Luka Gejak
