Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B30A7175A7F
	for <linux-wireless@vger.kernel.org>; Sun, 28 Jun 2026 06:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782628642; cv=pass; b=hbN6AswobMhMXVvzqmBxhRuRACKDkCkmzwME0aCYRbNWLtkgOE5n2RVfgf7JE/AVqiTzoajCsE1QjBcxjVAf5SD5Flj0KyqsKSGTGoRDCFx9qpAuRkmhPx/daQE4tYAMfAzq9Is401fvpZOKVqSCVga0U1eDdgV40P4GSA3XZVI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782628642; c=relaxed/simple;
	bh=dX/qyZlPM8cB3iHqP1m+RbEp1XX1FDdi4EdRMnmTEAU=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=dVWPaHcG1JasWIzRxNcueiR63J+kVr1rQKrC3MMJm8MEClNsyGfbHTSulqc5fhTWgOU4AHB+Wel1xjhsaqKlLFBx++MiAgVh9tJxd6q/w0zhoYQ/LjP7V7Nl1Vj0JXxzJ8OEq6XUXmAUOTaDmNcwm0oR6E3eqcUH1xepkm0dtY4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H3BGAhcE; arc=pass smtp.client-ip=209.85.128.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H3BGAhcE"
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-800619d5e7eso29524067b3.0
        for <linux-wireless@vger.kernel.org>; Sat, 27 Jun 2026 23:37:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782628641; cv=none;
        d=google.com; s=arc-20260327;
        b=Z/eysxCWO8fB9dxxNVDl3nr6dhskzS0G+6Ei7+qO6iWONnlwnoimcvchqtitvPqFaU
         LVXnp8MvKQd1IFjR33S//xJe6qSmnv3htRru+ZOHVfYH/sMXYx8a5ZVk+73LCvloigH4
         rMRktSd3gUxhx2pm58ojumYu8Ln0ezRbCFkWTOOLQdVKSN5e31EJSzIlbnmY6HLFXE3G
         u/YJ3GCiQiHHtXAXfG7rjlLxvEkgF7rLAoWPfGrSQlKTj14mvHhObIJ5fKpt5qqcM34c
         r6zUHPluYZ0bX1WoYNzBxXDQMQmi4pdiUnF+RwetFf3lZybUH8v7+/L3rKhvNAVq0x2h
         WBGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=NJrYPlgkNF2Vakuo/uExz62wdrU0jLhDNp7huh7YI9I=;
        fh=hYLqwXhlzhZ/F+57foUaN9gOwER9wDdCz0ZuPpyV6uA=;
        b=ZtowQMKF+/Lqla85/ErBYBrIn3mff/auMXrbjGOasjhLgi+7RkxrE2UaowW5MNrLba
         XK9UgM49JyQjbWH8IktZjXswWIrT413MXvlL3dP6/jvy2/4OVfBXDcPNZusoZYZKFZ47
         PmYRi1T8IVw0AgNgPkZ7wHhgN5bPHLxU3DLo4HsWQ6tPd8IKLwGIMNEeVLOMImUmrd37
         6mxRdGFk1LR0g0AxAZizXyU/0vlra/y+X6stk+xepfBeGbuTMRPh/Nd9AYQ8GWgpsabZ
         CMq2r+gubVOxGKnhYTtjhWewKKQCyEd4/oXCZyCJ+SbHi3msE1ImOecEBKOM6XO+GzaO
         OKxQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782628641; x=1783233441; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=NJrYPlgkNF2Vakuo/uExz62wdrU0jLhDNp7huh7YI9I=;
        b=H3BGAhcE658tH64H4vxEVTHhbINbD970S2kc3oMpbNjXUq8jljmzOjdJGAJNYQSBDf
         9I6nMq5Rxc3wFNzh0NXZBVhcxxfIew7HRJ4H9ci/Vwdx4cc6aT1CUxC3lJw1S51xzcFU
         Q+NEY/jKJ0YLKZ5CcrnkjAvcxGPgyfvAnWD/F0fH3rBABS10VIMDOhUfD67qxlYIcb/v
         frAFYVF8cpamrHpxZP0bD2nTBXDtjRYiEZppxUHNqXlOHwIlgAzkZi5T9ol0MEk+C+iA
         FhPd3bnV/Lttec/nvy1luAna+UY06V8wi9H99hfBQ9rf60oTpS9v5ZsvHzkL0hIlIApO
         ORkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782628641; x=1783233441;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NJrYPlgkNF2Vakuo/uExz62wdrU0jLhDNp7huh7YI9I=;
        b=FTw0FCZWZRUXq+1c88lOEqHpFAF3QG4yjbI079CjURKBlIrUP8ygW74gpb3eQ/hH3K
         9ML5xRimDYxOl4rBXvTZoJU/+uNDIxcUOdKLcD8L9fbjaaqaBR/TX4MdB8WZXtRzvrwF
         hWcMl/O/BYGJB6VcpaZNFR0Zqn69T1fY2zPK8uqCX0d2YPuiJI0YSD+8lRXsAwSjlHut
         SUOEtK9xOMmxoN84f3lHIjw7HLz642J2Nsgpic0t3x16g2CSMByKlxfcfOsre5PLpQ2F
         vO0PceHbd65ugpHSTpNskLqniunv0ToaGpEN15mBRMlwtnen3/ZX6nCoOKvM+qSkNhUA
         aCyw==
