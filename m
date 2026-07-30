Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05B64385D99
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 07:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785395234; cv=pass; b=eOZcJpCUgZL/T28JMpBVP4LYPOocqwRwMAPp6wXjkoHLATjpIYmN3gH20mADwG7xqNP/O551ictfArLfK55cRNElcOtKiZznZaMisocoGQW6KhqDoiQ08znr6aPK89sB9jBjSRP5urN5mLcOleBfjWapGAwe1U3IcuUXKFlc7/Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785395234; c=relaxed/simple;
	bh=q2qdqut5pCnKCW6FZjO0/udV5NtmuesOEQ0uwvdd0Dc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RBPdmZOkxfnT9gxmRVROITKPjmKMkFkStxILFm2UbrTNY5bWM6w+ej2AZJhJux7TX0Q3fvDGjZygtuLlpmy53b7d13pTFqgQ7NliVa6TcDsfY8bZZHgwe73FsGlLUvyeNFFOWm2bhQuoSWoBkbIbxZH7tTvOw8DpMlg+Fq/fYys=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B8LBJ5u4; arc=pass smtp.client-ip=209.85.210.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B8LBJ5u4"
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-7eb42a2f5feso849330a34.1
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 00:07:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785395232; cv=none;
        d=google.com; s=arc-20260327;
        b=TzOoapub89lBmPr2wwUHQ2sVhA8hIkm+VAnVvhwuh8xcvxdNNYSRLVsXpBc2ilC6sq
         sA+ynpUtSO3W3PEpWqu2NtCH43b2k/2y1GHztGVY7Rlc+Q+XP0wFA9kZyvb+s8xKvejI
         6Yvr+bVNQalM0llRbUQD9OUIttjANL50Eyys6s4+xJdzOCYIhvoOHYjqRXPVz8gxkUbB
         Nn7MtjHuKO2epNdC44/lZpI4ws/SCMW/gA59Jlmolk4fPmZcHQcTO9AI2D0RN1g5FyJQ
         VIq+nTFT+2NHWTtHp6Czl9nDFZoL+UTx4UGgg7ZnxSFMca9b/7CfPh92AqZ2hXIgiP9r
         jS7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6Dg3CbZWC/W/GEgL/O8IF/XUoCjtzCSBhg/Krp6alsk=;
        fh=tJ4ZkIq8u0inToWOlnPCACLiwq4GJ7zWVW1PL/Zo7Vo=;
        b=ZaEKVFpS+asf/Hu/unoRmCRn84dV3c0R1b2luCOM+vWLfr1RzCX7ova1UtfTVC/H4Y
         +NfIAht3/domYgrmrse+WaOY2zQxDLFquJEHw3edWOPxKqFTARuJO901qaSXMXabztdo
         pN8zuy6oNJVTGxHFLS1RIK4VbymU2JkGTWaDsfMpwFeONYnqNVhagWO2omYPxGMJ3xrB
         nHvcP6YdqbH0wqLnqiu0FV2TGUHNyvU5GW+oNHZ+txn3jsMeSKzsNuWt9xFZGeQxpmbr
         L0ezRaKB43OILrH443DsfeEQ55FMYAJpE5waK0dqggYyT+psFW5fsM14k7fZPYMcpbZp
         9Bfw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785395232; x=1786000032; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6Dg3CbZWC/W/GEgL/O8IF/XUoCjtzCSBhg/Krp6alsk=;
        b=B8LBJ5u45OR71y3H6AWrwjAz29tRTymm7B3JDx7B7DxYIaE8aM+1ihS3wbKI1aLVMj
         R8AsTdP0U1cZNPDpTy3eiCmgOpe+O7qCjP09yAdJa/+P/mUy4X27HfpvlVcjyPxARh7x
         EmebNbP0Gs5XseCRIJxXWO9UFc4XXPIXtpVU0jhxqzbOe9aqvgQXbDsGhKySEbTmMicV
         ChdtzPRFoD649OGf9kMQJkdIaq3CKcVbH4dceR7+x95TmyGM3pH0SGZOyynSR6XP0sq9
         4LHY5xs3EuzNdB8Jg1YtXNQlWhXBaibY1XjG5Hq2Pdmp01coJfEWxNPbsPgzHPpfKwJ4
         /9qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785395232; x=1786000032;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6Dg3CbZWC/W/GEgL/O8IF/XUoCjtzCSBhg/Krp6alsk=;
        b=jYSS+P+Hxc+AzXrvunHIgdbFZlRQ+lYn7bCQljidLBqToyksKGJlLJaPwr4HeLJZ4k
         VeZ70UEuVP+JXXx6MZP8iZgYQTJSwDa8Oii2PGdZpvoOhW9ZQCi4COF9BM7s+3E/zZcC
         WKOdrAmZ8qhL6K0liZcFvYvrPtiFci73RwOAhF7MyJN/GJ2ZFyFrKBN99ui2wP7zeMNa
         0ygWQkKmdrb1ZqzlPgdJiFJFudYOThX/3G9EKQySEgXSUtAg5kgCIQWETihQcn6KBrWO
         aHHtToKSno5gkCjpDTDRWQOdc7Mzxoy3DbT3JSaxz3K6ETmun2xrwaMQFrpNW0Z9URbW
         ZT9w==
