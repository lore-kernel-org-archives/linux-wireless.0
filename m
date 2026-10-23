Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.51
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792788298;
	b=Wugw/oc7sfQ+Vt06t9j+4/sST2XxB0E1ng/8cgoYBCMhMvxz6PvAryDFaDcyo5wTMilO
	 A7PdIr6fgNBbSVOXHsqwbuRA2yxH+2vBVvKbybeQ932mzwPgHHFQpEOtwbKPt1XEih4XM
	 Mk1NH7Gskyu8YJ17SdzVqX+T/nNxjj8CydxZ6AAmKADb9Ae2USqT+TWc6RsvGbjbsScQ4
	 3OL9iPYoLIhukJmZLKpbC+6OAYk0cUOGsQ6E1u/f3lSg6f8aoHLRn//iHzkAMd4uwOtv0
	 k3XpTaV0rreWUvsw9NwrLURKA4OiLvxFaYNT7hFnZBWkNcAKCNYYX/r485sMBnagksQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792788298;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=v7+u3dOadIrUbFkNlr6wXd/ZKqCuBSYy4INtLRXYGUA=;
	b=sAjUvZYYOG/H+kuiZV3Hvh9FcufS3b+hJKF640Zw9mFBaIQmf7C8IePRRHSnAM7UnfTC
	 bUCKdIFUjnNELFuDRnflWyyd9IFpt9A8ay3yu7dfwdaEVYP4dmrv9yRZCDggiEAoeVIPp
	 jAqFY2GjOkdcRToE2as9CqYVDK+jrQw7TZ6IEYgAwDaUthzFcH+YgwmtVRylbVu/9DM+A
	 HWtvSqO/R70gRfTtTS2Kuw90EO1rFjNBcf8QjDkRKYQ/oQ7oT+hi1oNVeQglOxoPxk6DM
	 GiJp1cDC7mv8IlF4ShWQPq2x0oFqPO8GZRhkmUMvF9iUCdkE/PMOXiBtveIXg8xUcLg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=q+Z1RtH6;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.51
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D94D3606A31A
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 20:44:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D94D3606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=q+Z1RtH6
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6b3dc272dcfso1664986a12.3
        for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 13:44:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792788296; cv=none;
        d=google.com; s=arc-20260327;
        b=geyYB8RuBOUvt3RK7P/Af9zZt6RDhpiV67JmKUAv9QjondbQR05n+G/p2o+EtXWB10
         WyJUkgiAOJPD+5wtUtYYX1c5EBuiN/fEIxHagTtDpocOA4q2oe1NDQ/2wZze31JsYspA
         bN5lTx78PguX8bzt5Dp/24FA67XLMhv62VywITrEz9xj0AaSoBJSoAMvgjj/Vl/zi5ir
         8UZoOj2h/kzOENYoQ8IYThaINqgU7XAWy56uS/QYmj2Shd5wM7tCULfFOVr8vxOWDAKa
         +NJKgWv6inEGbSig7YSWNJ991z9cO6CsBGbVNyopCX6pbsiz0jOsSaBTH/H1ZJ9tJswS
         yNRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=v7+u3dOadIrUbFkNlr6wXd/ZKqCuBSYy4INtLRXYGUA=;
        fh=kpWsed6Gl9Jw39uHHbCW8BjdBcTvPDR+t7LwYL3VZw8=;
        b=fg6zcXB/NLEUKIfe77rMB3lA9YEFeNIsKCqMN9pPuqKLBHjL4kl4qARejHSPvMR0sO
         HUOtQnyIltxpHBo1J70teJfpNcBlfh/nB5ROLUDIuAqcs0bFpMz4Sr3yzPtm/ucwk0io
         giwgAUuXo02TqHUcJUbuAubhdj3NaqSqs0mPf8Mt0onevT+zHYBcxvqlL+DVyrrkIAci
         VdnPf6XPk82YYQh2K6j2J8Q5jExV+ruH4ckgxBL0BSJP55GENbksrhPunhzoQlFPZGVU
         9xa0aj8K7sqf59PsjnWwGxlPI01Gm0zIKFZFSk6YAadvsfO4HtGdFE3kOTuTlu3OXV6T
         LMjg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792788296; x=1793393096; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=v7+u3dOadIrUbFkNlr6wXd/ZKqCuBSYy4INtLRXYGUA=;
        b=q+Z1RtH6uNQdMh0T4PtQO/WO7RCPyc3vSbx0tWFh7pu70R8Zby0afO/WZQMBQh3sYB
         DcarO+aJd+zkxJ9GpTZbjy0mKQifGR+kUWtTGxqE/pbZAgBhlK5VFalCIIbbsOI/vVlg
         hivuGBHWnK+z91xnbGNx5o2HLCxIM7OIWt4Rg+9Nu+Rb/j1A2RLoN0Y703Mhl/1Sa4qZ
         82UA8Un3QoJShNJWge1vF4HBcT0ny2obOC1X8glP0NbCh0XsLbDtqsjOipNKUN7WT3w6
         9YRVUYrjDM9070B1D+sccTLv05a1CQ5axYsuRjO3ZEaEnlkLnHaw1hd5SBq8N7t0nMrH
         4aOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792788296; x=1793393096;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=v7+u3dOadIrUbFkNlr6wXd/ZKqCuBSYy4INtLRXYGUA=;
        b=Rm5RQXklp+oxfDMXSaiyQOePITeAFm1YGdNs2wuPhHTpQt1EbK3Oz2BkWrd9bWKhTz
         ReLdttWo5ORKU3xDhm4X9RBvXe1YgIJ51kiao9lWoK0RC6NbUYugcVjhulqKAQyQfLy+
         JRiDuvxQfAAE90hxE16nhqYA2vK0m9E6fRV09hfBCmwjSXB3eCBzS9k/1JuJqnPPlsSx
         +pQUTD3w7aBMHX0W2apI/V7526atIYFlnUyFuTfPWmLyp1BEP07e4lZ4DxkYQ1q727rg
         XI5r7W+PuH4PJi04/tDlL4LWWg2vFEyfKF3YQ3X8n+CbW+uQO+v7a2CRhiQVHbPZ1Jba
         Nn4g==
