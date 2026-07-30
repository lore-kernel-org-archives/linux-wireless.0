Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 367DC21A42D;
	Thu, 30 Jul 2026 16:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785430357; cv=none; b=mRpTXJdpJmNEpdgxF8jCj7V72/Ai+OoWVmfKEX3HTA9USHPuUCAbYcK8/54Qmar0uzEW7KifzP42oFk8MruPGQjB8SYH3t8be4O4BHKi+lY9KzoDA1znsHP5i3GRTnyikiuAsof9TGdWJZUSHMsvnwjqSC68m+kzbeB/lpqp0IE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785430357; c=relaxed/simple;
	bh=Pte4cq3DjMsdFasoCuK7arZF+VEnp9tyIIOyvkduFmg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ID6UnINaPDxyuQoCGKJ5WJMmxacph33m3AXn3zitSIWtuUcPHx8yOvjBmnBr9P4zVL9zwEDIrBNbUTwXO8ryf7klae3BUZKDVPT6attycZzHga51En9Y6TWz3W/PmhcEPliSLKd6qqVvnl+dkpPTbbH/mmffSkRiExOHUWKR2hA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YKSWU1b6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YKSWU1b6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0E2A1F000E9;
	Thu, 30 Jul 2026 16:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785430355;
	bh=3/SF2rcIDob+OJsvgKUnxzlLtV7Cho5d4qWeW/aMqHU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YKSWU1b6s5ok+6SD3NJllCvDrereMWADi2zXL775eUkM4l4iqZVhgt7EUS34JzsdD
	 7GUhHLDzecXtvYv5fiRFVMVbpbm4Wi3NsFLefEipeiNfeq/QTTXxWHgr9r56XdvQFo
	 1sxcRP1q66GI9TA56YnR0BCCan0og63dC6qWCcfguFtSIKHcyQ3YCii0aVufotm9h7
	 PYRyH/SJYDNhSeHO/irG2zpZByLN6yIlgGTc0hVrfp1sHoScMUO8mQW5Fi39V0WkLD
	 JAJQwHXfi2LSQVdPgzWRepnfo4Rihg3D7szeyW6kSVdAHXHn8phltt+p4L3OIKw9cK
	 HuxC2jKW1/2rw==
Date: Thu, 30 Jul 2026 18:52:25 +0200
From: Manivannan Sadhasivam <mani@kernel.org>
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>, 
	Bartosz Golaszewski <brgl@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Marcel Holtmann <marcel@holtmann.org>, 
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>, Alessio Belle <alessio.belle@imgtec.com>, 
	Luigi Santivetti <luigi.santivetti@imgtec.com>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
	Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Jeff Johnson <jjohnson@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, 
	Chen-Yu Tsai <wens@kernel.org>, Loic Poulain <loic.poulain@oss.qualcomm.com>, 
	linux-pm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-bluetooth@vger.kernel.org, 
	imagination@lists.freedesktop.org, dri-devel@lists.freedesktop.org, linux-wireless@vger.kernel.org, 
	ath10k@lists.infradead.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH RFC] power: sequencing: rename pwrseq_power_on/off() to
 pwrseq_vote_on/off()
Message-ID: <aht3dm6gijcltk2kblilwd33ihrapdwbco2fd5wxrqmsuppqde@3s3242otfa5h>
References: <20260727-pwrseq-vote-rename-v1-1-a2029aeeac65@oss.qualcomm.com>
 <20260727161435.GA1219282@bhelgaas>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260727161435.GA1219282@bhelgaas>

On Mon, Jul 27, 2026 at 11:14:35AM -0500, Bjorn Helgaas wrote:
> On Mon, Jul 27, 2026 at 11:57:38AM +0200, Bartosz Golaszewski wrote:
> > The way power sequencing works means that a call to pwrseq_power_on()
> > does not necessarily result in the pwrseq target being powered-on at
> > that time: it may have already been powered on before. Similarly: a call
> > to pwrseq_power_off() does not have to result in an actual powering off
> > of resources: there may still be other users that requested a power-on
> > before.
> > 
> > We will also introduce the concept of "non-controllable" pwrseq targets
> > soon which further increases the disconnect between the naming
> > convention and the actual semantics.
> > 
> > What consumers of pwrseq descriptors actually do is: they *vote* for a
> > powering on of a given target or retract that vote. These operations
> > could be called get/put in line with runtime PM but this could become
> > confusing since we already provide pwrseq_get/put() for a different
> > purpose.
> 
> I see the possible confusion with get/put interfaces, but "vote"
> doesn't seem exactly right because it really is refcounting, not a
> majority vote thing.
> 
> Maybe enable/disable is a possibility, since regulator_enable() and
> regulator_disable() have the same kind of refcount behavior?
> 

+1

- Mani

-- 
மணிவண்ணன் சதாசிவம்
