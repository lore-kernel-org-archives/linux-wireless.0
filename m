Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0547945041C
	for <linux-wireless@vger.kernel.org>; Tue,  4 Aug 2026 10:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785840388; cv=pass; b=USbx2zVCUTUe86o/EAuLcHobr1g+43kKIXnP0JRSTdQxgdCz/DCTlQhHaQEe/FLr7y+58bP9q1cFihdWjku3gDd4pvQ/LiK92X/PlfvxdSEvpl5mte+gDlmsYXSVwtdOdj9hvenMMoG4ZTCWcsevCfR1KlwLzgEwbNrH5pjPxHs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785840388; c=relaxed/simple;
	bh=L4pVXJjEpzP7a6JTASFd5jgksujhFZUMubTVjmSZMj0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=d7q9QtbdsaxQc7pylfjodQasHGgd6MqLWkLTetEycIjuzvrGKiWd1Cfspaf84yRiA+5xWAhZGkFcF7jsEJdWoecMfoPPWdSQ1/lsrqq0/y+lGkKgTdiaNbuB+wP9cqChn0ls/mtiK5ptdIgRMrzTu6b7g/Id905MVC2AzoKaOHM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N/fZJB/v; arc=pass smtp.client-ip=209.85.210.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N/fZJB/v"
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-7e9ecb1e13cso4937773a34.3
        for <linux-wireless@vger.kernel.org>; Tue, 04 Aug 2026 03:46:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785840384; cv=none;
        d=google.com; s=arc-20260327;
        b=PfhFo0xyrw0zIT+PGswe3/hN3U8dlS/mAy+UVtT3WjF6Yf3wsBVN34QxwGJgquLJ09
         b+EttSUt1wafNJ/D9Lo3n03QqR4IlkXPFV/gz5W9EqAxivswmpx/loQrG/dy4qSl5hj7
         9OX2YffG1dGcdpMKGj3BqV1L41+77saDVPasOZB0AQGEOzbW+T8xYw2liUbh9bv0vC8D
         0sEnYXrewQwb5JLtBEJg8H4gdJHgKfX/CQQPFLBy1bAeJxsplwb4ZMbXntTEyHHpufVo
         Pwr6frs0VXPJRUMmtqkr8rJYIvQhNQLLFT8JlsB20iyKpEpsoPxWK75Fcx+ZO6zil8nU
         hlHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=J6gF+Q6fG/qRNe9EMJ3JBoepBuQH8FTOnfFZfpMVvKI=;
        fh=H5xszCYfEOnQSGGoqoRuRq7jfO6SkR2eYAKwQaT+5+E=;
        b=BeRYwci2UiPntU+WDCV1BSIxQJ1UrF3BKEFHbNCO0sBhO9quE5rCYN3L4uYqK7mDR8
         8gDA4b19KbVLvXTAvnRLIuHx/Kx3lK2Td68Gt7BHVZyc0lBDSM/pvC5DTEUG60bYweDs
         YSeQhKS9asdKMfIJtA4y4ldIoWfs1ddoDXEgblw39UzQi+P+WaWeqyC0hiBFVZi4VEyq
         PNFHDYIoI7Tlw8kMB21F75AJ2Zd1cpIvPuhsFtL1cw7uqXJI/gK4tSGmD1zaUt7L/ccM
         ZQsZqJLCgfoEzwPiRmIfQUeBWDkGXgq4C21D+kdJQCkAQgxu9IG6NIHGkS1LswQ6cdZk
         PSiA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785840384; x=1786445184; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=J6gF+Q6fG/qRNe9EMJ3JBoepBuQH8FTOnfFZfpMVvKI=;
        b=N/fZJB/vUoyRafM/u6g5EqR+Mnoo3RDPXUFk927HxUH9UogB/oOnoF+RCsaPXIZx8J
         KsSY8xOH9l+9QTJEms7nhTSV4popxB2P8ytD+3S+LM1bAu+9nVctZDWX2WdGYV7Yn4Al
         T7eq/UQZVSEBSxYnfY1jHO9cwLOpb/TxtFgp5hotjRWA4Up1fFtxiuwynoepe/5I5GKb
         uaw6WhSql2x/7YYr6/PDKzYzeu579efFN+U1b1yyhGp4zqNmyBFy9XzHNUDnVQuyzeh5
         bmC7wDYUXmeo93zx4YuE/jZ2pHIXzrpXjYNMGMzfMbC9Yf0DfLi5RV27/7LoCFU9joCr
         bX0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785840384; x=1786445184;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=J6gF+Q6fG/qRNe9EMJ3JBoepBuQH8FTOnfFZfpMVvKI=;
        b=cBU/G2eNeYs+ARHJeVJA+JW+zegxjR/zqPnENEG0skuSD6I0xsWAKZVtqMCZ6Ed5Ae
         PPOJZy/UAPIKXmPb/OIbKLPcZq2Xi9hNM3zNeUidtMnwatV+DrQE0XP+w43vfbKgenR8
         H877GUPzmCHwarfrAtnwNiXkwNDiNajtxE97dFxq1X3tJEtHV6rvVHXgVpst7+NT3s2Z
         Lm2hlbe5Hx3vy50qq6uTm3qWRndXpefO9eHQyOdcH9UULUm/MLibtNSOeUwsxDnrsQs2
         hugvOl9nN4qnkAWltJyZSb9wrclU8LA0mDHhcOcWYVELhGgd5Ua5owUU5VgDoU37OUmc
         fAwg==