X-Gm-Message-State: AFq9FYKn/IPaKgocaquzCA8Dey11opbM8KZWkL2U7dQ7SryKyfo9UCCf
	AX7TB5Mjyyq1kffYFnmruFpeUh8tM5cJCamt5X0d5Rb4IHy3GQ+yxJ353o7xHdWFT7y40MLBF2D
	dQIwCzDgQYBmNWtTwN6tjkFPYL7OrBbQ=
X-Gm-Gg: AYBFou3g202OpJD3Lywmqb3/hTMow2sj5Gqt1m+ePG960JEsMGFe6qwHdAoesA6/SYi
	r26XoZb9lkW8JQqsJLQVLlUAptZPhIDBxHryOXMVC/RLkc4WQW0ckiirwspiS/8wUTZOJdHJUeh
	n6wTf0fLY1PqwkGJgU53GGz6rNl0bmH3i6+D9Ek0kTG4g5DEMpXzBW1INkoM3Vfym3wqmoLolPa
	jnznGCfW/E/rKcqVJjPE5taj/TY8MGC0JlRzXXXXrASLfk5z879V+yDn2dof/yH5oUqbQbqBWiH
	Cge7PgKelab1aFT8Hv6SpoopZ6VaBJ0Yt54ueh6fwjR/sreQmZSgMciG19uHbkUTDNiZeH1mVNp
	zB2iYygux6fpOxS+iE1fHtITzv0cXQKxEaCNuV/SwIeO5AHSFd10byzul36J/i4NgySupYbiY5L
	peFSpRNFzWpF/Rqtz9DXSw6Nslebrr+1/PVCRDJxyq662NGoCBeGbUQhdyY119fvoI/7bKYN2Jc
	DllH9tK9ZD5reAZfxNp6Z36aeK61ZeJkRup3Lv4EhiKEKeI0Q==
X-Received: by 2002:a05:6402:238d:b0:6ac:8761:17a1 with SMTP id
 4fb4d7f45d1cf-6b44300f683mr269474a12.36.1792788295986; Fri, 23 Oct 2026
 13:44:55 -0700 (PDT)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261023190653.70741-1-rosenp@gmail.com> <20261023221424.2722795e@barney>
 <20261023224140.465903eb@barney>
In-Reply-To: <20261023224140.465903eb@barney>
From: Rosen Penev <rosenp@gmail.com>
Date: Fri, 23 Oct 2026 13:44:44 -0700
X-Gm-Features: AclHuK_iEVqXQQc71AZ8oDUrqZy15oWTBltW_n805CdkIBNoTMIbMWBdIoDHNgo
Message-ID: <CAKxU2N_1XgjVPdSrCMYzZx4Rb6yjgEe7kBZYyG4RASyBv5BtMw@mail.gmail.com>
Subject: Re: [PATCH wireless] wifi: b43: map the RX buffers DMA_BIDIRECTIONAL
To: =?UTF-8?Q?Michael_B=C3=BCsch?= <m@bues.ch>
Cc: linux-wireless@vger.kernel.org, 
	"open list:B43 WIRELESS DRIVER" <b43-dev@lists.infradead.org>, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 23, 2026 at 1:42=E2=80=AFPM Michael B=C3=BCsch <m@bues.ch> wrot=
e:
>
> To explain this further:
>
> - I might be wrong, but this patch looks completely bogus to me.
>   Why would this be bi-directional?
>   If this is accessed bi-directionally, there must be a bug somewhere els=
e.
> - Please provide a HUMAN WRITTEN patch description.
>   This is really important.
>
> I am all for using AI for development.
> Especially for such old and legacy code.
> HOWEVER, there must be a human present and understanding what is being do=
ne.
>
> Please slow down your submissions.
> Think about your patches before submission.
> TEST your code before submission and send evidence of your tests.
All code is tested on an Asus RT-N16. It runs on non-coherent MIPS.
> Untested code is to be rejected.
>
> --
> Michael B=C3=BCsch
> https://bues.ch/
>
>
> On Fri, 23 Oct 2026 22:14:24 +0200
> Michael B=C3=BCsch <m@bues.ch> wrote:
>
> > Quite honestly, to me this looks like a lot of AI slop is sent to b43 t=
hese days.
> > Can you please slow down your submissions so that actual people get a c=
hance to review the stuff?
> > Thanks!
> >
