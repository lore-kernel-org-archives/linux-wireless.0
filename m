Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A2B821D3E2
	for <linux-wireless@vger.kernel.org>; Wed, 15 Apr 2026 19:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776282838; cv=pass; b=ahmbNWFdiJGAdGhYwxkZa7A+WxseVlS2PdrgD6DzgUanZYB2Yg36q+jh/hrzxOOx0wGEyLh5DlOhrc0ncHRFwocnYkUrxn2rnIPWE1c0834AJPjUc+7KJ2WeXyAzk1kxUwDsJlUcaEJ/6lflQwgD60NbwH+zVt+LjalWBLyuFMk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776282838; c=relaxed/simple;
	bh=uhH5g5RF3v+rxprTxLsCZW5qi5KvHeMcB0sxxwUDgW4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gY10cpXmcU8zH7IDlxSroH7XB32BSTqg/x3Mxgny66yskoEe0mY/hkX7xU2ULGoPJVy9bGJfaVfMcy2ZUjOS0dIBrqANitLemjrbLVcjCx2NmnXDopssC0RY99SewrQmSd0uamQ2EJVA1ckErmYeh/lgd3qg0Ych/PDgCxsiKoQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WULE9ibe; arc=pass smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WULE9ibe"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-ba23b5bcbd5so84195866b.2
        for <linux-wireless@vger.kernel.org>; Wed, 15 Apr 2026 12:53:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776282835; cv=none;
        d=google.com; s=arc-20240605;
        b=NUQugi6QQ1ofL5obU06n1aWm1ljAh1Nh2bGpGgaeT7Zy7uiDjQ5pjSzFmpoWta5DTX
         gTVpzw5GKTcAZRs3aKQ1/2pk27d5a0qALIGr3MFvIdG8ov/xg3g75sV1c0lysRzrE/9e
         V7W74EawDYCMnopbtDpddGVc46QkawyTE3GJmByhK82pQsX+oq+xubLkjRu0Wlbg+PX+
         u9WaWVtoMgWdxSdbqKH6PjKcQXlgWBakd7qTPMuWprw0YfkOlbcQQVcCk8uc49zYlR2I
         26fB7SyZH/DD44XL5LjJP7Ph3gn+QujcMDqjnRppCIJjrzlh/IXMfEefB+7RXHudbZPi
         pQiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=oYmr9khsTqs70UAtFkmFAILnU1WTG8FTB2ZGQVFARNY=;
        fh=dZrcJ7jIe7+nRs2YdjysUmWElK3mRFTfQjsQT4Z55v4=;
        b=bhDd8Yf7G8VueL0wSkfi0pwGg1AGYnwrVpax6aEUTtTOjhHrHrrFBYA1VxBAk/yA1Z
         EwPE1LpLcd/6RFu5GBGOF9j9fwY691vDYmpHJ7MGoWYzdD26OyO7321GOGeTF2aTTaan
         HzDBQCQm4Xx/NQVdf9YDFyu8sqLy4oJQLCDBdfJVQgjQn8TLYoU+VsPzh/dbaqOtcl+4
         BLh3UamBRB41afYqtftty3n3dkb7AL6cnoP86/KldV1kjg6Dnsb1pwGkuAqjnRdZJ5Ra
         RGRyk0NavFDzBvPxuuLpns4MDJTrQ6pz+sfBQGnjRzI47mwqGm6o4sd44fhtBLG4KMA+
         KZ1A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776282835; x=1776887635; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=oYmr9khsTqs70UAtFkmFAILnU1WTG8FTB2ZGQVFARNY=;
        b=WULE9ibeUXAcWUgUBgjD8Kzn4uTqO4aE07U+ifvSlVJARI4IKjCanz5v2LGxuIQUX8
         vKhDMDNfuz+TJSx6tfy0v3Y+0ZiZ6a/+yUfqtr6Mx3X9+eXTgfiJXAI6cy5wWTwr8qgi
         GAYkh6ezuDtBgVYuX37XcK9HJzh/LCRz5KWydSbaV+5I0nXVT+srrmjPetqo1yNtgbRn
         6lz0Ja7E1OQ3aXTyWRjtMeFq2HQZcP9/LMY/Kq121AwnpbmUwMD6yUFODg3fd8MjmY/P
         VFJvguGQWyZyueXYOEHNYAT35D7sr4qDszBnU2mdbt37m/RnLHbEGzbK7yotbBB9SgJR
         +YZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776282835; x=1776887635;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oYmr9khsTqs70UAtFkmFAILnU1WTG8FTB2ZGQVFARNY=;
        b=Tt0OYVccv7+nAnY9ga0clafdYlxR9fFakMQ4+26ljr51MWuLDna9V3DzO3SYKehBEo
         9KKzGYCnIh5jjShaUROETxf5lQvPve2nDnG8S75genrKHiWfVCum3ctdaFb18Cf8i4Jr
         Tyf82leX2MFrItjhwmmnioBWbFne5VOME7dDNrYxWjON26cCL9/9SX0BNQdS0efYQ9Yq
         46HNmsDfe3RNExCoU5yzNEnJrpfntmzEVLpRU8XOv8RGsAXzZQTdixyDHjQjMEIe6j9B
         M+BQYnSLnvwtx7YpOD5RLdH0VRQDJwYFvQH2SBmNsVOHmAUtcaEOMgEb3kpRxIpo/PC8
         BQWQ==
