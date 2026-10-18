Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A74903D955F
	for <linux-wireless@vger.kernel.org>; Sun, 18 Oct 2026 10:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792320478; cv=pass; b=DPv7i7S3DwOztCFp0JyLzg5BBU0wYPo5og+Ywt4aFKn2HHlbjoiJ2KXa+xSD42/Fq4c2PTORqsmUKZe8/0cLukQZ/JePhznvwwGGnQ0WeZW1KfMPbYWyQykgfhvFdsG5/xySiQ3gAbZZaTp73uDncgLryGKmkcwcFAXzTvw6UQM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792320478; c=relaxed/simple;
	bh=rvn56DACMqIo8M7FLWexOcrrS6MTPfzmNmybcvNwiS4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XnHHTpz3RUvEKbOjyM7UwurYeNdYq8AA3bF3qxo1ImJx9syHblQ/EkN75Ee2mUvmUPGw5OdXG6asIiekUnOGl+4wIaIwTCU9/Ye7qwzY6ocJQIR3mJPMIVW45H6ZFzIK/0JevtQDkoPayiKlel/uS5YsotrDL8S0OynXyElvhQQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YG2Cx45W; arc=pass smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YG2Cx45W"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-3a7cfe8f761so1519771a91.1
        for <linux-wireless@vger.kernel.org>; Sun, 18 Oct 2026 03:47:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792320477; cv=none;
        d=google.com; s=arc-20260327;
        b=pIIVEsG2Tg88Z6BZtQkg7Z1urbcTCiUjxFAD+TwpAi2+soXqkZ0wWjY1ajDUMR+jS6
         QClfjGVYSHlO88yBB130QPFk1xNbAG/OUqtyquZCrJkMUOb8pzEAy9UXQ2By4e/Wa7YC
         NAw34UePvScEt5Ui0bg6g6RAGif4eRQWIsZapAUviL8AVYG6PkTO7FtFNAbUvzeQkm4S
         8NckcX47RJgemwepeW5qYaLdAHyUT/TvQT30PIlxB14dd1E+YFmyYl4aaXdq4RXJxOZ2
         2O34Y5rHBM+pQk3TbUGj/3Wc8PvmL2sl1yB3VZVpw1bWgdyxcnQRBr3TenN+oq+qy/is
         +RTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ycigQtHDdSm8L+VPTdesboZLPpIJ02aiy7LDnRARo9M=;
        fh=sr7Eipp5nIJDu3kxgVLkBgimXUNyLb8GOOHaD/G3XJA=;
        b=biP4L33rdPH5mNEDApHPH8FvoxD/fuSth36UMTje1PDPzf1IBfTbNrtE2iCsRxgUOP
         vzaUdNGF6gRJCz5nI+v0LbYf4WrFBr30uCNpcFrZSh0h7VY2SjTTgtzZhrCXR9gUH/ek
         Hy57Q7dRs+yr0v6/0L/fyCAE+HnNjaWOGqb9LQJm1QIP5B4wTL+3dX1kqKu/XEddClJJ
         FQLZvDfWfURr60GHCNvi5e+nol8p5yZZr6O9rGxAQGFTL1kzHvP+JwGpbCtYpiRjXowr
         SX81PpmEEk9dMOsOQVWOUD9bFt07GduHD1/gyyJ3qyQwOF2nXrT2KpCHvgRrs/6emm/5
         skIQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792320477; x=1792925277; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ycigQtHDdSm8L+VPTdesboZLPpIJ02aiy7LDnRARo9M=;
        b=YG2Cx45WhVggVCXdKY4RWB7nw0nX1BUWRmxwntYfLvOJBOX4vH6f0Xz50tnL6mqOMn
         dmGxHtH5ho5MC//2QxPcyoogM+RFu+d9goDUYTJ+ybGXCArixibsQwSGKhaDtg/I+S4P
         Yq6wBmIRNAqTHjFp/GS/fkACkxGyrWtI1PXIMqP5p3eHpoWG67130ni6kqUCyQkl9TwX
         1X80+pk9/aZupyP/0yOK5wRrjou6p/exWs5keVcBMK9RleXuB36ZCJeIjceSeeSwqBzM
         alCMTTeNe/iZY++Bd7wjxwxy207LPIm82tlCqTzpgR8kXC/F3AkqLBqBF6uKfAcOpP8L
         aFgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792320477; x=1792925277;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ycigQtHDdSm8L+VPTdesboZLPpIJ02aiy7LDnRARo9M=;
        b=PmI3dXeBWFVR/m17hyl905ytCKazRKUrzxrOccywGG3omjh+mGVdgcMY6XVSBpatEe
         z9lxXQmdlMxQmUxuDVddTjciTrbVAI+2lngEXZ1/OxUR4Oy/i2jlF275aKucxYWdmkJr
         NEBpD+w3DRiuuJFllbWJBpk996U4w42F1AsbtsoxXJIVR+qK7DSQoxJoSKcJa1LnhSL4
         VQPTU5vYTUVUZgtxFcu8v61W2I64voNp52JpYxCNE1YVORCA20mF+PT/hR65mYl6uzT5
         v8yskoj9mkOi4cXi5lq5QPU35ucEf58JkoQed823So6FRvA7iXGk5KiUGsWEQz1Luqd7
         OEXA==
