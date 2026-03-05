Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAF9A39C653;
	Thu,  5 Mar 2026 17:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772731262; cv=none; b=pg7tGP/jAPGdqA60qU/gUoDeFPEzO0Cn6npK6UaUm2Hl92SHH/iddML6v2LNZsLbGj1pW5I5noEFG6d1TWoOMm6KyYYD0voXgP7lPZo6zl7K1F4CG0GW99/suJhRziG/JzFEKnmWMoqTsSm+tEQDoS2x+nGE0Z6jrtalYixx5II=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772731262; c=relaxed/simple;
	bh=SlCJF42e7tc+fr9+74RoFgPnfv67E1R18ylV0LD2aSY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TTgJcc7IhcIUoSnOGGPXzTs2/kpFOWo/8yD1MsWlMaJWNREBmNPrBw9PTIbnHEWpKw0hVi5K4V2kS3E7CqvVW0bQbudCYVYldh8ijLNDBD+GCnPajgXOme8WyLJ2orczjLwG/Qpt1bKzK0FtdKOFm+7p+c6BFIL4Nu2wR8QcbAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rr725aB8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rr725aB8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 176DAC116C6;
	Thu,  5 Mar 2026 17:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772731262;
	bh=SlCJF42e7tc+fr9+74RoFgPnfv67E1R18ylV0LD2aSY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Rr725aB8B6pGxQHaf0clr6NL5mOigAD9FwXCJN3/2DRtD7wy0v1MECrQt2zdwEeLT
	 fxhKOORzdxHMP/Lo/Qr3UMd3na3k17JoyPeHQe1bUrOUguY5K7qgUi3rr5NSx2rHQV
	 w9kKgtkdWnD/ENij9PdM1lap1do3C4tnifIVq1uiEgqc6pDcE5DMhFYWi4e8Hqb0Cx
	 Bw8MueOlm/L0IxyYHbZ34ZJbqB1wBJ+iNwxlbACNri+apFh2HgWcAoNcVHZgPtWYKF
	 jHAhadEysYf0d82q8DZS6aLOV9JYnJ9oWzIPMj82Y7/uwhCcDk49hnvGfVkPYmpqEK
	 QjdC5gg0Wk5rA==
Date: Thu, 5 Mar 2026 18:20:59 +0100
From: Frederic Weisbecker <frederic@kernel.org>
To: Marco Crivellari <marco.crivellari@suse.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Michal Hocko <mhocko@suse.com>, Kalle Valo <kvalo@codeaurora.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] ath6kl: add WQ_PERCPU to alloc_workqueue users
Message-ID: <aam7e3bAFBVOUnFX@localhost.localdomain>
References: <20251113161248.387964-1-marco.crivellari@suse.com>
 <20251113161248.387964-2-marco.crivellari@suse.com>
 <CAAofZF5oAd18VV6ipoJDjiWvCeRxUh5KtdEZvPQ_DS71X_Vkzw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAofZF5oAd18VV6ipoJDjiWvCeRxUh5KtdEZvPQ_DS71X_Vkzw@mail.gmail.com>

Le Thu, Mar 05, 2026 at 05:44:04PM +0100, Marco Crivellari a écrit :
> On Thu, Nov 13, 2025 at 5:12 PM Marco Crivellari
> <marco.crivellari@suse.com> wrote:
> >
> > Currently if a user enqueues a work item using schedule_delayed_work() the
> > used wq is "system_wq" (per-cpu wq) while queue_delayed_work() use
> > WORK_CPU_UNBOUND (used when a cpu is not specified). The same applies to
> > schedule_work() that is using system_wq and queue_work(), that makes use
> > again of WORK_CPU_UNBOUND.
> >
> > This lack of consistency cannot be addressed without refactoring the API.
> > For more details see the Link tag below.
> >
> > alloc_workqueue() treats all queues as per-CPU by default, while unbound
> > workqueues must opt-in via WQ_UNBOUND.
> >
> > This default is suboptimal: most workloads benefit from unbound queues,
> > allowing the scheduler to place worker threads where they’re needed and
> > reducing noise when CPUs are isolated.
> >
> > This continues the effort to refactor workqueue APIs, which began with
> > the introduction of new workqueues and a new alloc_workqueue flag in:
> >
> > commit 128ea9f6ccfb ("workqueue: Add system_percpu_wq and system_dfl_wq")
> > commit 930c2ea566af ("workqueue: Add new WQ_PERCPU flag")
> >
> > This change adds a new WQ_PERCPU flag to explicitly request
> > alloc_workqueue() to be per-cpu when WQ_UNBOUND has not been specified.
> >
> > With the introduction of the WQ_PERCPU flag (equivalent to !WQ_UNBOUND),
> > any alloc_workqueue() caller that doesn’t explicitly specify WQ_UNBOUND
> > must now use WQ_PERCPU.
> >
> > Once migration is complete, WQ_UNBOUND can be removed and unbound will
> > become the implicit default.
> >
> > Suggested-by: Tejun Heo <tj@kernel.org>
> > Signed-off-by: Marco Crivellari <marco.crivellari@suse.com>
> > Link: https://lore.kernel.org/all/20250221112003.1dSuoGyc@linutronix.de/
> > ---
> >  drivers/net/wireless/ath/ath6kl/usb.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/wireless/ath/ath6kl/usb.c b/drivers/net/wireless/ath/ath6kl/usb.c
> > index 38bb501fc553..bfb21725d779 100644
> > --- a/drivers/net/wireless/ath/ath6kl/usb.c
> > +++ b/drivers/net/wireless/ath/ath6kl/usb.c
> > @@ -637,7 +637,7 @@ static struct ath6kl_usb *ath6kl_usb_create(struct usb_interface *interface)
> >         ar_usb = kzalloc(sizeof(struct ath6kl_usb), GFP_KERNEL);
> >         if (ar_usb == NULL)
> >                 return NULL;
> > -       ar_usb->wq = alloc_workqueue("ath6kl_wq", 0, 0);
> > +       ar_usb->wq = alloc_workqueue("ath6kl_wq", WQ_PERCPU, 0);
> >         if (!ar_usb->wq) {
> >                 kfree(ar_usb);
> >                 return NULL;
> 
> [ Cc-ing Andrew Morton ]
> 
> Hello Andrew,
> 
> This file is orphaned. Can you help me in order to have this patch merged?
> 
> Thank you!
>

Reviewed-by: Frederic Weisbecker <frederic@kernel.org>

-- 
Frederic Weisbecker
SUSE Labs
