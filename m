Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="OYFFVmXU"
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:242:246e::2])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E898F1718;
	Fri, 24 Nov 2023 09:37:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=aPWbKdwcZDf7/l7h1E2fzU2EX2i//JsMQ/TQX0MlYO8=;
	t=1700847440; x=1702057040; b=OYFFVmXUE7+r6q0y0ccj+Z3xYsVU6EL8677KJTKx2+r8HRQ
	cyMkPRfypnjiBGAu7liXyykTBOTUdfVJ77XGFi//YeCQskciFRbV3sMvGow98tsC0RQ5QzCcSKyVW
	DunLxBn7SzHrlxopQCIbBBAuonM2vsk6XriyZm/E2T4Az0Y4z4CEatt1e6BhUShsdpH4JlR0z+4hZ
	MINysVnrE6vfxx7fQLZLjFy56gkFLgvj1Ms+r2Bne2wKUe1+bDpO2iemPxNDW8cmtip+4q8jfLqG2
	dXp8y3ZN4hsjPR+iJSG7VCouGw2sxcEcl0WuwEeLsUlzSLom0CzkK2UQu3wxo/cw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.97)
	(envelope-from <johannes@sipsolutions.net>)
	id 1r6a79-00000002hHE-3BIc;
	Fri, 24 Nov 2023 18:37:16 +0100
Message-ID: <f0bebfe0f7e02bb51676d8f6a80be0444e2b8662.camel@sipsolutions.net>
Subject: Re: [PATCH] uapi: propagate __struct_group() attributes to the
 container union
From: Johannes Berg <johannes@sipsolutions.net>
To: Dmitry Antipov <dmantipov@yandex.ru>, Kees Cook <keescook@chromium.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, Will Deacon <will@kernel.org>, 
 Kalle Valo <kvalo@kernel.org>, linux-wireless@vger.kernel.org,
 linux-kernel@vger.kernel.org, kernel test robot <lkp@intel.com>
Date: Fri, 24 Nov 2023 18:37:14 +0100
In-Reply-To: <20231120110607.98956-1-dmantipov@yandex.ru>
References: <20231120110607.98956-1-dmantipov@yandex.ru>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Mon, 2023-11-20 at 14:05 +0300, Dmitry Antipov wrote:
> Recently the kernel test robot has reported an ARM-specific BUILD_BUG_ON(=
)
> in an old and unmaintained wil6210 wireless driver.
>=20

Heh. I guess it wasn't unmaintained enough for someone to touch it and
add struct_group() to it...

>  include/uapi/linux/stddef.h | 2 +-
>=20

No idea what tree this should go through, but I guess wireless isn't
appropriate.

johannes
