Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 789093033E3
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 14:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785508583; cv=none; b=dodbJkgyJeEBBI6sx8YNGt+Qd4SolTBy8EdS04+9XILzf3F9dhquvArjvHQF0o2b/QFtQkQE+6cR6WsSHDCJecQ6gAHf/Kv/qyYzJt2Ca8IVq66yzU+N5aoOCUg6DFTuQjG5yc3ewFQQ2CIjXSXdznkpJ9UUcVon7a89Xawg7rE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785508583; c=relaxed/simple;
	bh=u/m1G5Mj/gpUmq8B5jE48Xt9oXY4N5q+2DUXZQdrOsc=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=Fbo46HHMeiHeM3Z298Kptzi9YXccj4n8g5icVv27dN/E5TzxUOuLeycrkbp10f6AZR5m8Ft4mliT/j8hRRnr5Z/VpRyNSA3v4LHXSCVMaJcpt2TwvbsTx2lFF2264jOYTqomR3PJPzJM5yRTr4JokD3LNOSXd3PSbmGh1h81qyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iGpmuya6; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iGpmuya6"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5b0117d49dcso1262545e87.3
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 07:36:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785508579; x=1786113379; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=w/jguCjf+KBIfGvaAVskMUdU78PiWlYOOsYiLMy7Qgs=;
        b=iGpmuya684rzCds4Cafhxu5ltPWmneGbVP1pe/65aLAxn0HunRuURYDKR+es/B5Ix3
         nHx7KZ9uu5+A0XaTHnjCp50oIDMKJUMKhZyUUFdv2zpmlRnCzGFzqHd1m2XnbBdwfn1H
         7gaPivEXiOxp/GPdYn44xqOdjZBBUMKxE4nq/2ZKPtKKno+xaPUBfeig+j8eL9UckBDb
         GRTAgQOoPx8itijVBFNqon74apnwiL27wJIV+2rFfQ4HldTS/1qwo+4c5i7oirFAU4J4
         u8IS5jdc8a1KkGUulj7ir6n5Me2TkHIgZ91oywFDCaqvZlBXEzuZJj0g1XdijVTCuxoF
         q9TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785508579; x=1786113379;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=w/jguCjf+KBIfGvaAVskMUdU78PiWlYOOsYiLMy7Qgs=;
        b=q6D07Xo41Zi/Ft+1brbpDh3Wg5DrEiBvTMOIwjx0fjwnHrZnG4TdDPvdy18mTtb1h2
         XiUOyiUbObPryfKKK9CZdu56YkOTCuj7snFMfMypElJNMgszLhUZakwhjhsetobWUOpc
         2I+KjIT0N7O9oe3cNA6ApdTxAfcrD6Ta2QeM6f4zOBpaEbZB+o8rtAL47EousDDywzp8
         nLEPPW/C1ydzzoWKYojh/CBRTcMWDwqQ64KCtdA4q0pakRlNwM+h3vPE1G75QwQueAJ3
         y1MjxhsE1DglRwCzhZxN5gR5oR/iC1V0aYd3ELo2HUy7w2utB8w6YKQYZ+IE2+yUdL94
         Bzwg==
X-Gm-Message-State: AOJu0YwueUIfEDcioJWHl4nA4ld5zz6Q4CIeSll4sFYO3sczgQQMJ0vQ
	XDiT/znKzoIyMH7+NDVHUOsdTzzxREtJXYWKbaVzjgxm8wiXKUGzwl0z
X-Gm-Gg: AR+sD12ty9+6BIRSqtZ8LKLkFa3QYyKhibr20tmBqaEjub5prM/tg4ev5ZovD+EPpnb
	EqMFDsmajUr/Dav+zk51GJjg3T/RbygRfuD82kgyVsg6V1Qt7PomTmOVgn4VkhcRJqF5mtOZIy2
	lNWuyo4UqUwFfxuUCBBQHC9X2anB5Wx6itUSYVghiV10+lAnK5bRt6EcVRBx3t8eMUeYaInv8fI
	g1vy9eomggkQMxi6aIL7iZxoKvdrsr9BLYP60JrdHHo6Yfr1CZY15vZnf3/k+XYw9L+swf53oZS
	nGbKLTyOHGN/qZd1N6U7VFBHNBAAP6Efd1jtPatu4aYiWaSlFBVgbkRCSCmduv1wBsjimP3u/Fj
	8Ey8FQNBPlaYUfT5xBKiXAvsCOHy9XF3YYoozhn2pLqie9mjPp+R7S0xs+dDXXtt4mI7zBVpcWI
	Mpy0Lmg51VGneZl0YfR3zpQTy9hHj+JBDNIoFlTITk8a9imNLrdPRpL/CDmiKi6uUVaUeISJ0cl
	+NUqZM=