X-Gm-Message-State: AFq9FYI3nVhpeLx4fWt0VVl5oaHZCc+b0iuRo52DVULMKV1SQVkuNPkg
	qvvvsOdAkyyqAzkMKBBCE3RPsZSZFYE6URLx+GrmUi/kzl5knjoGVakib9XmCn6/8GIlRbGIDYi
	ElVDwVrI31aCdZhG7/wvMx0QiT5UeCe4=
X-Gm-Gg: AYBFou1r5/2wYpoSWJEEyPw2wr8Ph7CBTNd8X7wNTgLXibfjvUZXnlI0We5jPZP4nfc
	LSIrh9sBiCAwPBucFg0qm8sM/vXO/xi+Ch3yk0YrBDFoy2iFIJlU4M7ap+YjjMwubswXOAnU1Wv
	j7AideFNsoy/4ulY5qFlGsjLV5xB/b751rqxLybLADcAZhxWss/1BPdaS1+ysYP/VTe7Ct9fgK6
	vd+HnV3RF5+k1dg2BRGFllHBqyYwNBPV/lbb1wWdHC45gxdLPyoCh46eef30OO1Xh1JAKH5ulWD
	K7UYBPLgla/1U+FZiay7GblZOxHRwWAozoRe2T8qgqbhVLrSqB/lvD+3hR1/s33pN+rlSHgdymA
	IvDbEcBj1X0dJccGQcZjCdjbFhiIxkAeGWRXYDRuSX1c2
X-Received: by 2002:a17:90b:2e45:b0:39d:e445:1d44 with SMTP id
 98e67ed59e1d1-3acbb8e8f6cmr5919915a91.31.1792320477003; Sun, 18 Oct 2026
 03:47:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261003021147.7461-1-kartikey406@gmail.com>
In-Reply-To: <20261003021147.7461-1-kartikey406@gmail.com>
From: Deepanshu Kartikey <kartikey406@gmail.com>
Date: Sun, 18 Oct 2026 16:17:43 +0530
X-Gm-Features: AclHuK-LRWf_G2BiEQ3NqCsZ_mjE4ZKFwitU4ANfQ1Y-g1uQXxMxATjLN8cVQGY
Message-ID: <CADhLXY6MVuBnfKaTiLUXcsaT4xnarVYj7uAzJSqngWdJ4aRKJw@mail.gmail.com>
Subject: Re: [PATCH] wifi: ath9k: stop WMI event tasklet from rescheduling
 itself on probe failure
To: toke@toke.dk, jeff.johnson@oss.qualcomm.com
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+e91dc13b1b37759b3d9f@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 3, 2026 at 7:41=E2=80=AFAM Deepanshu Kartikey <kartikey406@gmai=
l.com> wrote:
>
> Since the init guards were consolidated, ath9k_wmi_event_tasklet()
> reschedules itself until priv->initialized is set. If
> ath9k_init_device() fails, initialized is never set, so the tasklet
> keeps rescheduling itself while the probe error path calls
> ath9k_destroy_wmi() and frees struct wmi. tasklet_action_common() then
> touches the freed tasklet, causing a slab-use-after-free.
>
> Make the tasklet drop its queued events and stop rescheduling once
> wmi->stopped is set, and call tasklet_kill() before freeing wmi in
> ath9k_destroy_wmi(). The probe error path already sets stopped and
> kills the RX URBs first, so the tasklet cannot be re-armed afterwards.
>
> Fixes: 1af8dc9ca726 ("wifi: ath9k: Clean up device initialisation guards"=
)
> Reported-by: syzbot+e91dc13b1b37759b3d9f@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3De91dc13b1b37759b3d9f
> Tested-by: syzbot+e91dc13b1b37759b3d9f@syzkaller.appspotmail.com
> Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
> ---
>  drivers/net/wireless/ath/ath9k/wmi.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/drivers/net/wireless/ath/ath9k/wmi.c b/drivers/net/wireless/=
ath/ath9k/wmi.c
> index 4a08babb6d9d..f8b174b0f209 100644
> --- a/drivers/net/wireless/ath/ath9k/wmi.c
> +++ b/drivers/net/wireless/ath/ath9k/wmi.c
> @@ -122,6 +122,10 @@ void ath9k_stop_wmi(struct ath9k_htc_priv *priv)
>
>  void ath9k_destroy_wmi(struct ath9k_htc_priv *priv)
>  {
> +       struct wmi *wmi =3D priv->wmi;
> +
> +       tasklet_kill(&wmi->wmi_event_tasklet);
> +       skb_queue_purge(&wmi->wmi_event_queue);
>         kfree(priv->wmi);
>  }
>
> @@ -148,6 +152,10 @@ void ath9k_wmi_event_tasklet(struct tasklet_struct *=
t)
>
>         /* Check if ath9k_init_device() completed. */
>         if (!smp_load_acquire(&priv->initialized)) {
> +               if (READ_ONCE(wmi->stopped)) {
> +                       skb_queue_purge(&wmi->wmi_event_queue);
> +                       return;
> +               }
>                 tasklet_schedule(t);
>                 return;
>         }
> --
> 2.43.0
>

Gentle Reminder. Please let me know the status of this patch.

Thanks

Deepanshu
