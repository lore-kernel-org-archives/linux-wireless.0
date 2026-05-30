Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1B9C30674D
	for <linux-wireless@vger.kernel.org>; Sat, 30 May 2026 15:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780156343; cv=none; b=Ifn0PElQNnCMzPdPdUC+L4RaYr6UhJ5fWzizHNew2b1NzHKL3A7jfXH0QgI60+kKTfPBGai0ER9B+ntrBb1l772KUjSM9UCp1vIZoBtbLLZbUIxwiWk0K9SUW+3fwzuh1KjTatlQqVGhyOY2yKld/02N0liXyi7IIUiqg32K9/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780156343; c=relaxed/simple;
	bh=20ckuDczkr0a7xuLE/qJD8u93y4SGocEPVOIDBQNvDQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ul2bhOG6mI+Lb5yqmpa2t1eU5JJx22A+6yocjY34oPO+qVrUKSV2JKNyg/G1N5yZ32+Gby52KUWG3rLrzxM9IIC6ZAsyTwv5OoG1F5HhFFspxXslRcPF4azlEVXPfUdGU3yZ9WGFZi3TN5VjXx7+ThGWWJ+B1GklAaw5jGeuPHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OeeYGT58; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OeeYGT58"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F5451F00899
	for <linux-wireless@vger.kernel.org>; Sat, 30 May 2026 15:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780156342;
	bh=gROVG8FRtJTTDahQ9ls/6doABZN3o3r0v80py5sMo3s=;
	h=References:In-Reply-To:Reply-To:From:Date:Subject:To:Cc;
	b=OeeYGT58ybQ23FGUWa9n4+qOCYpOSI/rPYZazSWeoeoQRGD4SgSj1YS/TnM3WRvt3
	 56v5pn3FDaXjlxPxNPHaUCEhKOwPb3yj8cwtCsMAnyi0woz2kC+lqTSPzCsStqSusV
	 za2hGhOi3z/wIguJrU88yb36i5xW/tp4WXp28BFsRFMQytGApkbA7o49b28tw4GgH0
	 YJNuZkOEmib6e9nE++iu/XyHXnvCO96+F98ssh5k3/GsQfWa62dwW3UNDh7u+bLJe0
	 MKVV3IVPd+a/6xiFGKpKUj67CjA4BuSMJ/jFc62MUhAJr4vigGx9iokGdQHqvT2at1
	 9bzndJBIlrDWw==
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-396753f343aso1359821fa.2
        for <linux-wireless@vger.kernel.org>; Sat, 30 May 2026 08:52:22 -0700 (PDT)
X-Gm-Message-State: AOJu0YxAFsxNf+u8wU9buGCP1mas5bNkVq6epRGTwG+Lj4XUg6Sa6rVH
	uFcpqHzZxvZkrjgC8SaYpL1hOHMP+WodBKwqulQPxa7wHqSGsNG7+iVZG14v7gufsYZMdm6VpCM
	fM1lkM2wKwSv9fA5gXUgvIcbJIp8/zJA=
X-Received: by 2002:a05:651c:40d7:b0:392:c9a:ac43 with SMTP id
 38308e7fff4ca-39664eaa9e1mr7899251fa.8.1780156340894; Sat, 30 May 2026
 08:52:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260428093058.3672383-1-me@0upti.me> <177751439231.3356117.7542785326182742344.b4-ty@kernel.org>
 <d18d4ba0-9fc6-4585-8161-610ec42fdab4@0upti.me>
In-Reply-To: <d18d4ba0-9fc6-4585-8161-610ec42fdab4@0upti.me>
Reply-To: wens@kernel.org
From: Chen-Yu Tsai <wens@kernel.org>
Date: Sat, 30 May 2026 18:52:07 +0300
X-Gmail-Original-Message-ID: <CAGb2v66ec4fxBqOwNCZpVKNdY0eUPPftPQTK1v96VWpwYhi8bA@mail.gmail.com>
X-Gm-Features: AVHnY4K5oAcDsMiqVYjJNazV2A57V45lccR1WlI8LsYy48sire-gV85xHNZFLy4
Message-ID: <CAGb2v66ec4fxBqOwNCZpVKNdY0eUPPftPQTK1v96VWpwYhi8bA@mail.gmail.com>
Subject: Re: [PATCH v2] wireless-regdb: allow 320MHz channel width for Russia
To: Ilya K <me@0upti.me>
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org, 
	Louis Kotze <loukot@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 27, 2026 at 7:48=E2=80=AFPM Ilya K <me@0upti.me> wrote:
>
> >
> > Applied to master in wens/wireless-regdb.git, thanks!
> >
> > [1/1] wireless-regdb: allow 320MHz channel width for Russia
> >       https://git.kernel.org/wens/wireless-regdb/c/62d72c287e99
> >
> Hi, can we get a signed tag with this included?

It's tagged and released today.


ChenYu
