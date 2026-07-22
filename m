Received: from mail-vs1-f52.google.com (mail-vs1-f52.google.com [209.85.217.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9640350A35
	for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2026 20:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.217.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784753643; cv=pass; b=XAQKGvgIk2UPsI75pmAQYS41GaBv1A4WrweKqKLLN52QRq8BXXj1Z0VEvIcQKHzY6w3SqjU5B/DeyvZTyxZA0kY9KvngI4ND5lzcArXY21uajAtO4lc2jrMDhafsPP9qaYlN6Lv9LNc+kO1tA/rSIjCw8X2EeklPMfUaJiblwDw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784753643; c=relaxed/simple;
	bh=eWOazWHJ0TT97xqbRlfrRls9dVlxEnOTHwOajl3Rxz0=;
	h=In-Reply-To:References:MIME-Version:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GUleVuLYXksQvojEbUVAe4vjpdmAJatBpFjU3qpddf/WyAx9L0Z0D0hK6dNvTSMqIvKmgZU6KtKBPqscvvv4HK5oqLI9upnRpdmai/o72btklcLmknjyFwiPKkoOnk0UJHuZ6dfwUJKcTEN6AWrjd5L6CgDfTYmul98KHSeQTPY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FEhMdaas; arc=pass smtp.client-ip=209.85.217.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FEhMdaas"
Received: by mail-vs1-f52.google.com with SMTP id ada2fe7eead31-74ab99038afso1767018137.3
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2026 13:54:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784753641; cv=none;
        d=google.com; s=arc-20260327;
        b=RFBeZzKxNHXtD0QuQnA9dLqGcIR5Z4AKep04AFLX6DLwjJ5OocgNYm+PyROe414utq
         gBltzrTUyTnUJkdlAWeYx98+swS9qFYiJH+/nIUh/Gd1couw/qDE5pZZaku4zzU9m0Gd
         Um2W5rFEzt01fWgcbPT8Fmx38JJBVITd9LzHwluzMtpnCofMeVb0eseNEh75P6a6dQ4r
         v1IASVMzMK6rAPjob2zIFWTOkIV5XgwxPf8egHWl3ZuRPU9k+ZsSmWftRiCwZNfXFJQj
         WmA+P+9WH1E+phuKkweQmhiNLKXWUUz02J3iUJ2tY0EjQ+iV5jzz0w1dlus8MvUI/EAy
         wpSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:references
         :in-reply-to:dkim-signature;
        bh=AhilNQfsDkJHCCdgzHNOvxzFtZWC+RXb2TKxfn2s3w8=;
        fh=u1g6uTmPiRHP1apLJ+WHT4nAAQZAZK1fCI7keXZ5CRw=;
        b=WkSTvMizSirADG2ZSXCkxpfUzW3y/AmO95Jv0UR4/eFlfdJNWb8/e3+UVeFICR5ERc
         ZAMjMiuQCSTs3PDj035s2JQFwCTHgIQuRkSTttRkDUzm+EXbaD9lwjWA6evcD0VQoOjj
         wgsMyJU7/t5B7uYFDBFkZK9kCnoyySX2AqPeqB6tXTcnzdBaZStzwcWTV/Fh/zbWGdXS
         4eHIAEvli6TkOcpLmpYCFAyAjGOSWira8b8ezIKrXoSINYeJQSzpf479r3/UiH9cxP3s
         qRv/qJcb0LZ/OBdtzYWc6awvTaf2EmfrMJEfap9vqlmwntRkxNzOkxPP67s3qGcSlirg
         6vgg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784753641; x=1785358441; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :references:in-reply-to:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AhilNQfsDkJHCCdgzHNOvxzFtZWC+RXb2TKxfn2s3w8=;
        b=FEhMdaasxbkMRUStXSGwM/NJBjnGe/Ab7OIqMPKcdWYWd2lLRSh1mbd1rn1aaxw08k
         83U8aePrHa5ZqKI5O4IR8UwWZBToo/B+6GBA4ZT5YSO/gSRChCZeb4peE0g2jqYN79el
         226eu+MIuoTOXT1q61GiUR+jwqNgm6SwVh8mCJNCjjp+Km7siv+c7yx9Q9jhaRd/gh/k
         jWubc8BKm403whjYQC8HQFQVOt/6QQwMei/QvOMpLdgt59d4Yk178XiHuu53VZrlNOUQ
         NkhEB4qliFXMudLtTcum6+eMPkUxyxGyozLKpdIuD5pcrgrHFK2+mlWXKmQV6TCBDB/T
         37jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784753641; x=1785358441;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :references:in-reply-to:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=AhilNQfsDkJHCCdgzHNOvxzFtZWC+RXb2TKxfn2s3w8=;
        b=kPCl0zDU5lb/afBLCYHOmsMht0N2RHVQfk5UcQmasrmBtn2glEaoPgV3tJbfWMx1g4
         fnYtxqiWpXGUf46h/q6TDrsVtcuBYCG2f06zjsHoKD2OvehNJnXIiUuaoWNpoe4ZY6Vv
         tpMffL9Hs1Latpiz7vACWSkyiRPSy0WVX6IFdf5DsNcf12NHKVJZGDAYfb/lGmmORkII
         gSXYccuVwYccaOWr+gnDs2Z6sEckNOnsAO/OsFLcKizfGCZIQZsogilUl89C026Z74Q1
         vn0WaePqsNjUqAl+qXwfbu9+CJmjarA6bqUXUUc9A9x+DgPcMGroSX3yPCe9oSvwKUj3
         fviA==
X-Forwarded-Encrypted: i=1; AHgh+Rq2EWbqGLOcJat3TFdMrNqLAf8P8iZz3hos9upfX7mYL/Z/+5/t9WksJzhplC8t/xHIl3erKWjGdNv0WqyfGw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwS3luTZq1TTLcMOSNl9VGVSLMHjMydtpuZ/BAu21qWiY1q7tFC
	si1ZadV7N92eMcO4l6ItwwZnv/gNIRnxzwzlFPNdU/PuWDlJ9LfPhQQ7o3CUEw8OwOwuuuL0pnc
	D0kAdDnRWl77csWzNs7V5QHUJe2HSP6U=
X-Gm-Gg: AR+sD13LBGVR7rgUtkopdBn31d973XtP2IK1SPRedVQggq2LVEuRHJPvhoKBULlCt+g
	gd3uHUPt5q9YmYLcgX6FYa9oTH0JzItKNIpX+NTigerABLHWQre0HSD3ybyLhXC7llNqtRuEu5x
	ZzuHrIR8+V7siVzSQjTrrqvBOBQyJ0/PDbU/z1mcFzJrzAVVKsE61rRT/LMHLV35bC/cB6CRIva
	gtuCX2tXBGM3NWn6CUI0ZSnMhHv1G2KOxYlbe0lfT0x2IAttVC9dBzbjp9W
X-Received: by 2002:a05:6102:644e:b0:745:31e9:f3d2 with SMTP id
 ada2fe7eead31-74d5e6d4e30mr65081137.10.1784753640571; Wed, 22 Jul 2026
 13:54:00 -0700 (PDT)
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Wed, 22 Jul 2026 15:53:59 -0500
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Wed, 22 Jul 2026 15:53:59 -0500
In-Reply-To: <amDoh8ypkkAY-vvc@sirena.org.uk>
References: <amDoh8ypkkAY-vvc@sirena.org.uk>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Enderaoe Lyther <enderaoelyther@gmail.com>
Date: Wed, 22 Jul 2026 15:53:59 -0500
X-Gm-Features: AUfX_myj0hhez84pVYC1y9jATG3_SizvJW7anBM1iRJVpaUMvQJ5wMHKqS46PIU
Message-ID: <CACHPgzzDmfDii3MVsjukiGYqZrd+iKur6T2+iRV11YBdqof3=w@mail.gmail.com>
Subject: Re: linux-next: manual merge of the wireless-next tree with the
 origin tree
To: Mark Brown <broonie@kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>, linux-wireless@vger.kernel.org, 
	Johannes Berg <johannes.berg@intel.com>, linux-kernel@vger.kernel.org, 
	linux-next@vger.kernel.org, 
	Miri Korenblit <miriam.rachel.korenblit@intel.com>, 
	Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
Content-Type: text/plain; charset="UTF-8"

Hi Mark,

Thanks for carrying the conflict resolution.

I noticed one semantic conflict later in ieee80211_rx_mgmt_assoc_resp().

Commit 035ed430ce6a2 ("wifi: mac80211: avoid non-S1G AID fallback for S1G
assoc") added:

	else if (status_code == WLAN_STATUS_SUCCESS)
		goto abandon_assoc;

where abandon_assoc destroyed the association data with ASSOC_ABANDON and
notified the driver.

After f13e573ab3f12 ("wifi: mac80211: notify driver before destroying
assoc link") folds the driver notification into
ieee80211_destroy_assoc_data(), the equivalent target is
destroy_assoc_data, since assoc_status is initialized to ASSOC_ABANDON.

next-20260722 instead has:

	else if (status_code == WLAN_STATUS_SUCCESS)
		goto notify_driver;

which bypasses ieee80211_destroy_assoc_data(). I believe this should
instead be:

	else if (status_code == WLAN_STATUS_SUCCESS)
		goto destroy_assoc_data;

Regards,
Zhao

On Wed, 22 Jul 2026 16:57:59 +0100, Mark Brown <broonie@kernel.org> wrote:
> Hi all,
>
> Today's linux-next merge of the wireless-next tree got a conflict in:
>
> net/mac80211/mlme.c
>
> between commit:
>
> 035ed430ce6a2 ("wifi: mac80211: avoid non-S1G AID fallback for S1G assoc")
>
> from the origin tree and commit:
>
> f13e573ab3f12 ("wifi: mac80211: notify driver before destroying assoc link")
>
> from the wireless-next tree.
>
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging. You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.
>
> diff --cc net/mac80211/mlme.c
> index fa773f3b0541a,d577252dbb9f1..0000000000000
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@@ -7140,7 -7191,8 +7193,8 @@@ static void ieee80211_rx_mgmt_assoc_res
> {
> struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
> struct ieee80211_mgd_assoc_data *assoc_data = ifmgd->assoc_data;
> + enum assoc_status assoc_status = ASSOC_ABANDON;
> - u16 capab_info, status_code, aid;
> + u16 capab_info, status_code, aid = 0;
> struct ieee80211_elems_parse_params parse_params = {
> .bss = NULL,
> .link_id = -1,
