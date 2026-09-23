Received: from mail-yx2-f42.google.com (mail-yx2-f42.google.com [74.125.224.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93BEB37CD2C
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 03:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790133888; cv=pass; b=GZ4Qs9W7TYXF3CVw350iGPS1Z/2Bi+FYWLuBiz7D5ZVhjvuoJFckyse204BsaLoXhUKse60+91rRQv0JZBQ6V3WEG446phkj7s03FhRxTvnvxh6oqk7V+/XY71aBIo5xVplcE+eg0fAEukIRCf/rH4+cSmwF/XRQv3OeM0wi6/A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790133888; c=relaxed/simple;
	bh=DSWeIecAf7yMhlXesBdwg+3lyF8bl49YDtQr18mW7LM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uDw3rONLzTsp4c4+THb8hnOhkFLoMp/vbr7QwJDVuqjUIAAO1hGSxrvm/ZBF+XEw567twvLExpMaPKuBuoKnNC8LFVs53OZV3ImxUoj4H0qTuVu7EQnsMMxMfjNqpBgI6yjZ7r77XeQRHfduip5VXk7UmHHpSDks7yZ50SSJW9c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y1pCjiYb; arc=pass smtp.client-ip=74.125.224.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y1pCjiYb"
Received: by mail-yx2-f42.google.com with SMTP id 956f58d0204a3-672ce86b21aso555824d50.3
        for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 20:24:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790133885; cv=none;
        d=google.com; s=arc-20260327;
        b=VoRZKtzjVT3nLyui1DMxiTs3JXhN+ppBmN8yo+V8MEGZ6n5XH47+/SaKPllw/1ir0y
         IHNAazFjBF3oBpJoJsvQPI3LKsZucxyxbKdhpcTtM6KItZq4oqwl2c706sDHL8BpIX6X
         9pkUAsLqxqgFvVsv+KfBPFST/+c2zVB1XwYY3BUo7ylMS453aqVY7f6ooLuqb8FyBxHM
         P6SdWUvCh9JLH3dCGp8Gb1vwe9AXJWgusEMBAlcKlWl7ydzPlgxGn2yP1ufBcvtY18HL
         LmYOnrLp1tkpyjFUxO6/c9sWsRbrJHWysugxOFx6biziyEJ3YPTkaRfvSkQKfzKDHt7g
         bLtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=JvJYAxC3BFkryMHCPPUutRIKj2Els96Oe0pXTAumBDM=;
        fh=gM7U4zh8cHfaC9HwkEfsLrE/YFSAo7GZyH3GmXfcl8c=;
        b=UXgFHZamk7VBrNoqmXhUpyssOY+pYhQYIiM/SahqHrXeOjqyVXSpGhIwHYlYhkw4oT
         ihpxhx/ZzDHOvwMEDW1sgKm5h3ic2UYD2mHLC8tIwKicrLZZxx/x/m9FiBw6IdtXP90K
         75aDV89Z6DUOWOeBW4wkStfN7gDYp9eJnviLyPUzrhvj7vgJ1RwQVZWGimo1QR7i6o6S
         VTT7lwV3NQtBJliwNV7DNMXJNamtqmS7WQoy+lvAlI5BfJZw9ZRy4CrM2XFBOoObT9hY
         xoz3OKlu4c93fIRbT5OyMddRIY/0Tg8rTXSQpmURmDckNrKsle6l5R8x139MwVopqhdj
         PMiw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790133885; x=1790738685; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=JvJYAxC3BFkryMHCPPUutRIKj2Els96Oe0pXTAumBDM=;
        b=Y1pCjiYb9pLt1lA/IWGNYqvQWIAGoRuvu68pVduzurD6Uw27P9N8WQfKDxGZaAztmA
         PbrOCocQ6NDFZbM/vdeuQFtzQyP6hWudcqMt7V9V4qn1y7RoIH7vlBpAO1/hsh6jyaua
         wIlPmajTEy8zA4rX2qRj2VqGuqLbUWF8HS/kWOqNhsdwwdR3B8chUI2gAV6pUy6wXZZ/
         IN02Z48sYAvQC1eWeYM3m1lN3L1NdKMZP0znwa/Glh1oJLGO8HLKC5pzHlDgJTSfzg+8
         74JQq/ZBJ3VWRPoyz5Snb8wUlkwau0F/qdNSwM+gsUIFRHQQd8Ncmvik4WMqNdr1glnQ
         VTUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790133885; x=1790738685;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JvJYAxC3BFkryMHCPPUutRIKj2Els96Oe0pXTAumBDM=;
        b=MoBZYSoQH27/jXVlvreRwBNMEwGbv+++O+Y5ldJYd6guvqJixaVDZf6sQoT8OPQXeZ
         PkLpXIpJNaY/woWofA+tXq7buAU1ZfiW0oQ/uPU4y0WuFHYvgakxB4scTC1kxbRQLBzA
         qn4l+Thfnr2MT/yo3EgJF37Es3nxp/TfasSxo3e3tcahAMejZXA9rxLAfVN9zlkauPNW
         x8v/cHEirm83PvMBmVN8cHsJDrmLHdK7glyhNn4IMn9cPQ2apZDiGm5ydwRyFIBRKWj1
         vrNsZAS3L6qu51uL6j/A83wYbGAauZwBwMhco3w5ziMguFrpkRqgPywCJIH7cJBfgrBM
         L4BQ==
X-Gm-Message-State: AFuF++l9QvPlFgDLU/5V61JYvJ8D+VoLpDrCF4N4ubnXwUe31pDRo8Dd
	lmWyx95YjsVAPxGod8Q9pmhA4u6T1PyvEGuiVlSatjsx802n57ILLvmyremF5jxGOK8/ZP1Zn6M
	0S0DvybBZuFR+sSGsYIOUhmLqDwMqs1A=
X-Gm-Gg: AYBFou2PfULucrZsMfpwXyHttQ2GQ6+BXSMUo/wedFARIVUWuljljxNNow903EdRyxM
	fUcB/GQF1dhejJY4hVPrJvtSlAZOjtC07EDitpHlS+6DdvJ7TxOz5Ce+Jhc29KrIdguDrkbxJ2A
	37b7KA1uUcGa2g4NCRKDust5z4WKe5zccQLaDRN4wFnpopKpPD5BLGgeiEMxC6A4ROor0AbkjYS
	oJ27B12rZeSCiFtJ0PdY97NFLRzL6JNEUKcuazzGW457VbAOIs8UDts5Hsgkha9Ldb6QoBv/Nzb
	lDMBMDDSVqMFBnL1My750QRYxotSWncpueyRmeG3fbgJzbbactBahbVmN5K9wq7EMKYy3Gt4bMn
	uhmurSEvcK9QIeOFg9Lap7POpwS153+UoadBNYL2zz9w=
X-Received: by 2002:a53:a545:0:b0:668:9230:e266 with SMTP id
 956f58d0204a3-672d578373amr531468d50.46.1790133885534; Tue, 22 Sep 2026
 20:24:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260910041047.24437-1-kartikey406@gmail.com>
In-Reply-To: <20260910041047.24437-1-kartikey406@gmail.com>
From: Deepanshu Kartikey <kartikey406@gmail.com>
Date: Wed, 23 Sep 2026 08:54:33 +0530
X-Gm-Features: AcwNN1U6czatgEZRd1Tuqm5XEJFOVJG01prTEVjnQfkDzzObqmXUjCvs5QK8mCY
Message-ID: <CADhLXY5MJOvgvW1SSbb8NPDCjicC-83LNHLANLo8mLDQq=OVDQ@mail.gmail.com>
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