X-Gm-Message-State: AOJu0YxK8aMp8c5w/w87eHQSn3r6Uy4fKJIGQNbJ07Q31My9W7wPxpoJ
	lbuwKCyaZE3dhNDUHpdEkYlj+yDaLvh379Qp551tAlZ5QF8RGlFlBa5k+9j+/ORwYddStrSuplj
	8yWanA0R+7Rv67w2JOXPeo3Kf+Oh7/JjAL6oE
X-Gm-Gg: AfdE7clIgUu4GsAbtGMq+sY0gvfCdvHabPW+6lGXOgVEeCjjOsCSF65N+pJdU7gcwrv
	yqwyhBtezUdK0rSjocodNkBrOrtC83KtNWLy4UeYpDfCJT0nGYlDrsH0hOqCbUGOrbEaEHI/yUY
	bju7W0qCZ59GhAw2eBkiN+CQjbUfhAkCjwAbPpacbEm/ayld3DX5aJLWHTiJ82x20v5oVM58QT5
	LI5xN2UxNgUzPfEvQJvs1D7/Jh7t7eI4qvTMTSuY2ZAr0r0hIf2uoA7TxVNQZYDoBt0rDKK6w==
X-Received: by 2002:a05:690c:884:b0:80c:2365:875f with SMTP id
 00721157ae682-80c7260777emr66397137b3.20.1782628640666; Sat, 27 Jun 2026
 23:37:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Doug Brewer <brewer.doug@gmail.com>
Date: Sun, 28 Jun 2026 14:37:09 +0800
X-Gm-Features: AVVi8Cc-t0y7oE7EAn_Auei_Pwywa6wqUnQM6QY9vPL-GCU8PU-_HhT7JOaVOKg
Message-ID: <CAG0V13TRHzXtoMY=XZMOd=WjzS58Cu=aePFCz8mY6UoGYm5dXw@mail.gmail.com>
Subject: rtw89: RTL8852BE P2P-device iftype and STA+P2P interface combination
To: linux-wireless@vger.kernel.org
Cc: Ping-Ke Shih <pkshih@realtek.com>
Content-Type: text/plain; charset="UTF-8"

Hi,

I'm experimenting with Wi-Fi Display (Miracast sink) concurrent with an
STA connection on an RTL8852BE (PCIe) using the mainline rtw89 driver
(kernel 6.18.37).

iw phy reports:
Supported interface modes:
   * managed, AP, P2P-client, P2P-GO
   (no P2P-device)
interface combinations are not supported

In practice this blocks the standard P2P flow: there is no P2P-device
iftype for a dedicated discovery context, and no advertised interface
combination for managed + P2P-client coexistence.

My questions:
1. is P2P-device iftype support planned for rtw89 on RTL885x? Is there a
    known technical blocker, or is it simply not yet implemented?
2. would advertising a managed + P2P-client interface combination
    (single channel) be feasible on the current rtw89?
3. is MCC (#channels > 1) on the roadmap, or considered out of scope?

Regards,
Doug