X-Received: by 2002:a05:6512:3b8f:b0:5ae:c34c:aecb with SMTP id 2adb3069b0e04-5b2e1feae31mr502137e87.41.1785508579084;
        Fri, 31 Jul 2026 07:36:19 -0700 (PDT)
Received: from localhost (freebox.vlq16.iliad.fr. [213.36.7.13])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b2e23cbeedsm343039e87.30.2026.07.31.07.36.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jul 2026 07:36:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 31 Jul 2026 16:36:17 +0200
Message-Id: <DKCTYSL53MB6.16YGGTQW1BGDC@gmail.com>
Cc: <linux-wireless@vger.kernel.org>, "Maxime Bizon" <mbizon@freebox.fr>
Subject: Re: [PATCH ath-current] wifi: ath11k: fix locking problem in
 ath11k_dp_rx_tid_del_func()
From: "Nicolas Escande" <nico.escande@gmail.com>
To: "Baochen Qiang" <baochen.qiang@oss.qualcomm.com>, "Nicolas Escande"
 <nico.escande@gmail.com>, <ath11k@lists.infradead.org>
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20260729085741.3485711-1-nico.escande@gmail.com>
 <387b4bb6-b0e4-471a-9276-211ecdedb58e@oss.qualcomm.com>
In-Reply-To: <387b4bb6-b0e4-471a-9276-211ecdedb58e@oss.qualcomm.com>

On Fri Jul 31, 2026 at 8:49 AM CEST, Baochen Qiang wrote:
>
>
> On 7/29/2026 4:57 PM, Nicolas Escande wrote:
>> From: Maxime Bizon <mbizon@freebox.fr>
>>=20
>> In this function, we iterate over dp->reo_cmd_cache_flush_list using
>> list_for_each_entry_safe(), and for each expired entries we call
>> ath11k_dp_reo_cache_flush() then free the entry. As this can be called
>> from multiple CPU we protect for concurrent access using dp->reo_cmd_loc=
k.
>>=20
>> The lock is dropped to call ath11k_dp_reo_cache_flush() and taken again
>> before keeping iterating over the loop. That is broken.
>>=20
>> The list_for_each_entry_safe() protects over deleting the entry being=20
>> iterated over but does not protect for concurrent access. So another
>> thread might have taken the lock in between and modified the list, leadi=
ng
>> to a crash (see bellow).=20
>
> nit: s/bellow/below/
>
will do
[...]
>>=20
>> Tested-on: QCN9074 PCI WLAN.HK.2.9.0.1-01977-QCAHKSWPL_SILICONZ-1
>
> hardware version missing betweeen target and bus type
>
will change
> QCN9074 hw1.0 PCI
>
>>=20
>> Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices"=
)
>> Signed-off-by: Maxime Bizon <mbizon@freebox.fr>
>> Signed-off-by: Nicolas Escande <nico.escande@gmail.com>
[...]
>
> while this seems the minimal fix which stable team might prefer, how abou=
t refactoring as
> firstly detaching all the expired entries onto a local list under the loc=
k and flushing
> that list afterwards:
>
>   LIST_HEAD(flush_list);
>
>   spin_lock_bh(&dp->reo_cmd_lock);
>   list_for_each_entry_safe(elem, tmp, &dp->reo_cmd_cache_flush_list, list=
) {
>         if () {
>                 list_move_tail(&elem->list, &flush_list);
>         }
>   }
>   spin_unlock_bh(&dp->reo_cmd_lock);
>
>   list_for_each_entry_safe(elem, tmp, &flush_list, list) {
>         list_del(&elem->list);
>         ath11k_dp_reo_cache_flush(ab, &elem->data);
>         kfree(elem);
>   }
>
> This fully decouples the concurrency from the flushing: the detach phase =
runs entirely
> under the lock, and the flush phase walks a thread-private list where no =
concurrency
> exists. It's a single O(N) pass instead of the O(N^2) worst case of re-sc=
anning from the
> head, and it avoids bouncing reo_cmd_lock once per freed entry.
>
> Also this seems simpler and more direct =E2=80=94 its correctness is obvi=
ous by construction;
> while the fix of this patch is less self-evident: a reader may not easily=
 grasp why the
> code has to rescan from the head after re-taking the lock.
>
> Non-blocking though =E2=80=94 either form fixes the crash. If you'd rathe=
r keep the minimal goto
> retry for the stable backport and do the detach-list version as a follow-=
up cleanup, that
> works for me too.

Yes I remember that we fixed it this way with Maxime to minimize code chang=
e.
But doing it your way seems to be the better thing to do. So I agree I'll
rework this wit the single iteration under lock + cleanup pass.
But it will take me some time to do so, I do not have much time right now.=
=20
So if Jeff prefers taking this one as is just to have a quick fix no object=
ion
either, I'll rework it later for next. You guys tell me what you prefer.
