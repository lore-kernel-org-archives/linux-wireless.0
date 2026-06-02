Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0F6F3FE359
	for <linux-wireless@vger.kernel.org>; Tue,  2 Jun 2026 17:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780422411; cv=none; b=Dam5oz3JbcpJTOtsblHrm7P5HS1VqkpgCZJiKfm+pUcacE7RGmS4OJ3fsTLfhaDTB3k18tDx6Tgd5Eddys23f2W0WA8YYbiYscJXfnkI92i1i7ifAvOvWmZUVVCHX4hq0FX1/YMYgkoOTtsUb0L8IQ04da6pckXCZbpqMeBN3yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780422411; c=relaxed/simple;
	bh=lkXExpOq/3CFxUJ56vajrxY8zubhNMYaVnoxW5VnrOQ=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Tn+4ItryfdiFFmrH5Ribr8xSxCWKXL4xXoUERuFNejEcx+7s7uVWA2w8RWFiB0wGajPkSMwKNQrPfoYnlrlqCZCFoLfJLkszCET3Nugt0h86n32H8db6Ww+67DQhYbKGe4j5d88ns3FOPfYelnd2naMysWFYiD0n3UBpwEhuOAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=rmueofPU; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=1J0yLW4+; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=rmueofPU; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=1J0yLW4+; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="rmueofPU";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="1J0yLW4+";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="rmueofPU";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="1J0yLW4+"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 44B7A75BE5;
	Tue,  2 Jun 2026 17:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780422405; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XBPeD93nc5hxvHMZc8DnnBow0Wo6CxVrYE8MsKc6QzA=;
	b=rmueofPUpwNGSqHiFDJaUhIJ62NzunhrtUKpJ2lWNdQARu6er7L6mkDxEeQR07ZNJiQmPo
	XG8jXV4z+lO8vvshD4sxjISDa9SPpGHSmdzd+vUBIWzCftPz1pzCT4TOxZh0hmq9VDEwWW
	KAls6WFHzvR0oQUuF8ApHpSgetNht1s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780422405;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XBPeD93nc5hxvHMZc8DnnBow0Wo6CxVrYE8MsKc6QzA=;
	b=1J0yLW4+sa8fhyp7971bnnTPekDKreYZio0Su5wxx0kVl7vjt/u6VsTGsxYBAmZjOexqXa
	OIonz/LImpd5iJCg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780422405; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XBPeD93nc5hxvHMZc8DnnBow0Wo6CxVrYE8MsKc6QzA=;
	b=rmueofPUpwNGSqHiFDJaUhIJ62NzunhrtUKpJ2lWNdQARu6er7L6mkDxEeQR07ZNJiQmPo
	XG8jXV4z+lO8vvshD4sxjISDa9SPpGHSmdzd+vUBIWzCftPz1pzCT4TOxZh0hmq9VDEwWW
	KAls6WFHzvR0oQUuF8ApHpSgetNht1s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780422405;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XBPeD93nc5hxvHMZc8DnnBow0Wo6CxVrYE8MsKc6QzA=;
	b=1J0yLW4+sa8fhyp7971bnnTPekDKreYZio0Su5wxx0kVl7vjt/u6VsTGsxYBAmZjOexqXa
	OIonz/LImpd5iJCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8739F779A7;
	Tue,  2 Jun 2026 17:46:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ZOTVHwQXH2qNNAAAD6G6ig
	(envelope-from <tiwai@suse.de>); Tue, 02 Jun 2026 17:46:44 +0000
Date: Tue, 02 Jun 2026 19:46:44 +0200
Message-ID: <87v7c0ygvv.wl-tiwai@suse.de>
From: Takashi Iwai <tiwai@suse.de>
To: Thomas Gleixner <tglx@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
	David Woodhouse <dwmw2@infradead.org>,
	Miroslav Lichvar <mlichvar@redhat.com>,
	John Stultz <jstultz@google.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Frederic Weisbecker <frederic@kernel.org>,
	thomas.weissschuh@linutronix.de,
	Arthur Kiyanovski <akiyano@amazon.com>,
	Rodolfo Giometti <giometti@enneenne.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	kvmarm@lists.linux.dev,
	Oliver Upton <oupton@kernel.org>,
	Richard Cochran <richardcochran@gmail.com>,
	netdev@vger.kernel.org,
	Takashi Iwai <tiwai@suse.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Peter Hilber <peter.hilber@oss.qualcomm.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	virtualization@lists.linux.dev,
	linux-wireless@vger.kernel.org,
	linux-sound@vger.kernel.org,
	David Woodhouse <dwmw@amazon.co.uk>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>
Subject: Re: [patch V2 21/25] ALSA: hda/common: Use system_device_crosststamp::sys_systime
In-Reply-To: <20260529195557.995298795@kernel.org>
References: <20260529193435.921555544@kernel.org>
	<20260529195557.995298795@kernel.org>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) Emacs/30.2 Mule/6.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: -3.30
X-Spamd-Result: default: False [-3.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_TWELVE(0.00)[31];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[vger.kernel.org,infradead.org,redhat.com,google.com,kernel.org,linutronix.de,amazon.com,enneenne.com,linux.dev,lists.linux.dev,gmail.com,suse.com,intel.com,nvidia.com,oss.qualcomm.com,amazon.co.uk];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	R_RATELIMIT(0.00)[to_ip_from(RLjhfkibh7w7a187adt55yhrj9)];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,intel.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Level: 

On Fri, 29 May 2026 22:01:13 +0200,
Thomas Gleixner wrote:
> 
> From: Thomas Gleixner <tglx@kernel.org>
> 
> sys_systime is an alias for sys_realtime. The latter will be removed so
> switch the code over to the new naming scheme.
> 
> No functional change.
> 
> Signed-off-by: Thomas Gleixner <tglx@kernel.org>
> Tested-by: Arthur Kiyanovski <akiyano@amazon.com>
> Reviewed-by: David Woodhouse <dwmw@amazon.co.uk>
> Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

Acked-by: Takashi Iwai <tiwai@suse.de>


thanks,

Takashi

> ---
>  sound/hda/common/controller.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> --- a/sound/hda/common/controller.c
> +++ b/sound/hda/common/controller.c
> @@ -525,7 +525,7 @@ static int azx_get_time_info(struct snd_
>  			break;
>  
>  		default:
> -			*system_ts = ktime_to_timespec64(xtstamp.sys_realtime);
> +			*system_ts = ktime_to_timespec64(xtstamp.sys_systime);
>  			break;
>  
>  		}
> 
> 
> 
