Received: from mail-lf2-f12.google.com (mail-lf2-f12.google.com [74.125.229.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25B8F44239F
	for <linux-wireless@vger.kernel.org>; Thu, 17 Sep 2026 07:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.229.204
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789630301; cv=pass; b=FjClCDKbm9vf4/3qw3TOqadr3zy4NMMxszTVoidaLsDwV/JIspAD1v7dTlTZHwIEaOn7uBmod5OKR/gO4KLO76tUdt4DKkRmVPzirZl7kigINMr6HWUJVmbj40iJP/Fs5iQDHP3F1I+ks3NyAovYNVqjN3DTJTqptkUGv0BDgoc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789630301; c=relaxed/simple;
	bh=ae5tnOSxy7PX01fMqSfgZugTF/eY5ZCZKg3uruhZrKQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=og9J+Xa161ZL0DxsYhm2hgND8w7PPpdzNDZYHeXCfZHo6M7zJOPZBn3hUJmVaGllLwYPe5a5iFics2F++fMUhNBoJTu7IOtz/kl1ABTXPI2256oRp5EPyQQRGRifsfEUAqgMdfHuCe6a9WHMAUiKVC+QTjfvDa4x9xQinY+uyH4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=khu.ac.kr; spf=pass smtp.mailfrom=khu.ac.kr; dkim=pass (1024-bit key) header.d=khu.ac.kr header.i=@khu.ac.kr header.b=J1XJKIZH; arc=pass smtp.client-ip=74.125.229.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=khu.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=khu.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=khu.ac.kr header.i=@khu.ac.kr header.b="J1XJKIZH"
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b5e4f1b845so400988e87.1
        for <linux-wireless@vger.kernel.org>; Thu, 17 Sep 2026 00:31:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789630297; cv=none;
        d=google.com; s=arc-20260327;
        b=W/2o+flR8ZYIJz1KaaumysTWd1fNFtE3AfQy2S5Frklk6DiIOz1fUcBW+Oef6JxSR+
         teG42fvxwus6vuTZhD/e5EnnNZIl62o6GAKKCp7rtMbPSGiHbPIV7+PgDYtlvI2XsZhr
         SbNA8ZFd2FvmsceSyxPngBMXzypaaoCVlUs9FQu1jdezDkEqmrBXYengTrU46BnQA1EO
         V8IUnm028jqyId/vWCE3peloUCL4w+V+2ZptKsYVbanMeXvPiJuYmZActRoCZg3ieUHz
         zUR6i3P34sYbsudtrgXHuemkavG0AqpGysLkujbA0xc69pXfyqWeUHM581yGwxK/Q280
         yOoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=ae5tnOSxy7PX01fMqSfgZugTF/eY5ZCZKg3uruhZrKQ=;
        fh=MhtQkZecYlWmxg3DBRqEiMKK1vmKtO5bFPrMDotOrCs=;
        b=AoISOR9zL3Ksq94IZzflkrVJn41Xn/Cs4aj0EUH+pSk14TPxG9cQQHR+7HGpzVD6TP
         ZLHV45Cp1d/mqf8iWIKB2JdKTLXHb/BVbwcLJOJEHxvNo7sGqApi/pu2+wxtus/Et9sD
         rETgzvpbEt2cW9lqvwxGqzuagZ6dfM0pZjSONnwCp5aVDCMtg+Mo+CQ+Qw2jbshSKEqk
         9gM+lsSFSaBU/NII9JBbO+rFHTdjHdUDlsjDmzPnFd943cDvlaWmGU1EyYeVuIXQyP6Q
         HOaHzdts7d6A2DJ9RAA50h8/yt6+ZZmVi0Iwhav7XmwY/5jPNA8vF8vdsbZh+PsncsI6
         fRng==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=khu.ac.kr; s=google; t=1789630297; x=1790235097; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ae5tnOSxy7PX01fMqSfgZugTF/eY5ZCZKg3uruhZrKQ=;
        b=J1XJKIZHnR9GF1vsxtPxybFLmQeriTroIhrV6ObXesABxVVsDttd63+umIx0T3VJoW
         j0g7+LK6RXGOVZybUBvOTrbdrJQOwcQCnWs8IYgnoTZolnIdY2emZRQcJ58ioHNuz2mA
         kwBdzGFqwBCbkjC0ABTdXoUtYU3S3PW5ckJ8g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789630297; x=1790235097;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ae5tnOSxy7PX01fMqSfgZugTF/eY5ZCZKg3uruhZrKQ=;
        b=IWub+jymkfoUm7XdQfVv5kQpAaIYpky+mpQY8KPvz0NBjYjW0fCSLSHtkFi2257GLC
         abLar/uFGL6J+GsAWjrLCJ20Qy1B8EcyvacDtZI7DGFyx1eGOqid8Ecu8vHNyoPXgzGf
         aPkWqvRKFy6grlf0WIw1GkPKPBVbAazMw+Ukll8p3ibaGV98SVLcRHgoxOEV8IRTKybW
         U8IbiKnwGszxxywAApwYIe0Y//IGXektNyGbZD+nhYj/dCw4ABghXBLoiTCn6iQhY1Xj
         3jwCCdTsFeaEeEa9xIgeXXrmYuIdJBAtmyv8Tfk4aliUQ7WrY5RyzooNxU//FstvDTRg
         vd+w==
X-Gm-Message-State: AFuF++luQd575CML9LQ7Usv5xKwhqRaeSHyhVFjWbnwDf+sqCGcUIhTR
	9Fdr319Y+WR9Q32u7NAsyavMF+WWSEd5R5cgmc6JegQ8sA8gK54g/fZSACt8e2o7ltd3Fgrt4AT
	WlC4JJ/RHHLdD1n9UvuN1pYl+ewR7Pv/wiwB9oghSQ8oq3VwwbvbCLcO/7A==
X-Gm-Gg: AYBFou018jMz29rmZZrojTyfVk32Uy3yPBL6hLFTCobXRPrrkHqHU01fphOKGr+LVMT
	duwzi0cFfd6XqXBKrGgUwQRXtMcX5YT1xR3wRIJSoB7wB5PnRyvCq8jAJ06PXZ3UkS0F19pptUs
	CfyQ0Oz60teTE+vZa6RdCjLN6ieWWDhxmW14Dcoq2gLavpln1bBKqXjjKOuLs/6EI7aGvrvO4dV
	bGD+bMjnCCnMHBXDroPnyOI3CSMrkSX9IZcgOTRyDev9ZQHt3NFzBN8o9KVYHiQVNtFmTfvwkgL
	Zxux7BDZy1P+cFCS7rCkpd/74vANZsZNXJxbbNyqc7oDbJiiI/FnKmk=
X-Received: by 2002:ac2:4e11:0:b0:5b6:1a7c:aa20 with SMTP id
 2adb3069b0e04-5b8b6655f65mr1537553e87.56.1789630297169; Thu, 17 Sep 2026
 00:31:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260913-codex-rtw-rx-v2-v2-0-f09c964e0b96@khu.ac.kr>
 <20260913-codex-rtw-rx-v2-v2-1-f09c964e0b96@khu.ac.kr> <de086af71cc346d9ac8ca4e7bf8787e0@realtek.com>
 <CAH1Bc_xaD2kjBRp7aVjmAcz4Pv=zK2Tx7ro38UsdZZtXRY3Oig@mail.gmail.com>
In-Reply-To: <CAH1Bc_xaD2kjBRp7aVjmAcz4Pv=zK2Tx7ro38UsdZZtXRY3Oig@mail.gmail.com>
From: =?UTF-8?B?4oCN6rmA7Jqw7ISdW+2VmeyDnV0o7KCE7J6Q7KCV67O064yA7ZWZIOyghOyekOqzte2VmeqzvA==?=
	=?UTF-8?B?KQ==?= <5mghybrid@khu.ac.kr>
Date: Thu, 17 Sep 2026 16:31:23 +0900
X-Gm-Features: AcwNN1VM7Ul5-ZzzznvgaBYRYVLvcxfNybxj9wjgAwgqIQF4TFclQX5o90vV-mg
Message-ID: <CAH1Bc_xZD7m+=obYMAtMfbFxrJDS87OGSwd_Mu7vZjHF_K3SLw@mail.gmail.com>
Subject: Re: [PATCH rtw-next v2 1/4] wifi: rtl8xxxu: free RX skb when URB
 submission fails
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>, Jes Sorensen <Jes.Sorensen@gmail.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

I'll use a more formal name in the Signed-off-by line for v3.