X-Gm-Message-State: AOJu0YwIjyJ5ZSIeklSwCYSWYr5Nb3G0vxzpH3fYai/rfbKnKGhpYdS1
	LHh+5pKJNTbuD3VNbUfCVg4hiaIN1pyBBxI8R7wHv9ddw3gBMs8isHSll7gBSsU7tOoXb4UVh0s
	gE7isV2nFa2rZuh7hBfP2+HgWxVC1D58=
X-Gm-Gg: AeBDiesXYIVn7XJiDY6bgxYnb1w3r9tDHaP/bIVqX5dp/o+cO7rs9sgiPMsBcbPjE6Q
	2KD4CI7CoYBailrxgOqi+K65DeAI2N17e/aZ694rAPjv9hXqC3te8hy29mE1rqtu0/JgbVqt47O
	EWYvWzCnk6RMVFavTl9ZzJwh/l5ScNLI2GgzeNSUtvyxNKH+2tHwC67xnzeP45jTOk/g9jWEOix
	W3j39eCt182q7DiNXKMPBKEV8qWEG4Rc0uWFbq7/fOZc9TDhessT2WXhrHGvw7hPa3qGSj8zgHb
	2BNO
X-Received: by 2002:a17:907:6ea7:b0:b9b:207c:f7ba with SMTP id
 a640c23a62f3a-b9d724ef918mr1382024266b.4.1776282834335; Wed, 15 Apr 2026
 12:53:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <afefde93-1f6a-4b3b-976b-87105615f931@gmail.com>
In-Reply-To: <afefde93-1f6a-4b3b-976b-87105615f931@gmail.com>
From: Matteo Croce <technoboy85@gmail.com>
Date: Wed, 15 Apr 2026 21:53:18 +0200
X-Gm-Features: AQROBzB-8lzbdhqAG74U3RZCcKrQqHnfQ_1jPLloGSd3cGfjo7FdsUhyaONIyT8
Message-ID: <CAFnufp0wpLD7qx8jwEevu3u=0UUfbaBLayx=1LvanpUB01r8=g@mail.gmail.com>
Subject: Re: mt7996e kernel panic
To: Felix Fietkau <nbd@nbd.name>, Lorenzo Bianconi <lorenzo@kernel.org>, Ryder Lee <ryder.lee@mediatek.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi,

I confirm that the router keeps on crashing even with 6.12.80 and latest mt76.
As I workaround I'm loading mt7996e with wed_enable=0 and i'ts been
stable since a week.

Regards,
-- 
Matteo Croce

perl -e 'for($t=0;;$t++){print chr($t*($t>>8|$t>>13)&255)}' |aplay
