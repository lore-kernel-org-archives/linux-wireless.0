Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CD4C2AD0C
	for <linux-wireless@vger.kernel.org>; Sun, 18 Oct 2026 10:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792320892; cv=pass; b=FGpQVtnwCHnI8io71yEtntgwibnL1/0HWmMz522tstzirr9LbUYMWSDTFbMpbe890aqa9y++5coXABkwl6Y6si7qWy0vzM0jTkA0kR70KoNoFOJkcAi3BZyXqhimXhBwBp78KlyDnvObAq6Ye0UuXYk4HA02eaKtL8vuiTcz/LQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792320892; c=relaxed/simple;
	bh=m0vNKj37Dx1kSLJxWQpTeonH55Ff+hPdWeIOVcPDffk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EcOtrulxA3qcUuW4qOczee0mprNy6zcMR7cPXXs/eBtKSY4yFSWigGzMoyXLtdLRgCY9XhyY4garBUyrbEVm2/52l5rT9hnVSa87YeljLZHh8HECqof0Kj/GeuG/HgDUIgTRmX/yrZuiqbYIEJpg958gD1Aosoeat59Ebb+jpJI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N1ngH2nY; arc=pass smtp.client-ip=209.85.128.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N1ngH2nY"
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-8ac9d666d4eso8263097b3.3
        for <linux-wireless@vger.kernel.org>; Sun, 18 Oct 2026 03:54:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792320890; cv=none;
        d=google.com; s=arc-20260327;
        b=iIJuU7eovlB76vlfx8fJ06jDomXDZ4v5M3VXcz6tRVqJLWxscdlvHiwfWFIJ3VBgYe
         gBUOIgx73qPdhJvsDayQJLGxSOMWFEpZf94xA8lxHQqmZCfdc7tG7K9+nWBjJHz4PLkT
         D0nfK0Zd39w/z4+GbwuocqOzpBKNdD+mg9p/ypkdntV8mo0Fe0GR9XDF1TRyet7fT/zL
         m6uElXUo0OCqEl3l/QlRIZ3qcne9DsR9nWQ3VvdZC/GJOizQftaeBh49+PuFWxApr8vQ
         MohEC7DG1uvSC3mJlg6OeHOeonAJ0covQiHMTMO8tuXFM/UvtTR0lbFOPYzlTbJQSs5b
         rqXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=XauT15gH6AMZryvE1s+Yc9Wz8N1vaO3g3sQyuxDOI+E=;
        fh=gM7U4zh8cHfaC9HwkEfsLrE/YFSAo7GZyH3GmXfcl8c=;
        b=BoDxdZsB+LHTQH0+su6AvPZ/1Roxw435FIoqZXPcTLrcaK/CtvFQ/2NvpPs3qE37m+
         rc56zexhLh/ddh7rDiftWXUSW1yiRcaWoVFVzLbIdRSiQpwlSYOWJxMPwYt0JQ0WHvQ4
         21F2W+sfSl+NNhxa2il/fRBBFwqnvEo56KkT0/MRdfRzfcXzs7vqw1/nECmJmrtyCbZb
         6ZbdnFipVzDKc8xUkxQrsODZoprRS6RSzc5qjzNZEyq/z6gFfPeN9ueZTvM6g84GTYNT
         lOsmkwV45YkiLobZc39Y7XQKsln8P4A489MzEA1Zh0w1hKleLQ8EANueCuBXz3fDKrsy
         NrqQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792320890; x=1792925690; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XauT15gH6AMZryvE1s+Yc9Wz8N1vaO3g3sQyuxDOI+E=;
        b=N1ngH2nY8+6qxGw3dkqvXUc2d44irw/49pZa3Ml/bIzPJzsMpRPJiPsfpHa1TGjy9s
         fu0h5PuyiL6GMouChKGG9PKy/KAUQE2JEHqNKEYoxAiV8gfb9v4I6eftI2UPSuSpUv/P
         x9hrjCpNT5J2jEdeAnH83EXhTjla4v85gnwlQSC0Unv6xdMECZ1YF1OYT7UWQiS2pUjx
         hkSTw/YFsNFuxAogVQi2XCUjy3+V/Bv+DUw8EH4n91jngam23JSNKhNdShM8lN7rCAc0
         XWerw0qE/q757fqwO4Bed27BtuNsxVX44zfkKv37rs6q4y38vUPLCD3dFoLk7gvKa25F
         7XtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792320890; x=1792925690;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XauT15gH6AMZryvE1s+Yc9Wz8N1vaO3g3sQyuxDOI+E=;
        b=jhSPAUZa3GEDzb0AQlUU1x5d/mSfQkFUGqfvs8Oi0Ei7WAVf5EVFEFDhIwMxqPLKEc
         0hCxbMXlAxeVPfWDYFLR5CdcHRhJ5evIpsyi2v2JuzFn6f0t9iLikvC1O3bVVE2ereny
         ph3roKSXGRylbD+jZ/j9Pur23tGbjNJD9hvzwjB7bNIUAgsCtkL43kECBbeC3pZ3PmoU
         pKJQcQWqVkuvtUxvLjCkALLhnJ3huMXENrwPyPrzU5mG9Pfk3n2SIfU3/YB6P92OIhyi
         9kuh9y5+dY0fU7pm4tIuG3rX3jMCKOZmk8iJenBuZnMuOhbzNlHU2eNKbHP2I/ulD5Ue
         niRA==
