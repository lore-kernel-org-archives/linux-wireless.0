Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 514F93BA237;
	Mon, 14 Sep 2026 06:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789366937; cv=none; b=bBgxRssk1IToyQXp92FYA0kR/aQ/Q4qgAaKjHZpI49gk9mQ+Mncxycf9ProZUbfMn4fXVpfSdK6qzYHexeCTR/kB/sEMYZxBh2zQHyCZr2q04MmM0Euca4iUJ/BpEdKexMsK/2P6JW1tTnLld9aTfCokISGPEYTjQR3QeYKuurg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789366937; c=relaxed/simple;
	bh=pXII4JGlqjaRQl+sSKIwkXgER4sHxEtbUGWxUtd/yU4=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z7j9tiQk3Khs0Hs6UtpydvbxsUNA1v0VtXvEwQzLWWr/7r6nwwh9H/AEl/daEFU8rgWm50GiJrZ2bevdwvEOaNvdxg3SwoOGTjYcqixnB8lVHiCIDd51kovPWBt0jXBl1A07q+syOdnrfR9hH7WdWTEL2e7Y8QX490iUUom5U5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=o45KzPNI; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=xo7U/N2V; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=MQTEma4u; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=hVta1DEZ; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="o45KzPNI";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="xo7U/N2V";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="MQTEma4u";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="hVta1DEZ"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 141DC1F7CC;
	Mon, 14 Sep 2026 06:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1789366930; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BtalXNOyJJgm2Apl7LzQtj+X8azbLpNMHHmOet77qrk=;
	b=o45KzPNI7mB5TQa7etadrNVtYUqnwO9xUha3PGego+QDOTI+XXLcWOEvnCJbADU/zftYEm
	p0+v0ubbM4Jxb/13qGhEioXPXvKFVHny4wglPxnnA/gcM8klf2vCTy/UtuhAkDbG8601RB
	0y485+cFlLOccRhZAV1FuKtQsdgddKo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1789366930;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BtalXNOyJJgm2Apl7LzQtj+X8azbLpNMHHmOet77qrk=;
	b=xo7U/N2VU3Dg9tDJ9axyUuMJJF9gr8mqxh1HBTzmN47Au/0AAYbepOLcg5I1uGlGImcCyp
	d0SPPoY2P5uxWXAw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1789366926; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BtalXNOyJJgm2Apl7LzQtj+X8azbLpNMHHmOet77qrk=;
	b=MQTEma4uDMXg5RUJmfHLfo+9qAYkCu7zeM4h/Jup/Rug2qJW6ozAcDp+ZN08hcFsSxjDGe
	r38yheertbdY1I/wJexC24IQPzVFQwF1M1iXJEFz1oLawJg7wbODw6glJK/d6hFVZuF+aA
	NrTSM9mWV6zyg2aMYPvV5UzbM/xzoM0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1789366926;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BtalXNOyJJgm2Apl7LzQtj+X8azbLpNMHHmOet77qrk=;
	b=hVta1DEZ5DtkP/j+ntDriha9uN707rY0bpW2WoQr8c8NBoIiLjmR4VxSXWmZ84G7Q+fwSK
	6at574Z4+JMv5rCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AE32813515;
	Mon, 14 Sep 2026 06:22:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ezUcKY2Sp2qCBwAAD6G6ig
	(envelope-from <tiwai@suse.de>); Mon, 14 Sep 2026 06:22:05 +0000
Date: Mon, 14 Sep 2026 08:22:05 +0200
Message-ID: <87mrtkpd2q.wl-tiwai@suse.de>
From: Takashi Iwai <tiwai@suse.de>
To: Thorsten Leemhuis <regressions@leemhuis.info>
Cc: Takashi Iwai <tiwai@suse.de>,
	Chris Lew <christopher.lew@oss.qualcomm.com>,
	Deepak Kumar Singh <deepak.singh@oss.qualcomm.com>,
	Pranav Mahesh Phansalkar <pranav.phansalkar@oss.qualcomm.com>,
	netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	regressions@lists.linux.dev
Subject: Re: [REGRESSION] ath12k suspend/resume breakage on 7.3-rc2
In-Reply-To: <2741f995-dca0-4645-848c-34752d62574f@leemhuis.info>
References: <87a4plsg4w.wl-tiwai@suse.de>
	<878q55sfxo.wl-tiwai@suse.de>
	<2741f995-dca0-4645-848c-34752d62574f@leemhuis.info>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) Emacs/30.2 Mule/6.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-Spam-Score: -3.30
X-Spam-Level: 
X-Spamd-Result: default: False [-3.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.993];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[9];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid]
X-Spam-Flag: NO

On Sun, 13 Sep 2026 11:03:57 +0200,
Thorsten Leemhuis wrote:
> 
> On 9/13/26 10:39, Takashi Iwai wrote:
> > On Sun, 13 Sep 2026 10:35:27 +0200,
> > Takashi Iwai wrote:
> >>
> >> on 7.3-rc2, the suspend/resume of ath12k WiFi on Lenovo Thinkpad T14s
> >> Gen6 AMD model is broken.  Upon suspend, the network isn't recovered,
> >> and the desktop got eventually frozen.
> >>
> >> The git bisect pointed to the commit
> >> 544d85de4dc22c01badfd8cefa59829ce35c4858
> >>     net: qrtr: Send HELLO message on endpoint register
> >>
> >> and reverting this fixed the problem.
> >>
> >> Below is the (stripped) dmesg output after the resume showing the
> >> problem.
> >>
> >> As far as I understand, the problem seems to be the change of the code
> >> flow: ath12k uses mhi_power_down_keep_dev() during suspend, so the
> >> qcom_mhi_qrtr_remove() and *_probe() won't be called.  This makes the
> >> driver endlessly waiting for the HELLO handshake upon resume with the
> >> commit above.
> > 
> > ... and below is a quick fix I tested.  It seems working so far.
> Not my area of expertise, as you know, but have you see this fix for the
> culprit? Or is your problem a different one?
> 
> net: qrtr: resend HELLO on MHI resume
> https://lore.kernel.org/all/20260909055846.16539-1-daniel@quora.org/

Yes, this patch works, too!  So scratch mine.


thanks,

Takashi
