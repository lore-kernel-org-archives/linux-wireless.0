Received: from fout-b7-smtp.messagingengine.com (fout-b7-smtp.messagingengine.com [202.12.124.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2566636AB44
	for <linux-wireless@vger.kernel.org>; Fri,  2 Oct 2026 06:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790921548; cv=none; b=J9f/TPVjQzWRaQFpJrm27nW5t3tpYauTknyBph7+CnoVU3VUfCXq113PtK6g2XESxkDt1ORJHHRCxkeKAJqTAOtknONtPiHiYItMtk/FMjEECMPj1V6B08Elore3VYj7S61oIyXnNx1OcuDuQfQm6Tnw3NoMCnLoPeD37N9U+Ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790921548; c=relaxed/simple;
	bh=ZJhiHHieDWa/62asdMDop3cTpqq1JaHuH6QMHtyZ0u8=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=JiBbwhYNIzeY8ofGOpMLUX5uTL+tka2ge3zGo5oK5CH155+8tp6mGkVrzFKNav+E78W7Xh+qAg/hwXm2k2YnMer+ukQlmWzZYZTzLQxGR5kUxUUlcsTI1imUmJrOoDH+22EmlfWGWhpRx6Cbm+Iydt+ReLA0/Ra7Jew8srerzuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=WJhTWp1e; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=jCp8uG3q; arc=none smtp.client-ip=202.12.124.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="WJhTWp1e";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="jCp8uG3q"
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfout.stl.internal (Postfix) with ESMTP id 3B9FA1D000E5
	for <linux-wireless@vger.kernel.org>; Fri,  2 Oct 2026 02:12:24 -0400 (EDT)
Received: from ams-imap-03 ([10.64.2.23])
  by ams-compute-02.internal (MEProxy); Fri, 02 Oct 2026 02:12:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1790921540;
	 x=1791007940; bh=NeBUYbgCO/IE36aDtEKxMWQQk1AwYdLSXOayI0OIQ6w=; b=
	WJhTWp1eh+JmixtFrFZBM8VTzzZFhpDkO4DYJowg1QUz3E7tA3qm/c7y+AMaTt/I
	yuXYZxBbsoJNm2zLEw1Pd8m9gGC19gUCPzkyn1w/Lg/Wq+rNnwcxSSn20XZCFAN5
	zB70zVCS06mzExT8/XylWCkSLtkBA3F+H8lCqlI+aSizm2cPA+blYZWD2oPKc1r2
	7MtyH+Y3XM2FdQumIRkQYWFolSPK3GLtC/gAyYtZ4dRK0hAWcsZUCMHqx2/Jaggz
	JAXadB9jP9R6ke2//azHDF5RMCamE1JKuHGeFBS4TPXIR4ZGsuiDP84v41o0K5gX
	q9aZVo+309zO7tlTCDVzAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1790921540; x=
	1791007940; bh=NeBUYbgCO/IE36aDtEKxMWQQk1AwYdLSXOayI0OIQ6w=; b=j
	Cp8uG3qHwcM7476pqa+iLQBYsGmVLHg5zlwwoaktscpZ3i5Sk78Yc8kqH1/I4W+Y
	GhSzdbxJYYBBlbH70+xr1Mwh/fWYd8a7fMGoijNmtKJGsuub1+UUqVMgrt7sODvS
	cYWMhiK2rzc85ZsQ9DlEIkcUxhOOIikrZGbcmVx5uSvE6g0xtvJxWcArkdmWJZ5n
	WxO9QJpuTf0bXyyX3P0UefeYFGPjRPUi1NjhDDuyWdrSU+CqWOwvvKDnAlHwZnhV
	dJs7jOIMOFbCCl9o7S0eBGb0P6I3i3YX8w3kmBebXRUnnR+GIWhJC27jEFfeYS6Q
	ccnHCiumFm+k9wxy2MIGA==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-09-30; sw=lmtpprox;
	action=sign d=arndb.de a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1790921540; d=arndb.de;
	mf=PGFybmRAYXJuZGIuZGU+;
	rt=PGxpbnV4LXdpcmVsZXNzQHZnZXIua2VybmVsLm9yZz4=;
	s=fm1:rsa-sha256:jijWyI0U25cSjavwLLXUmzdSGMLw//e38pSKm0mFLGyJ5Ak
	x1lW1E2EpyJnpyAA10LsJpIQbLKPGWsCXql4uiAIFq0CTJWzQQB2anokYH7U8q7d
	ltgZRdUeUPniwyI4Oxde0roRiAaHAEAa6GazhkGTBil3DnaB+RaX1NcDK/NoVEYl
	QEMN4SNNe/kNBjNshV4wHHWgOhr4mj/F+rAXiKWHkrDLJ2w9Bqpy4X2ye4tG4VEn
	xqlVqGFZCaCkS6pcDnLsbZ1de+J1CdetbpckvwL52nVpn/mPmkznIlKE3RM3Q8Tl
	Yjm9g7ve9envQAxuY5AMr6heprtIESueVT5KoxA==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-09-30; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-transfer-encoding,content-type,date,feedback-id,
	from,in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:Ey9Ympoyxvs5hQgFtBNJdjCUG/CpYcZBTbkdtGAD6H8=:ZJhiHHieDWa/62asdMDop3cTpqq1JaHuH6QMHtyZ0u8=;
X-ME-Sender: <xms:Qku_avHAfX99dSUZBoJvD3nP8ymXTtnsID0ocSLbQ5n0E6lvJ8Lz_w>
    <xme:Qku_anKAnvvuax6VF4HnoyR-z1PzHCfUPuo_oNjvOhe8TUZyBjVinWErFVNLoFl6P
    lF1v9dYeUrM0T6RYlypLGy0EEPKTxv8GQywCAqzkijkpKTQjbVXjEKV>
X-ME-Proxy-Cause: dmFkZTEJ0cgKY5xWsCsHXL6spKR81ICBzKWlkmPZLF+WzyPnGSPKlNV9zXcJGFbRtcReVo
    F/zec6VYkQSfgRjJzVUBTwtQUM+Gp32Tsn4nEXHrVyEq04PMNhEg7q47r5/ahbv5xVVkxK
    7t92Rubl7vSuZpxLUUGGMzz4CKMHcAJZKbzg6rho3d3eHaF2H6TR8WDzXs1qdTj6K/8DwG
    LYcDyay8eJkN7sNFlsU3eGwmkwwLWSmuRmn5VLE1oxEW89VpBCGOGSbyGeAd1wpI4O+upU
    5hGqx1tRuYope+Mc10TeKNfw1jBoKRS+c3uUOoWlTNJmJGi3ZkcwCaiCFEF/lC+izaamkM
    UkWgHAt6w/u/xrp9N+q50DWjeZs10LpkYb/P/wqx4z14ShWDw1x/HEsEyLPB7I37zR2Adf
    u+4Y5m9MEnsJ+Oio5jVT3uig/EqmF96+K0UEt0mhFx0+StnRHVgebMSI14PgelgwHMOXFg
    Yedl3kvWUin/OTs/oYp2S+eJ3EsnX+FVRshp8YO3YNtz9c4s+w8FXYkNgQ/nnpmxfW5LXx
    LSFWP1BsgMcC9M3oPEpseTzqimOmx9Kb12gEMD2uz3ZN3VfY/miCDpK95+jAP6JIp2JsHz
    AcsfhOyLATgr6lsJxoa1jYQJPj+0Nhhc8axl0tHJavwTkPzDHu+SvMTuekcA
X-ME-Proxy: <xmx:Q0u_ajzH0mzXszrMFH6qbGQzv1aTiTjtlXz3v613MVy2D3zJZJJG1w>
    <xmx:Q0u_aiozF3Z3KBHpY0t_V5AxBhx3PtcE9DaE-YNsS5Wilcrd7VMlTw>
    <xmx:Q0u_ai6JXrWknpgM7EE0NzYtD_mz1lGRq-osu1f0duz-CZAnDlVq5g>
    <xmx:Q0u_apeYK24JcrezlCvIVqNPrW6wyGDpbqKSKMGWPqyWtNEx2RUrtg>
    <xmx:REu_ajqOBHO8RKItUfY5p-DvRGKk32Iou39iAz_9cKZVvrlnoTuVpRX7>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 6517832A008A; Fri,  2 Oct 2026 02:12:18 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: AeRYNq7l0AL7
Date: Fri, 02 Oct 2026 08:11:58 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Ping-Ke Shih" <pkshih@realtek.com>, "Arnd Bergmann" <arnd@kernel.org>,
 "Johnson Tsai" <wenjie.tsai@realtek.com>
Cc: "rtl8821cerfe2@gmail.com" <rtl8821cerfe2@gmail.com>,
 "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-Id: <7cdc36a9-aadd-4636-8a29-847d89638c8d@app.fastmail.com>
In-Reply-To: <bdb19ff5e0bc456cb035a1aa0124612f@realtek.com>
References: <20260929104159.3236854-1-arnd@kernel.org>
 <1bde7ea5999c4915b184bf2fcb904901@realtek.com>
 <0162247f-ca33-4152-bd32-255343c7216b@app.fastmail.com>
 <bdb19ff5e0bc456cb035a1aa0124612f@realtek.com>
Subject: Re: [PATCH] wifi: rtw89: fix LED dependencies
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Fri, Oct 2, 2026, at 02:22, Ping-Ke Shih wrote:
> Arnd Bergmann <arnd@arndb.de> wrote:
>> On Wed, Sep 30, 2026, at 02:28, Ping-Ke Shih wrote:
>> - we already have a mix of 'depends on' and 'select'
>>   for the LED support, which can lead to circular dependencies
>>   and other problems. Adding a third way can only make it
>>   worse.
>> 
>
> Agree. I'll remove these two discouraged 'imply'. 

Ok, thanks!

>> The way this was meant to be used is to have
>> 
>> config RTW89_LEDS
>>       def_bool RTW89_CORE && MAC80211_LEDS
>> 
>
> I'd keep first block as
>
>         depends on LEDS_CLASS=y || LEDS_CLASS=MAC80211
>
> mac80211 implements ieee80211_get_assoc_led_name() used by this driver as
>
>   static inline const char *ieee80211_get_assoc_led_name(struct 
> ieee80211_hw *hw)
>   {
>   #ifdef CONFIG_MAC80211_LEDS
> 	  return __ieee80211_get_assoc_led_name(hw);
>   #else
> 	  return NULL;
>   #endif
>   }
>
> That means if CONFIG_MAC80211_LEDS wasn't defined, driver can still use
> ieee80211_get_assoc_led_name() as default trigger, but just NULL.
> More, use space can adjust LED trigger via sysfs, so having LED support
> is still usable if LEDS_CLASS exists.

Right, this should work and is consistent with how other wireless
drivers do this.

I think it would be nicer to just use MAC80211_LEDS as a simple
dependency as I suggested above. If we do that, it should
be done the same way for all the wireless drivers, but that
is a probably something for another day.

       Arnd
