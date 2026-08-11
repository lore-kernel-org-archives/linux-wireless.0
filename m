Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6058E3F3287
	for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2026 21:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786482054; cv=none; b=cug1W4b0LpDbx/CHoPEn2LEkfDv/ytzYu7jX06vaiFOkgi4VI04Na2GXh/PjSbN98KBQQJUq2u/qgo1FAlL4O3wmqJ+C/8a9II0A0frVb2pV11CK5f2+ckzflsrqeXEp8jhSQhx0WBfNeuqJJJzLLmjbpyPnffAnifF0OXOrJ+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786482054; c=relaxed/simple;
	bh=q/EnCaP22zPPVEH7ArjSq0N2VKGgvKT2RTU+G8TxgPA=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=YkC/zJTyhMJHCSq3stHNYhwf/JNBU5QwF5Ef5M8QaXGn09O+zM+HJ7q2G6xc5P0IbYOvV4HoN6nJrr0AqUOdEQrXfu7pCMc24V7B544NoUCnEi+tnnfarKMY8/e+3rb0xEtesL7WU/bk+M6CuqapeXPPX23v5jWTXfornymiQu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-49ab6a82cd5so375126b6e.2
        for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2026 14:00:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786482051; x=1787086851;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=vd26/r51jTrMLmtg5EiFxgqi0vBppi8VrKo7T8MCOMo=;
        b=MRqgSkIZ0dNduYXiGGiibOLhk9/79EDrm07x0vshZIoCkB1HhVAJPW7QxrSZkwpBqc
         eSuGi9FFDQhFgc9luLiqARgTNGa6WUpJ+lFMtP70keYo4d3lzuCvDqZs2F3o4XMepYRV
         3IyWFoOBM6LpvCzMFx8+XPXmkiaggCNkeTC0DGyxFMloyyQoUShobheahVbAhX4Vb5Sb
         iH/jEGZzc5nARdnLv3t7/ffkyTpiww8Nv3IMDdwRuCpNKfhr9EZ/geAVO88K6uR9xAoZ
         +wpjxBOumXpheTJwqzwDG/v3NVydzQprPVqbTODAQYr5vgilfZXI/Fn1fwYqVzXeBgQ9
         XZRA==
X-Forwarded-Encrypted: i=1; AHgh+Rq3jG0UH6hpeHXuz4MRwYxeveWvFuyqs7Ywq3NWPCSSl40bgxL3Jp3zCb/n6XVH+7MU+XDr90H/Uvc5hh6OBA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzFVlYSbDDIzWR7mdCOTJMLpEj9Y8ltQmQ+hWJIto2hszdbCnOW
	iXfKWphrpxLV0FaAlmGWiD3oH6sV76SNpoG/5K8U2/z9knVxv1mSq28MYcQziBQF9yKbvwmtCaV
	bKBwyIfaquZ4sRAf0VgfBp9R+E9NBm0ZStXr2od3C2SD/0sXVyksPcgFHSMw=
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:6f82:b0:49a:a627:14ee with SMTP id
 5614622812f47-4b210c5e84emr40234b6e.15.1786482051415; Tue, 11 Aug 2026
 14:00:51 -0700 (PDT)
Date: Tue, 11 Aug 2026 14:00:51 -0700
In-Reply-To: <20260811205927.11228-1-ayushmanrout27@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a7b8d83.ac361c09.22ff0a.0046.GAE@google.com>
Subject: Re: [PATCH] wifi: mac80211: guard drv_net_setup_tc() against unbound
 AP_VLAN sdata
From: syzbot <syzbot+f1ba58d6b55abd13239e@syzkaller.appspotmail.com>
To: ayushmanrout27@gmail.com
Cc: ayushmanrout27@gmail.com, johannes@sipsolutions.net, 
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org, 
	netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

> #syz test: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master

This crash does not have a reproducer. I cannot test it.

>
> syzbot reports a NULL/invalid pointer dereference in
> trace_event_raw_event_drv_net_setup_tc(), reached via
> ieee80211_netdev_setup_tc() -> drv_net_setup_tc().
>
> drv_net_setup_tc() calls get_bss_sdata(sdata) unconditionally. For an
> NL80211_IFTYPE_AP_VLAN interface this does
> container_of(sdata->bss, ...), but sdata->bss is only linked
> opportunistically at interface-add time when a matching same-address
> AP interface exists - it is not enforced, so an AP_VLAN interface can
> be fully created and registered with sdata->bss left NULL.
> container_of() on NULL yields a small invalid pointer rather than
> NULL, which the trace_drv_net_setup_tc tracepoint then dereferences
> to read the interface name.
>
> Guard against an unbound AP_VLAN sdata before calling
> get_bss_sdata(), matching the WARN_ON_ONCE(!bss) precondition already
> used for this same relationship in sta_info.c. Also add
> check_sdata_in_driver(), used by the neighboring
> drv_net_fill_forward_path() but missing here.
>
> The underlying gap in ieee80211_if_add() - AP_VLAN creation not
> requiring a bound bss - is not fixed here; other get_bss_sdata()
> callers may share the exposure.
>
> Fixes: 61587f1556fe ("wifi: mac80211: add support for letting drivers register tc offload support")
> Reported-by: syzbot+f1ba58d6b55abd13239e@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=f1ba58d6b55abd13239e
> Signed-off-by: Ayushman Rout <ayushmanrout27@gmail.com>
> ---
>  net/mac80211/driver-ops.h | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
>
> diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
> index f1c0b87fddd5..ecfdb51152f4 100644
> --- a/net/mac80211/driver-ops.h
> +++ b/net/mac80211/driver-ops.h
> @@ -1702,7 +1702,23 @@ static inline int drv_net_setup_tc(struct ieee80211_local *local,
>  
>  	might_sleep();
>  
> +	/*
> +	 * An AP_VLAN interface created without a matching, same-address
> +	 * AP interface present never gets sdata->bss populated (see the
> +	 * interface-add validation in iface.c, which links bss only
> +	 * opportunistically and does not require it). Such an sdata is
> +	 * not safe to pass through get_bss_sdata(): container_of() on a
> +	 * NULL sdata->bss yields a small invalid pointer, which the
> +	 * tracepoint below then dereferences to read the interface name,
> +	 * causing a crash.
> +	 */
> +	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN && !sdata->bss)
> +		return -EIO;
> +
>  	sdata = get_bss_sdata(sdata);
> +	if (!check_sdata_in_driver(sdata))
> +		return -EIO;
> +
>  	trace_drv_net_setup_tc(local, sdata, type);
>  	if (local->ops->net_setup_tc)
>  		ret = local->ops->net_setup_tc(&local->hw, &sdata->vif, dev,
> -- 
> 2.54.0
>
