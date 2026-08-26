Received: from mta1.migadu.com (out-227.mta1.migadu.com [95.215.58.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B5B737C90F
	for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2026 17:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787766829; cv=none; b=D0YQWPoUPl5IRWYQ6CsWwKiFsTA7jHbPQuhqPVkA61u5Pz5IkalyywPP/ko79jae4XB3IlJk4xRGTZEfBeJiXEEJlkuTII3zOHLhlSQ8Rt52E8bOYjJYu4xkSvC9clg3w2sPez5XFD9Uw4Ol6ei/ggT1eLa51VDkh2UQUmrPqCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787766829; c=relaxed/simple;
	bh=yk9ODX3xceydNwru1FVFIR8KFbH4LpdJgnjt0y/eGJ4=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=n7FiXh68FiIRlWkqB//IUxbdaziWbEsyRuBka3ElqbrYmWnrsxpXL7cIBj8jmtjb6HiIdVGqIyfWV2owmWX1djB0Nr1X6zZ3Q692DPukt6h4FGaQcle7yjMrAjVSfSHJ5HGGqhRfWyf4iL+S4UVnlZiFavdiimS44XczY/NffxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UvlmW/+L; arc=none smtp.client-ip=95.215.58.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UvlmW/+L"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=yk9ODX3xceydNwru1FVFIR8KFbH4LpdJgnjt0y/eGJ4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787766817; v=1; x=1788371617;
 b=UvlmW/+LYf+mNAI+r4r+2IEUcKrBwmE3vvqVzevzHN1RuxlLjYzkXjMgXa3SofqFFMEOTulY
 jzETP7FgyJpsnsrGQtz/ncdoZePbB9TNjEup8GJtn3hcPS1qrrFwNVjif2sOFikQpmmFbHYdpB5
 HDXoXxsqN3za53B3xDiAPf08=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: from ehlo.thunderbird.net (31.223.131.117)
	by smtp.migadu.com with ESMTPS id ab6d525f6dd6ddbd;
	Wed, 26 Aug 2026 17:53:27 +0000
X-Mizu-Trace-ID: ab6d525f6dd6ddbd
X-Migadu-Flow: FLOW_OUT
Date: Wed, 26 Aug 2026 19:53:22 +0200
From: Luka Gejak <luka.gejak@linux.dev>
To: Ping-Ke Shih <pkshih@realtek.com>, linux-wireless@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Michael Straube <straube.linux@gmail.com>,
 Bitterblue Smith <rtl8821cerfe2@gmail.com>,
 Peter Robinson <pbrobinson@gmail.com>,
 Hans de Goede <johannes.goede@oss.qualcomm.com>, luka.gejak@linux.dev
Subject: Re: [PATCH v8 0/6] wifi: rtw88: preparations for RTL8723B/RTL8723BS
User-Agent: Thunderbird for Android
In-Reply-To: <20260825163314.1590-1-luka.gejak@linux.dev>
References: <20260825163314.1590-1-luka.gejak@linux.dev>
Message-ID: <4866D935-FCC8-4F24-9C05-8678DCB22533@linux.dev>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

On August 25, 2026 6:33:08 PM GMT+02:00, luka=2Egejak@linux=2Edev wrote:
>From: Luka Gejak <luka=2Egejak@linux=2Edev>
>
>This is the first of two series adding support for the Realtek RTL8723B
>802=2E11n chipset and its RTL8723BS SDIO variant to rtw88=2E It contains
>only the changes to the shared rtw88 core that the chip driver depends
>on=2E The chip itself, the build glue and the MAINTAINERS entry are a
>second series=2E
>

=2E=2E=2E

Hi Ping-Ke,

A tester has been running v8 on a slow ARM SDIO board=2E In a good signal
environment it passes a thousand iterations of his stress test with
nothing in the log=2E In a poor one he still gets "failed to get tx report
from firmware", and a reconnection along with it=2E Power save was off for
both=2E

Looking at why, the two ends of the tx report path are not symmetric:

  rtw_tx_report_handle() -> rtw_tx_report_tx_status()
                         -> ieee80211_tx_status_irqsafe()

  rtw_tx_report_purge_timer() -> skb_queue_purge()

When the report arrives mac80211 gets a verdict=2E When it does not, the
frames are freed with kfree_skb() and mac80211 is told nothing at all=2E
rtw_tx_report_enqueue() also re-arms the timer on every frame, so it
fires once, 500 ms after the last enqueue, and purges everything
outstanding, including frames queued a moment earlier=2E

One of the frames that asks for a report is the nullfunc mac80211 sends
to poll a link it suspects is dead=2E If no status comes back,
ieee80211_sta_tx_notify() is never called, the poll counts as
unanswered, and mac80211 tears the connection down=2E That fits what the
tester sees: the warning and the reconnection arriving together, and
only when the signal is poor enough for reports to go missing=2E

Raising the timeout further does not look like the answer=2E Patch 3 of
this series already takes it to 2500 ms for the RTL8723BS, five times
the default, and he still reaches it=2E A longer wait only delays the
status=2E

What looks right to me is to report the frames instead of dropping
them: walk the queue on timeout and hand each one back with
rtw_tx_report_tx_status(rtwdev, cur, false)=2E That tells mac80211 the
frame was not acknowledged, which is true, and lets it act rather than
wait for a status that will never come=2E It would also stop mac80211 TX
skbs being freed with kfree_skb() instead of being returned through
ieee80211_tx_status()=2E

That is core behaviour for every chip, not just this one, so I would
rather ask than send it=2E Would you want it as a separate patch outside
this series? And is reporting "not acked" what you would want on the
other parts, or would you rather the timeout stayed silent for them and
only this chip changed?

Best regards,
Luka Gejak