X-Gm-Message-State: AOJu0Yxv5oepq3kvP6QL8shAJZtHqHIYzVdE3WPJVTyG1k53eGll/2lO
	GdNMIFNlWQLAq79VSuRnhGwyUpILDTWlF7GhBH3MA0i3B8Yvn1djMMdXeOicOfvxUvnz+EI3CJp
	vmsVge3GV1RvONg4gHPPhx9ZG3vXOaw8=
X-Gm-Gg: AR+sD10UCq7Z0uDzJdc8lyMOdjSLLjQVaZItFlwfYu8ah7gzXk7VBFFSsiBbqU3IHUQ
	1p++lf9lmASL1FubQ/2z1dPDzb1UeMkdCYXq4qIz5Kd7dLQhJcaTwmYCzjsnQWXpjavKH/NAAJS
	QVoSRAy1Gzw+Bvh155p8s+R+PUScmAKOH/Z/dJ1R7pizObb1F/If7gFDUGJf88lYioxuz8yw//w
	KPRQ7Lnqabuv+gNOh2ni/Z+NridmbXh/wTbhNOQuWo6eYdVKEslFBeonXbV6OPujbUkVDS+fgUd
	ekk2RWf8jF3kL8cBA0JCw9hC/TajwKxSz0URR7w9Z44NPQ==
X-Received: by 2002:a05:6830:2909:b0:7e9:e100:71df with SMTP id
 46e09a7af769-7f02c0f9825mr686596a34.17.1785395231764; Thu, 30 Jul 2026
 00:07:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260728002048.19351-1-mikhail.v.gavrilov@gmail.com> <20260730050428.GA73812@sol>
In-Reply-To: <20260730050428.GA73812@sol>
From: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Date: Thu, 30 Jul 2026 12:07:00 +0500
X-Gm-Features: AUfX_mx7JghyRFSmqvOY_EEtJUYTljkb0LK53AFxCDon2J2j3RLtZdmK9zMeUA8
Message-ID: <CABXGCsO07SExb+Z0PeN6MZ1fKC24Tvn3ehSyeQc-3qFC7jM7dQ@mail.gmail.com>
Subject: Re: [PATCH mt76] wifi: mt76: mt792x: drop redundant napi_disable() in
 unregister path
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>, 
	Lorenzo Bianconi <lorenzo@kernel.org>, Ryder Lee <ryder.lee@mediatek.com>, 
	Shayne Chen <shayne.chen@mediatek.com>, Sean Wang <sean.wang@mediatek.com>, 
	Nicolas Cavallari <nicolas.cavallari@green-communications.fr>, 
	Bert Karwatzki <spasswolf@web.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 30, 2026 at 10:06=E2=80=AFAM Eric Biggers <ebiggers@kernel.org>=
 wrote:
>
> While this patch fixes the shutdown hang for me too on a system using
> mt7925e, Sashiko found that this patch introduces a use-after-free
> because NAPI is now being disabled too late:
> https://sashiko.dev/#/patchset/20260728002048.19351-1-mikhail.v.gavrilov%=
40gmail.com
> Should 13b7e6a96a00 be reverted, then fixed in another way such as
> calling napi_disable() in mt7915_unregister_device()?
>

You are right, and so is the report.  I went through the path and it is rea=
l:

  mt792x_poll_rx()
    mt7921_queue_rx_skb()
      case PKT_TYPE_TXRX_NOTIFY:          /* mmio only, so PCIe */
        mt7921_mac_tx_free()
          mt76_token_release()            /* idr_remove() under token_lock =
*/

and with my patch that can now run concurrently with, a few lines up in
mt7921e_unregister_device():

  mt76_connac2_tx_token_put()
    ...
    idr_destroy(&dev->token)              /* outside token_lock */

The early napi_disable() loops I removed were what kept those two apart.

My justification in the commit message was that RX is harmless once
mac80211 has stopped the hw, because mt76_rx() drops everything with
MT76_STATE_RUNNING clear.  That only covers the normal data path -
PKT_TYPE_TXRX_NOTIFY is dispatched in mt7921_queue_rx_skb() before
mt76_rx() is ever reached, and goes straight to the token IDR.  So the
window is not benign and the patch is wrong.  Please drop it.

I agree with your suggestion.  The disable belongs in the drivers that
delete the NAPI instances, where each one can pick a point that is safe
for its own teardown order, rather than in the shared mt76_dma_cleanup()
where it is forced to happen after the driver has already freed state
that the RX poll can still touch.  mt7921e/mt7925e already did it, and
early enough; mt7915 and friends simply never did.

Unless Nicolas would rather do it himself, I can send a v2 series:

  1) Revert "wifi: mt76: Disable napi when removing device", restoring
     reboot, poweroff and module unload on mt7921e/mt7925e
  2) wifi: mt76: mt7915: disable napi before deleting it, for the
     original __netif_napi_del_locked() and
     page_pool_disable_direct_recycling() warnings

I would keep 2) to mt7915 for now, since that is what was reported and
tested.  mt7603, mt7615, mt7996 and mt76x0/mt76x2 have the same gap in
their unregister paths and can follow separately.

One more item from the same report, not caused by this patch but worth
someone's attention: mt7921e/mt7925e call tasklet_disable() on
mt76.irq_tasklet without a matching tasklet_kill() before
mt76_free_device(), which can leave a scheduled tasklet pointing at
freed memory.

Thanks for catching this.

--=20
Thanks,
Mikhail