X-Gm-Message-State: AFq9FYJf+5H/qrNtPn0SyhFtTk5Jgcris1//3JDcCTNJuRgzaYmfebgI
	zKK5VgKSuzZP48pYourSJNCIvmAO1dl5pX0jGOLD4QLBqPteVysYOfdl20kOjz6tVmKw+Tn+8Xi
	MdBchWJU/cnImZbG2i89TUDVxNC2bnvHwkw==
X-Gm-Gg: AYBFou1AT2cBVTWsrFqVWhDRhLo4/8F3SoxSkL54TQgHtrVZO0K8NQXsLYqscfyOQJU
	XVwyDOtr5oSKbpstiiKMZgtbmyxh8ZFDNHkiThpRhWDZcLe492o6171+anNvTsaTwX5z029+v9E
	ZKkPc/WoXE05TP69Eayywjf6rtbe54vAuZv0/bL+OWhokdXGvMb1haxXAsSa5gWVW4FO+9+cr0H
	fMjd2TIEAADgL4E6ytGKqS3BVyrTqz6yEb41Y8cWVA+uJS6kayCvbpb2mAk/WfcHoCKtfyTDASk
	wizPg1P2KC09Sdfvtrl6d0NbzFE5XoRkkalBAXff+RrBzeFjNyuTW2lUudh0SEt+xEhvNbw6WCp
	1Opzd9hPh6IuW2GT16uXgncBJZEsKccG8aZpdwkKwy1Kh
X-Received: by 2002:a05:690c:a0ce:b0:854:819:64c9 with SMTP id
 00721157ae682-8b0f2164ca1mr10225167b3.30.1792320890455; Sun, 18 Oct 2026
 03:54:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260910041047.24437-1-kartikey406@gmail.com>
In-Reply-To: <20260910041047.24437-1-kartikey406@gmail.com>
From: Deepanshu Kartikey <kartikey406@gmail.com>
Date: Sun, 18 Oct 2026 16:24:38 +0530
X-Gm-Features: AclHuK-6yjg7RbNkD8czAob004XPvB8KF6MNiLIEn6GLCPpozQPhRH7qKM94mu0
Message-ID: <CADhLXY7-EMwbczPhKjUFPN0Q0ie5NSNw8FERrx5sC5o6aG7KLg@mail.gmail.com>
Subject: Re: [PATCH] mac80211: fix using smp_processor_id() in preemptible
 code in ieee80211_tx_control_port()
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+d979bd35c8a76fd1b6f5@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 10, 2026 at 9:40=E2=80=AFAM Deepanshu Kartikey
<kartikey406@gmail.com> wrote:
>
> ieee80211_tx_control_port() can be called from nl80211_tx_control_port()
> in normal process context via netlink sendmsg(), where BH/preemption
> is not disabled. dev_sw_netstats_tx_add() uses this_cpu_ptr() internally,
> which requires preemption to be disabled, triggering a
> "BUG: using smp_processor_id() in preemptible code" warning.
>
> Fix this by moving the local_bh_disable()/local_bh_enable() section to
> also cover dev_sw_netstats_tx_add() and ieee80211_tpt_led_trig_tx().
>
> Fixes: d5a014204a3b ("wifi: mac80211: tx: simplify control port frame tra=
nsmission")
> Reported-by: syzbot+d979bd35c8a76fd1b6f5@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3Dd979bd35c8a76fd1b6f5
> Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
> ---
>  net/mac80211/tx.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index 74ab27534076..7b1a3c63e5dc 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -6687,10 +6687,9 @@ int ieee80211_tx_control_port(struct wiphy *wiphy,=
 struct net_device *dev,
>                 return -EINVAL;
>         }
>
> +       local_bh_disable();
>         dev_sw_netstats_tx_add(dev, 1, skb->len);
>         ieee80211_tpt_led_trig_tx(local, skb->len);
> -
> -       local_bh_disable();
>         ieee80211_xmit(sdata, sta, skb);
>         local_bh_enable();
>         rcu_read_unlock();
> --
> 2.34.1
>
Gentle Reminder. Please let me know the status of this patch.

Thanks

Deepanshu