X-Gm-Message-State: AOJu0Yzl/4JGRoUsnbybXzk/G/9/tYvgBCYN5AoZaztVcMxbPJ7ZUEYj
	iZUdLYPLgQNwl8tZ9V/uNWnf3WRNBy/+sL0ZUW2Edh18LULWP5CNqpztY4ayiAz2J+ALfSe/S3P
	u4zbbdV/GOshqjSMpFqwAp8+ud7Oq+RY=
X-Gm-Gg: AR+sD10xAV8uMQMjIDMogR61AJnzU/I4vLdCe6m70c2vr855pKPqWR/gpRnPNVVCzfZ
	kBVy9oU+Tz7aLcH3jHgEyzdcOO4IYvQwFNlUVN+ZJTLm8Fcm1KlqOTgGVxin4yDRN2dqlU2tS3C
	uqJk6Be41bwQVcCJ5bGC/YzuHPgxVpOdhFH6eaTpNDNIvfHLUJcfpuuMuYSblUCqapQjBn1H81q
	z0ZK9kdJk59GgKvJHDuIBq7Zao2ZtTqetPgRgsEEEHZ8lLCmsr+fGqCS1WmZ8fEHpCB6bII29am
	BpwRk1ZBhh9Gb22Cgjl7jdb/z2Pa4OzkS6ISAnx/4VzCDUA=
X-Received: by 2002:a05:6830:2106:b0:7e7:352:2f74 with SMTP id
 46e09a7af769-7f196ef1886mr25159269a34.13.1785840384046; Tue, 04 Aug 2026
 03:46:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260728002048.19351-1-mikhail.v.gavrilov@gmail.com> <013a295e-faf4-4930-a101-27cfbf252178@leemhuis.info>
In-Reply-To: <013a295e-faf4-4930-a101-27cfbf252178@leemhuis.info>
From: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Date: Tue, 4 Aug 2026 15:46:12 +0500
X-Gm-Features: AUfX_myTz1AovWD-dmS8V3XgQ6MELh4yuEVac8YUyHla3LIgNjeCUwhYlkCyjFQ
Message-ID: <CABXGCsOAK92WxxLyYVfVrdEdLwvZh0JK5RJHn7J0X0mtCD3bkQ@mail.gmail.com>
Subject: Re: [PATCH mt76] wifi: mt76: mt792x: drop redundant napi_disable() in
 unregister path
To: Thorsten Leemhuis <linux@leemhuis.info>
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>, 
	Lorenzo Bianconi <lorenzo@kernel.org>, Ryder Lee <ryder.lee@mediatek.com>, 
	Shayne Chen <shayne.chen@mediatek.com>, Sean Wang <sean.wang@mediatek.com>, 
	Nicolas Cavallari <nicolas.cavallari@green-communications.fr>, 
	Bert Karwatzki <spasswolf@web.de>, linux-kernel@vger.kernel.org, 
	Linux kernel regressions list <regressions@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 4, 2026 at 2:29=E2=80=AFPM Thorsten Leemhuis <linux@leemhuis.in=
fo> wrote:
>
> TWIMC, there is another report about reboot/shutdown problems with mt76
> that was bisected to the commit mentioned above:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D221818
>
> Pointed the reporter to this proposed fix two days ago, but no reply yet.
>

Thanks for the pointer - but please do not point people at this patch:
it is withdrawn.  I asked for it to be dropped on Jul 30, which was
before you sent them here, so you would have had no way of knowing.

Eric Biggers found that it introduces a use-after-free.  With the early
napi_disable() loops gone, the RX poll can reach mt76_token_release()
via PKT_TYPE_TXRX_NOTIFY and mt7921_mac_tx_free() while
mt76_connac2_tx_token_put() is running idr_destroy(&dev->token) outside
token_lock:

  https://lore.kernel.org/all/20260730050428.GA73812@sol/

So it fixes the hang and replaces it with something worse.  The diagnosis
in the commit message still holds - the hang is a double napi_disable(),
which is not idempotent - only the choice of where to fix it was wrong.

I am posting a plain revert of 13b7e6a96a00 instead, as [PATCH wireless],
since the regression is now in its second week with four independent
reporters and nobody has objected to reverting.  That restores the WARNs
in __netif_napi_del_locked() and page_pool_disable_direct_recycling() on
mt7915e with an MT7916, which is what 13b7e6a96a00 was fixing, but a WARN
is a much smaller problem than a machine that will not reboot.

Doing it properly means adding napi_disable() inside the drivers that
delete the NAPI instances - mt7915_unregister_device() and friends -
rather than in the shared mt76_dma_cleanup() where the timing is forced.
I am leaving that part to Nicolas: MT7916 is what he reported against and
I do not have that hardware.

For the bugzilla reporter: the revert should apply cleanly on top of
current mainline, and I will follow up with the lore link once it is out.

--=20
Thanks,
Mikhail
