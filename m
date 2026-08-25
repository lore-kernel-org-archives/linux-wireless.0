Received: from mta0.migadu.com (out-82.mta0.migadu.com [91.218.175.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC13C184524
	for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2026 07:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.82
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787642453; cv=none; b=M4FwVAmIfGDJmPsayWmLxDcUffNMV/t67pYIcIEsMU8oVOfsUc7C5BIfdfciTJM2O7eba/xx9V1hw9cyoaGpKfGmngTyPgQcsluKQ6sveA8x7+mTULeupMcslzh+drauT8U8E5pm9x6GQngjK49Jx2m91g/yX4D1vKG8xEMTiAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787642453; c=relaxed/simple;
	bh=zbQoYKop0ApksTcvsd7Pk4080zwPSAAbo2YpIGmt1fc=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=GfkdeTbyqvXVLFt3s/QRJMyDRVQiO2UzGWeOlP7857uXeTTME6KmH2NuoRjIBVPjmdv6ocmvSwlRR7D1KoecfCTiWe7s39AUaZYxOB+etAyD9uIQw4YVq4Sb/l2ONDLg6D6KI5XGRW78pLkdoO+QPrzHK/DfoRojlKDUezfsXTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=srKzbGV8; arc=none smtp.client-ip=91.218.175.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="srKzbGV8"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=zbQoYKop0ApksTcvsd7Pk4080zwPSAAbo2YpIGmt1fc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787642449; v=1; x=1788247249;
 b=srKzbGV8zTT9ADlOMnYFKXWqxxTVKyA+CCHGvhSOhCjKGKLs8TWWYUKEOcpGHhay34xmvacY
 HRQ7ruFMTFYgY2LZGYrm8pW8DG8xsPQZEdlYY8eqEybhyTgVVtzlpI8urn9ADDJ8YJ0XufbV3yu
 PNjjHEIOezLgj7EAcSvi8ydI=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: from ehlo.thunderbird.net (31.223.131.35)
	by smtp.migadu.com with ESMTPS id 8276264f119ed4fb;
	Tue, 25 Aug 2026 07:20:49 +0000
X-Mizu-Trace-ID: 8276264f119ed4fb
X-Migadu-Flow: FLOW_OUT
Date: Tue, 25 Aug 2026 09:20:47 +0200
From: Luka Gejak <luka.gejak@linux.dev>
To: Ping-Ke Shih <pkshih@realtek.com>,
 "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Michael Straube <straube.linux@gmail.com>,
 Bitterblue Smith <rtl8821cerfe2@gmail.com>,
 Peter Robinson <pbrobinson@gmail.com>,
 Hans de Goede <johannes.goede@oss.qualcomm.com>, luka.gejak@linux.dev
Subject: =?US-ASCII?Q?RE=3A_=5BPATCH_v7_4/6=5D_wifi=3A_rtw88=3A_sdio=3A_track?=
 =?US-ASCII?Q?_free_TX_pages_and_OQT_credits_for_RTL8723BS?=
User-Agent: Thunderbird for Android
In-Reply-To: <17c3c1f641fe41c4bfacb989af4b75a6@realtek.com>
References: <20260820090412.19574-1-luka.gejak@linux.dev> <20260820090412.19574-5-luka.gejak@linux.dev> <17c3c1f641fe41c4bfacb989af4b75a6@realtek.com>
Message-ID: <AD323744-AE68-4C77-92A9-CD215B8A7E43@linux.dev>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Ping-Ke,

On August 25, 2026 8:12:58 AM GMT+02:00, Ping-Ke Shih <pkshih@realtek=2Eco=
m> wrote:

> I think you only need to note 'not free the skb on failure'=2E
> And move comment here to note __skb_pad()=2E
> By the way, we can have a local variable 'pad_size'=2E

Done, all three:

        if (write_size > skb->len) {
                size_t pad_size =3D write_size - skb->len;

                /*
                 * __skb_pad() must not free the skb on failure: both call=
ers
                 * still own it, one requeues it and the other frees it=2E
                 */
                ret =3D __skb_pad(skb, pad_size, false);
                if (ret)
                        return ret;
        }

> Not sure if the comment along declaration of tx_credit_lock is enough?
> If so, maybe we don't need this comment=2E

Agreed, that one is gone=2E

> guard(mutex)(&rtwsdio->tx_credit_lock);

The lock is only taken for this chip, and guard() is unconditional, so I
split the locked region into its own function instead of branching around
the lock:

        if (!rtw_is_8723bs(rtwdev)) {
                txsize =3D sdio_align_size(rtwsdio->sdio_func, skb->len);

                ret =3D rtw_sdio_check_free_txpg(rtwdev, queue, txsize);
                if (ret)
                        return ret;

                return rtw_sdio_write_to_port(rtwdev, skb, queue, txaddr,
                                              txsize);
        }
        =2E=2E=2E
        guard(mutex)(&rtwsdio->tx_credit_lock);

        return rtw_sdio_8723bs_write_port(rtwdev, skb, queue, txaddr, txsi=
ze,
                                          write_size);

The transfer itself moved to rtw_sdio_write_to_port() so both paths share
it=2E That also removes the goto and the two rtl8723bs tests in the middle=
 of
the function=2E

One thing I would like your opinion on while it is still cheap to change=
=2E
The unaligned SKB warning now sits in both callers rather than once inside
rtw_sdio_write_to_port(), because __func__ would otherwise report
rtw_sdio_write_to_port for every other SDIO chip where it reports
rtw_sdio_write_port today=2E Keeping that message identical costs three
duplicated lines=2E Putting it once in rtw_sdio_write_to_port() is the
tidier code and arguably the more accurate message, at the price of
changing a log line on chips this series is not about=2E I went with the
duplicate to leave the other parts alone, but I have no strong feeling
either way, so say which you prefer=2E

> I think you can add lockdep_assert_held() to the places the locks (mutex=
)
> must be held, and run test if somewhere throw warning (must not)=2E

Added to rtw_sdio_8723bs_write_port(), rtw_sdio_8723bs_wait_tx_oqt() and
rtw_sdio_8723bs_consume_txpg()=2E Each has exactly one caller and all thre=
e
sit under the guard, so the call graph says they cannot be reached without
the lock=2E

I have to be straight about the test though: my test kernel is built
without CONFIG_PROVE_LOCKING, so those asserts compile to nothing there an=
d
running it would prove nothing=2E I will build a kernel with lockdep enabl=
ed
and confirm before I would ask you to take the patch on that point, unless
you would rather I just drop the asserts=2E

Best regards,
Luka Gejak
