Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA26D2F49F1
	for <linux-wireless@vger.kernel.org>; Sun, 19 Apr 2026 20:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776629530; cv=none; b=GsPMjPTfc2iZI8PLX/ilL27Xs/Ej7JARks2iM/KWtA52xE4aalFISS8UDFd9CPfDcBNwGZgsTI8sisctkMipyGICvq1bI52AVYqM6S4HZQorhQOWPrXNn5MTXhpU73fIbPhfPqD/Mi8B52IBhopuaQ88sjAuE+pxSLdNtWfhG04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776629530; c=relaxed/simple;
	bh=OAMdrPYK5OV+e4A3PfNzbz835UpVFOyL7nAyo4Bzd74=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UGnIakv0sODo5kzwGSJSOvAicjjzDMQQaAG90m1lX++OeoAm8Ykv0kuyVl8yVdc9nPXKTfvB8b5bgXetA/eqh2rvQJHALKdUMyb1ZfzNYoV8EK3Ontb6oXQ5iUTjET0xYk4l5DUl6R3Ghn0NFjGv/NnoZLKkIjzCLvHI+hj3QyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nRo/2AVm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nRo/2AVm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 891D9C2BCC4
	for <linux-wireless@vger.kernel.org>; Sun, 19 Apr 2026 20:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776629530;
	bh=OAMdrPYK5OV+e4A3PfNzbz835UpVFOyL7nAyo4Bzd74=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=nRo/2AVmwPolgfGOXy14+dpwclEBZBvgGgT7MAlxO4NavhyOo6dvn/Yyr6+ck2ttf
	 n6tfKCYZsdPagG10cjsD4+wIpQ81qjBsW2K3vrg9Vh3Z/xXgmq1FPST6cu1jb17Y6U
	 AjpsVYfkQ9m97aSleN94z6n3qkmkjG6gOZApPZW1riD04Ir6G/5IydEVvB8N1xXbDV
	 NaadMP2ZhoguQrKLYgHnbH2ExeU6tUSdmT51OhnAXTZW7Ypuuj+4KIAhVwdHXN9V+n
	 UwA3rnoMwSfQOlixeu++vJL8/3D3Ia8ovddPw0Hne0bOh21wrqB3zzPPQ7tEQplSAp
	 9M/UjwbSsrGWw==
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5a40cfab24dso2572497e87.2
        for <linux-wireless@vger.kernel.org>; Sun, 19 Apr 2026 13:12:10 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+YOgkcVPPwrHZYpPdujiQOYFJfM2nYwP/iIDOVtUUkVurH9sO0x0p5+asFToLXVSVO+ypzOv4D6FQDYc1cVQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwSATwFzQAA1kJLM0GqlodBDDYxjX2AVejAQsdHm85eyYvDqBfj
	r9u07klHsYuKYhZHH6KG1jfUT96CN5GxhGWWPjAv05vNbeKTi6Or+qOzPRanDTo2qF51A3gV7MC
	NuevG7ozqLTx3kMaE3AQBDiLloqaskUw=
X-Received: by 2002:a05:6512:3c9d:b0:5a3:fd83:13f7 with SMTP id
 2adb3069b0e04-5a4172ba690mr3178772e87.6.1776629528998; Sun, 19 Apr 2026
 13:12:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260417173621.368914-1-ynorov@nvidia.com> <20260417173621.368914-5-ynorov@nvidia.com>
In-Reply-To: <20260417173621.368914-5-ynorov@nvidia.com>
From: Linus Walleij <linusw@kernel.org>
Date: Sun, 19 Apr 2026 22:11:57 +0200
X-Gmail-Original-Message-ID: <CAD++jLmeFP4CHf+PZdR4gWW7ZFiN9LDNeXADQXcM0e5eJOO_rw@mail.gmail.com>
X-Gm-Features: AQROBzA9qeeVj2Ps3N0YEWnbfhWwJYO6GUSEavstda-gTisTP6p1HIZ-NbjdBrk
Message-ID: <CAD++jLmeFP4CHf+PZdR4gWW7ZFiN9LDNeXADQXcM0e5eJOO_rw@mail.gmail.com>
Subject: Re: [PATCH 4/9] iio: magnetometer: yas530: switch to using FIELD_GET_SIGNED()
To: Yury Norov <ynorov@nvidia.com>
Cc: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Jonathan Cameron <jic23@kernel.org>, David Lechner <dlechner@baylibre.com>, 
	=?UTF-8?B?TnVubyBTw6E=?= <nuno.sa@analog.com>, 
	Andy Shevchenko <andy@kernel.org>, Ping-Ke Shih <pkshih@realtek.com>, 
	Richard Cochran <richardcochran@gmail.com>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Alexandre Belloni <alexandre.belloni@bootlin.com>, Yury Norov <yury.norov@gmail.com>, 
	Rasmus Villemoes <linux@rasmusvillemoes.dk>, Hans de Goede <hansg@kernel.org>, 
	Sakari Ailus <sakari.ailus@linux.intel.com>, Salah Triki <salah.triki@gmail.com>, 
	Achim Gratz <Achim.Gratz@stromeko.de>, Ben Collins <bcollins@watter.com>, 
	linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org, 
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org, 
	linux-rtc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 17, 2026 at 7:36=E2=80=AFPM Yury Norov <ynorov@nvidia.com> wrot=
e:

> Switch from sign_extend32(FIELD_GET()) to the dedicated
> FIELD_GET_SIGNED() and don't calculate the fields length explicitly.
>
> Signed-off-by: Yury Norov <ynorov@nvidia.com>

Very nice,
Reviewed-by: Linus Walleij <linusw@kernel.org>

Yours,
Linus Walleij
